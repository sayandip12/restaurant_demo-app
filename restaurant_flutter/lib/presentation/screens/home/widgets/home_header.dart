import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black, size: 28),
        onPressed: () => context.push('/menu'),
      ),
      title: Row(
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              int tapCount = 0;
              Timer? resetTimer;
              return GestureDetector(
                onTap: () {
                  tapCount++;
                  resetTimer?.cancel();
                  resetTimer = Timer(const Duration(seconds: 5), () {
                    tapCount = 0;
                  });
                  if (tapCount == 7) {
                    tapCount = 0;
                    resetTimer?.cancel();
                    _showSecretPinDialog(context);
                  } else if (tapCount > 7) {
                    tapCount = 0;
                    resetTimer?.cancel();
                  }
                },
                child: Image.asset('assets/images/logo.png',
                    height: 32, fit: BoxFit.contain),
              );
            },
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rita Foodland',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              Text(
                'AUTHENTIC CUISINE',
                style: TextStyle(
                  color: AppColors.accent.withValues(alpha: 0.9),
                  letterSpacing: 1.5,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.security_outlined, color: Colors.black87),
          onPressed: () => context.push('/profile'),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () => context.push('/offers'),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void _showSecretPinDialog(BuildContext context) {
  final TextEditingController pinController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Admin Access'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter Secret PIN',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (pinController.text == '1971') {
                Navigator.pop(context);
                context.push('/admin-login');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Access Denied')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Enter'),
          ),
        ],
      );
    },
  );
}
