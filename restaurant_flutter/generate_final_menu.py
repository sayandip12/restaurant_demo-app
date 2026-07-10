import os
import difflib
import re

MENU_DATA = {
    "Noodles & Pasta": {
        "Veg Noodles": "45/65",
        "Egg Noodles": "50/70",
        "Chicken Noodles": "60/90",
        "Egg Chicken Noodles": "70/100",
        "Mixed Noodles": "120/160",
        "Veg Pasta": "45/65",
        "Egg Pasta": "55/75",
        "Chicken Pasta": "75/100",
        "Egg Chicken Pasta": "80/110",
        "Mixed Pasta": "130/160"
    },
    "Snacks & Starter": {
        "Fish Fry (1 pc)": "90",
        "Fish Finger (3 pcs)": "90",
        "Prawns Cutlet (1 pc)": "35",
        "Chicken Cutlet (1 pc)": "35",
        "Chicken Satay (2 pcs)": "70",
        "Chicken Lollipop (3 pcs)": "70",
        "Chicken Pakora (4 pcs)": "70",
        "Crispy Chicken": "110/160",
        "Drums of Heaven (6 pcs)": "100/180",
        "Spring Roll (2 pcs)": "70",
        "Crispy Chilli Babycorn": "100/150"
    },
    "Momo": {
        "Chicken Steam Momo (6 pcs)": "70",
        "Chicken Fried Momo (6 pcs)": "80",
        "Chicken Pan Fried Momo (6 pcs)": "100"
    },
    "Rolls": {
        "Paneer Roll": "65",
        "Egg Paneer Roll": "75",
        "Egg Roll": "45",
        "Double Egg Roll": "55",
        "Chicken Roll": "60",
        "Double Chicken Roll": "85",
        "Egg Chicken Roll": "70",
        "Double Egg Chicken Roll": "85"
    },
    "Biryani": {
        "Aloo Biryani": "70/90",
        "Egg Chicken Biryani": "100/140",
        "Egg Mutton Biryani": "170/220",
        "Extra Chicken": "55",
        "Extra Mutton": "140",
        "Extra Egg": "10",
        "Extra Aloo": "10"
    },
    "Tandoori": {
        "Tandoori Chicken (4 pcs)": "190/370",
        "Chicken Tikka (6 pcs)": "100/180",
        "Tandoori Chicken Leg (1 pc)": "100",
        "Chicken Reshmi Kabab": "190",
        "Fish Tikka (4 pcs)": "180",
        "Paneer Tikka (4 pcs)": "170"
    },
    "Main Course Indian": {
        "Egg Tarka": "45/70",
        "Chicken Tarka": "65/90",
        "Egg Chicken Tarka": "70/100",
        "Chicken Chaap (1 pc)": "100",
        "Chicken Kasha (6 pcs)": "130/220",
        "Kadai Chicken (6 pcs)": "130/230",
        "Chicken Do Pyaza (6 pcs)": "140/240",
        "Chicken Bharta": "140/240",
        "Chicken Butter Masala (6 pcs)": "140/250",
        "Chicken Tikka Masala (6 pcs)": "150/250",
        "Mutton Kosha (4 pcs)": "150/280",
        "Mutton Do Pyaza (4 pcs)": "150/290",
        "Kadai Mutton (4 pcs)": "150/280",
        "Veg Tarka": "40/60",
        "Chana Masala": "100",
        "Mixed Veg": "140",
        "Mushroom Masala": "220",
        "Kadai Paneer": "130/230",
        "Paneer Do Pyaza": "140/240",
        "Paneer Butter Masala": "150/260",
        "Matar Paneer": "120/220",
        "Chana Paneer": "120/220"
    },
    "Main Course Chinese": {
        "Chilli Chicken (6 pcs)": "90/170",
        "Chicken 65 (6 pcs)": "100/180",
        "Lemon Chicken (6 pcs)": "100/180",
        "Garlic Chicken (6 pcs)": "100/170",
        "Schezwan Chicken (6 pcs)": "100/180",
        "Chicken Manchurian (6 pcs)": "100/180",
        "Chilli Fish (6 pcs)": "110/210",
        "Garlic Fish (6 pcs)": "110/210",
        "Schezwan Fish (6 pcs)": "120/230",
        "Fish Manchurian (6 pcs)": "110/210",
        "Chilli Paneer (6 pcs)": "110/210",
        "Veg Manchurian (6 pcs)": "70/140",
        "Mushroom Chilli": "100/190"
    },
    "Breads": {
        "Lachha Paratha": "30",
        "Plain Tandoori Roti": "15",
        "Butter Tandoori Roti": "30",
        "Plain Naan": "30",
        "Butter Naan": "40",
        "Garlic Naan": "45",
        "Masala Kulcha": "60",
        "Egg Mughlai Paratha": "80",
        "Egg Chicken Mughlai Paratha": "110"
    },
    "Rice": {
        "Jeera Rice": "80/120",
        "Veg Fried Rice": "70/110",
        "Egg Fried Rice": "80/120",
        "Chicken Fried Rice": "100/140",
        "Egg Chicken Fried Rice": "110/150",
        "Mixed Fried Rice": "140/180",
        "Steam Rice": "80",
        "Veg Pulao": "170",
        "Kashmiri Pulao": "190",
        "Peas Pulao": "160"
    }
}

