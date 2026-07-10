import json
import re
import os
import difflib

# Read flutter food images
flutter_images_dir = r"C:\Users\sarka\Downloads\restaurant_demo-app\restaurant_demo-app\restaurant_flutter\assets\images\food"
flutter_images = [f for f in os.listdir(flutter_images_dir) if f.endswith(('.jpg', '.png'))]

# Read React menuData.js
js_file = r"C:\Users\sarka\Downloads\restaurant_demo-app\restaurant_demo-app\rita_app\src\data\menuData.js"
with open(js_file, "r", encoding="utf-8") as f:
    js_content = f.read()

# Extract the CATEGORIES array
# We need to extract the raw text of the array and convert it to valid JSON or python dict.
# Since it's a bit complex with unquoted keys and JS variables, let's use a dirty regex parse.

categories_match = re.search(r"const CATEGORIES = (\[.*?\n\]);", js_content, re.DOTALL)
if not categories_match:
    print("Could not find CATEGORIES in JS")
    exit(1)

cat_str = categories_match.group(1)

# Clean up JS specific things
cat_str = re.sub(r"id: id\(\),", "id: 'xxx',", cat_str)
cat_str = re.sub(r"([a-zA-Z0-9_]+):", r'"\1":', cat_str) # Quote keys
cat_str = cat_str.replace("'", '"') # Replace single quotes with double quotes
# Fix the badge single quotes that might be broken now (e.g., "badge": "bestseller")
# Wait, replacing ' with " is risky if descriptions have them. Let's just do it and fix manually if needed.

# We will use eval to parse it as python, but we need to map JS booleans and variables
class JSVar:
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return f'"{self.name}"'

def eval_js_obj(match):
    # This is getting too complex. Let's just write a custom parser for the Dart output.
    pass

# Alternative: let's just write a regex that matches each item
items_data = []

dart_output = """import '../../domain/entities/menu_item.dart';

const List<MenuCategory> kMenuCategories = [
"""

cat_regex = re.finditer(r"id:\s*['\"]([^'\"]+)['\"],\s*name:\s*['\"]([^'\"]+)['\"],\s*icon:\s*['\"]([^'\"]+)['\"],\s*items:\s*\[(.*?)\]", js_content, re.DOTALL)

def find_best_image(item_name):
    # Normalize name for comparison
    name_norm = item_name.lower().replace(" ", "").replace("-", "").replace("(", "").replace(")", "").replace(".", "")
    
    best_match = None
    best_score = 0
    
    for img in flutter_images:
        img_norm = img.lower().replace(" ", "").replace("_", "").replace("-", "").replace("(", "").replace(")", "").replace(".", "").replace("jpg", "").replace("png", "")
        
        # Exact match
        if name_norm == img_norm:
            return f"assets/images/food/{img}"
            
        # Diff match
        score = difflib.SequenceMatcher(None, name_norm, img_norm).ratio()
        if score > best_score:
            best_score = score
            best_match = img
            
    if best_score > 0.6:
        return f"assets/images/food/{best_match}"
    else:
        return "" # We'll keep the unsplash link if we can't find a good match

item_id = 1

for cat in cat_regex:
    cat_id = cat.group(1)
    cat_name = cat.group(2)
    cat_icon = cat.group(3)
    items_block = cat.group(4)
    
    dart_output += f"  MenuCategory(\n"
    dart_output += f"    id: '{cat_id}',\n"
    dart_output += f"    name: '{cat_name}',\n"
    dart_output += f"    icon: '{cat_icon}',\n"
    dart_output += f"    items: [\n"
    
    item_regex = re.finditer(r"\{[^}]*name:\s*['\"]([^'\"]+)['\"].*?\}", items_block)
    
    for item_match in item_regex:
        item_text = item_match.group(0)
        
        name = re.search(r"name:\s*['\"]([^'\"]+)['\"]", item_text).group(1)
        price = re.search(r"price:\s*(\d+)", item_text).group(1)
        
        priceL_match = re.search(r"priceL:\s*(\d+)", item_text)
        priceL = f"{priceL_match.group(1)}" if priceL_match else "null"
        
        isVeg = "true" if "isVeg: true" in item_text else "false"
        
        rating_match = re.search(r"rating:\s*([\d.]+)", item_text)
        rating = rating_match.group(1) if rating_match else "4.0"
        
        desc_match = re.search(r"description:\s*['\"]([^'\"]+)['\"]", item_text)
        desc = desc_match.group(1).replace("'", "\\'") if desc_match else ""
        
        badge_match = re.search(r"badge:\s*['\"]([^'\"]+)['\"]", item_text)
        badge = f", badge: '{badge_match.group(1)}'" if badge_match else ""
        
        img_match = re.search(r"image:\s*['\"]([^'\"]+)['\"]", item_text)
        if img_match and img_match.group(1).startswith("http"):
            orig_img = img_match.group(1)
            is_asset = "false"
        else:
            orig_img = "local"
            is_asset = "true"
            
        # Let's find the best image in flutter assets
        best_img = find_best_image(name)
        if best_img:
            final_img = best_img
            is_asset = "true"
        elif not is_asset:
            final_img = orig_img
        else:
            final_img = "assets/images/food/placeholder.png" # Fallback
            
        dart_output += f"      MenuItem(id: 'item-{item_id}', name: '{name}', price: {price}, "
        if priceL != "null":
            dart_output += f"priceL: {priceL}, "
        dart_output += f"isVeg: {isVeg}, rating: {rating}, image: '{final_img}', isAsset: {is_asset}, description: '{desc}', available: true{badge}),\n"
        
        item_id += 1
        
    dart_output += f"    ],\n  ),\n"

dart_output += "];\n\n"
dart_output += """/// Get all items as flat list
List<MenuItem> getAllItems() {
  return kMenuCategories.expand((cat) => cat.items).toList();
}

/// Get popular items (bestsellers + chef recommended)
List<MenuItem> getPopularItems() {
  return getAllItems()
      .where((i) => i.badge == 'bestseller' || i.badge == 'chef')
      .take(8)
      .toList();
}

/// Get chef specials
List<MenuItem> getSpecials() {
  return getAllItems().where((i) => i.badge == 'chef').take(4).toList();
}
"""

with open(r"C:\Users\sarka\Downloads\restaurant_demo-app\restaurant_demo-app\restaurant_flutter\lib\data\static\menu_data.dart", "w", encoding="utf-8") as f:
    f.write(dart_output)

print("Menu data generated successfully!")
