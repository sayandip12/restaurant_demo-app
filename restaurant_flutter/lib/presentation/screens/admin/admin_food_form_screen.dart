import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_config.dart';
import '../../../domain/entities/menu_item.dart';

class AdminFoodFormScreen extends StatefulWidget {
  final MenuItem? foodItem; // null for add, non-null for edit

  const AdminFoodFormScreen({super.key, this.foodItem});

  @override
  State<AdminFoodFormScreen> createState() => _AdminFoodFormScreenState();
}

class _AdminFoodFormScreenState extends State<AdminFoodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _halfPriceController;
  late TextEditingController _fullPriceController;
  bool _inStock = true;
  String _selectedCategory = 'popular'; // Default category
  
  bool _isLoading = false;
  File? _selectedImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodItem?.name ?? '');
    _descController = TextEditingController(text: widget.foodItem?.description ?? '');
    _halfPriceController = TextEditingController(text: widget.foodItem?.price.toString() ?? '');
    _fullPriceController = TextEditingController(text: widget.foodItem?.priceL?.toString() ?? '');
    _inStock = widget.foodItem?.available ?? true;
    
    // In a real app we'd load categories from provider, but for simplicity here we just use the known ones
    // We would need to pass category_id if we have it in MenuItem, but MenuItem entity doesn't store categoryId directly.
    // However, the DB requires category_id. We'll default to 'popular' if adding, or hardcode it.
    // Wait, the schema requires category_id. I'll add a dropdown.
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _halfPriceController.dispose();
    _fullPriceController.dispose();
    super.dispose();
  }

  void _setLoading(bool value) {
    if (mounted) setState(() => _isLoading = value);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  Future<void> _pickImage() async {
    if (_isLoading) return;
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compress image
        maxWidth: 800,
      );
      if (image != null) {
        final file = File(image.path);
        // Validate size (< 5MB)
        final sizeBytes = await file.length();
        if (sizeBytes > 5 * 1024 * 1024) {
          _showError('Image is too large. Max 5MB allowed.');
          return;
        }
        // Validate type
        final ext = image.name.split('.').last.toLowerCase();
        if (ext != 'png' && ext != 'jpg' && ext != 'jpeg') {
          _showError('Only PNG and JPG images are allowed.');
          return;
        }
        setState(() {
          _selectedImageFile = file;
        });
      }
    } catch (e) {
      _showError('Error picking image');
    }
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate()) return;
    
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError('Name cannot be empty.');
      return;
    }
    if (_halfPriceController.text.trim().isEmpty) {
      _showError('Half price cannot be empty.');
      return;
    }
    final halfPrice = int.tryParse(_halfPriceController.text.trim());
    if (halfPrice == null || halfPrice < 0) {
      _showError('Invalid half price.');
      return;
    }
    int? fullPrice;
    if (_fullPriceController.text.trim().isNotEmpty) {
      fullPrice = int.tryParse(_fullPriceController.text.trim());
      if (fullPrice == null || fullPrice < 0) {
        _showError('Invalid full price.');
        return;
      }
    }

    _setLoading(true);
    
    String? newImageUrl;
    String newImagePath = '';
    
    try {
      final isEditing = widget.foodItem != null;
      final foodId = isEditing ? widget.foodItem!.id : DateTime.now().millisecondsSinceEpoch.toString();

      // 1. Upload new image if selected
      if (_selectedImageFile != null) {
        final ext = _selectedImageFile!.path.split('.').last;
        newImagePath = '$foodId-${DateTime.now().millisecondsSinceEpoch}.$ext';
        
        await Supabase.instance.client.storage
            .from(AppConfig.supabaseStorageBucket)
            .upload(newImagePath, _selectedImageFile!);
            
        newImageUrl = Supabase.instance.client.storage
            .from(AppConfig.supabaseStorageBucket)
            .getPublicUrl(newImagePath);
      }

      final finalImageUrl = newImageUrl ?? widget.foodItem?.image ?? '';
      final isAsset = newImageUrl != null ? false : (widget.foodItem?.isAsset ?? true);
      
      final payload = {
        'id': foodId,
        'category_id': _selectedCategory, // Simplification for demo
        'name': name,
        'description': _descController.text.trim(),
        'half_price': halfPrice,
        'full_price': fullPrice,
        'is_available': _inStock,
        'image': finalImageUrl,
        'is_asset': isAsset,
      };

      // 2. Update Database
      if (isEditing) {
        await Supabase.instance.client
            .from('menu_items')
            .update(payload)
            .eq('id', foodId)
            .timeout(const Duration(seconds: 15));
            
        // 3. Clean up old image if it wasn't an asset and a new one was uploaded
        if (newImageUrl != null && widget.foodItem!.image.isNotEmpty && !widget.foodItem!.isAsset) {
          try {
            // Extract path from public URL (everything after bucket name)
            final uri = Uri.parse(widget.foodItem!.image);
            final segments = uri.pathSegments;
            final oldPath = segments.last; // Assuming simple flat structure
            await Supabase.instance.client.storage.from(AppConfig.supabaseStorageBucket).remove([oldPath]).timeout(const Duration(seconds: 10));
          } catch (e) {
            // Ignore error cleaning up old image
          }
        }
      } else {
        await Supabase.instance.client.from('menu_items').insert(payload).timeout(const Duration(seconds: 15));
      }

      _showSuccess('Food saved successfully!');
      if (mounted) context.pop();
      
    } on StorageException catch (e) {
      if (e.message.contains('Bucket not found') || e.message.contains('404')) {
        _showError("Storage bucket 'menu_images' is missing. Please create it in Supabase Storage.");
      } else {
        _showError('Storage error: ${e.message}');
      }
    } on PostgrestException catch (e) {
      if (e.code == '42501' || e.message.toLowerCase().contains('policy')) {
        _showError('Permission denied: Administrator privileges required.');
      } else {
        _showError('Database error: ${e.message}');
      }
      if (newImagePath.isNotEmpty) {
        try {
          await Supabase.instance.client.storage.from(AppConfig.supabaseStorageBucket).remove([newImagePath]);
        } catch (_) {}
      }
    } on TimeoutException catch (e) {
      _showError('Network timeout. Please check your connection.');
      if (newImagePath.isNotEmpty) {
        try {
          await Supabase.instance.client.storage.from(AppConfig.supabaseStorageBucket).remove([newImagePath]);
        } catch (_) {}
      }
    } catch (e) {
      _showError('Failed to save food: $e');
      if (newImagePath.isNotEmpty) {
        try {
          await Supabase.instance.client.storage.from(AppConfig.supabaseStorageBucket).remove([newImagePath]);
        } catch (_) {}
      }
    } finally {
      if (mounted) {
        _setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.foodItem != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Food' : 'Add Food', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s6),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Picker UI
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            image: _selectedImageFile != null
                                ? DecorationImage(image: FileImage(_selectedImageFile!), fit: BoxFit.cover)
                                : (widget.foodItem?.image != null && widget.foodItem!.image.isNotEmpty)
                                    ? DecorationImage(
                                        image: widget.foodItem!.isAsset 
                                            ? AssetImage(widget.foodItem!.image) as ImageProvider 
                                            : NetworkImage(widget.foodItem!.image),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                          ),
                          child: _selectedImageFile == null && (widget.foodItem?.image == null || widget.foodItem!.image.isEmpty)
                              ? const Icon(Icons.fastfood, size: 64, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),

                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'popular', child: Text('Popular Dishes')),
                      DropdownMenuItem(value: 'specialities', child: Text('Our Specialities')),
                      DropdownMenuItem(value: 'rice_biryani', child: Text('Rice & Biryani')),
                      DropdownMenuItem(value: 'indian_breads', child: Text('Indian Breads')),
                      DropdownMenuItem(value: 'chinese', child: Text('Chinese Starters')),
                    ],
                    onChanged: _isLoading ? null : (val) {
                      setState(() {
                        if (val != null) _selectedCategory = val;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.s4),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Food Name', border: OutlineInputBorder()),
                    style: const TextStyle(fontSize: 18),
                    enabled: !_isLoading,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.s4),

                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                    style: const TextStyle(fontSize: 18),
                    enabled: !_isLoading,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.s4),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _halfPriceController,
                          decoration: const InputDecoration(labelText: 'Half Price (₹)', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          enabled: !_isLoading,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            final numVal = int.tryParse(val);
                            if (numVal == null || numVal < 0) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Expanded(
                        child: TextFormField(
                          controller: _fullPriceController,
                          decoration: const InputDecoration(labelText: 'Full Price (₹)', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                          enabled: !_isLoading,
                          validator: (val) {
                            if (val != null && val.isNotEmpty) {
                              final numVal = int.tryParse(val);
                              if (numVal == null || numVal < 0) return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s6),

                  SwitchListTile(
                    title: const Text('In Stock', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Turn off to hide from customers'),
                    value: _inStock,
                    activeColor: AppColors.primary,
                    onChanged: _isLoading ? null : (val) => setState(() => _inStock = val),
                  ),
                  const SizedBox(height: AppSpacing.s8),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveFood,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('SAVE FOOD', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