ASSETS_DIR = r"C:\Users\sarka\Downloads\restaurant_demo-app\restaurant_demo-app\restaurant_flutter\assets\images\food"

def main():
    if not os.path.exists(ASSETS_DIR):
        print(f"Error: {ASSETS_DIR} not found.")
        return

    available_files = [f for f in os.listdir(ASSETS_DIR) if os.path.isfile(os.path.join(ASSETS_DIR, f))]

    dart_output = """import '../../domain/entities/menu_item.dart';

// AUTO-GENERATED from physical menu cards

const List<MenuCategory> kMenuCategories = [
"""

    total_categories = len(MENU_DATA)
    total_items = 0
    half_full_items = 0
    single_price_items = 0
    missing_images = []

    global_item_id = 1

    icons = {
        "Noodles & Pasta": "🍜",
        "Snacks & Starter": "🍟",
        "Momo": "🥟",
        "Rolls": "🌯",
        "Biryani": "🥘",
        "Tandoori": "🔥",
        "Main Course Indian": "🍛",
        "Main Course Chinese": "🥡",
        "Breads": "🫓",
        "Rice": "🍚"
    }

    for category, items in MENU_DATA.items():
        cat_id = category.lower().replace(" ", "-").replace("&", "and")
        icon = icons.get(category, "🍽️")
        dart_output += f"  MenuCategory(\n"
        dart_output += f"    id: '{cat_id}',\n"
        dart_output += f"    name: '{category}',\n"
        dart_output += f"    icon: '{icon}',\n"
        dart_output += f"    items: [\n"
        for name, price_str in items.items():
            total_items += 1
            
            # Parse prices
            if "/" in price_str:
                half_full_items += 1
                p1, p2 = price_str.split("/")
                price = int(p1.strip())
                priceL = int(p2.strip())
                price_dart = f"price: {price}, priceL: {priceL},"
            else:
                single_price_items += 1
                price = int(price_str.strip())
                price_dart = f"price: {price},"
            
            # Fuzzy match image
            clean_name = re.sub(r'\\(.*?\\)', '', name).strip()
            
            matches = difflib.get_close_matches(clean_name, available_files, n=1, cutoff=0.5)
            if not matches:
                matches = difflib.get_close_matches(name, available_files, n=1, cutoff=0.4)
            if not matches:
                target_file = clean_name.replace(" ", "_").lower()
                matches = difflib.get_close_matches(target_file, [f.lower() for f in available_files], n=1, cutoff=0.5)
                if matches:
                    idx = [f.lower() for f in available_files].index(matches[0])
                    matches = [available_files[idx]]

            if matches:
                image_path = f"assets/images/food/{matches[0]}"
            else:
                image_path = "assets/images/food/placeholder.png"
                missing_images.append(name)
            
            is_veg = 'true' if 'veg' in name.lower() or 'paneer' in name.lower() or 'aloo' in name.lower() or 'chana' in name.lower() or 'mushroom' in name.lower() or category == 'Breads' or name.lower() == 'jeera rice' or name.lower() == 'steam rice' or 'pulao' in name.lower() else 'false'
            
            dart_output += f"      MenuItem(id: 'item-{global_item_id}', name: '{name}', {price_dart} isVeg: {is_veg}, rating: 4.5, image: '{image_path}', isAsset: true, description: 'Authentic {name}', available: true),\n"
            
            global_item_id += 1
            
        dart_output += "    ],\n"
        dart_output += "  ),\n"
        
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

    out_file = r"C:\Users\sarka\Downloads\restaurant_demo-app\restaurant_demo-app\restaurant_flutter\lib\data\static\menu_data.dart"
    with open(out_file, "w", encoding="utf-8") as f:
        f.write(dart_output)

    print("========================================")
    print("SYNC REPORT")
    print("========================================")
    print(f"Total Categories: {total_categories}")
    print(f"Total Menu Items: {total_items}")
    print(f"Half/Full Plate variants: {half_full_items}")
    print(f"Single Price Items: {single_price_items}")
    print(f"Missing Images: {len(missing_images)}")
    for missing in missing_images:
        print(f" - {missing}")
    print("========================================")

if __name__ == "__main__":
    main()
