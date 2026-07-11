import '../../domain/entities/menu_item.dart';

/// Rita Foodland menu data ΓÇö ported from menuData.js
/// All local food images use asset paths. Unsplash URLs kept for items
/// without local images.
const List<MenuCategory> kMenuCategories = [
  MenuCategory(
    id: 'noodles-pasta',
    name: 'Noodles & Pasta',
    icon: '≡ƒì£',
    items: [
      MenuItem(id: 'item-1', name: 'Veg Noodles', price: 45, priceL: 65, isVeg: true, rating: 4.2, image: 'assets/images/food/veg_noodles.png', isAsset: true, description: 'Fresh vegetable noodles tossed in aromatic sauces', available: true),
      MenuItem(id: 'item-2', name: 'Egg Noodles', price: 50, priceL: 70, isVeg: false, rating: 4.3, image: 'assets/images/food/egg_noodles.png', isAsset: true, description: 'Classic egg noodles with crunchy vegetables', available: true),
      MenuItem(id: 'item-3', name: 'Chicken Noodles', price: 60, priceL: 90, isVeg: false, rating: 4.5, image: 'assets/images/food/chicken_noodles.png', isAsset: true, description: 'Tender chicken strips with hakka noodles', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-4', name: 'Egg Chicken Noodle', price: 70, priceL: 100, isVeg: false, rating: 4.4, image: 'assets/images/food/chicken_noodles.png', isAsset: true, description: 'Egg and chicken combination noodles', available: true),
      MenuItem(id: 'item-5', name: 'Mixed Noodles', price: 120, priceL: 160, isVeg: false, rating: 4.6, image: 'assets/images/food/mixed_noodles.png', isAsset: true, description: 'Ultimate mix of egg, chicken, and prawn noodles', available: true, badge: 'chef'),
      MenuItem(id: 'item-6', name: 'Veg Pasta', price: 45, priceL: 65, isVeg: true, rating: 4.1, image: 'assets/images/food/veg_pasta.png', isAsset: true, description: 'Italian-style pasta with seasonal vegetables', available: true),
      MenuItem(id: 'item-7', name: 'Egg Pasta', price: 55, priceL: 75, isVeg: false, rating: 4.2, image: 'assets/images/food/veg_pasta.png', isAsset: true, description: 'Creamy egg pasta in rich sauce', available: true),
      MenuItem(id: 'item-8', name: 'Chicken Pasta', price: 75, priceL: 100, isVeg: false, rating: 4.4, image: 'assets/images/food/chicken_pasta.png', isAsset: true, description: 'Juicy chicken pasta in white sauce', available: true),
    ],
  ),
  MenuCategory(
    id: 'rolls',
    name: 'Rolls',
    icon: '≡ƒî»',
    items: [
      MenuItem(id: 'item-9', name: 'Paneer Roll', price: 65, isVeg: true, rating: 4.3, image: 'assets/images/food/paneer_roll.png', isAsset: true, description: 'Spiced paneer wrapped in flaky paratha', available: true),
      MenuItem(id: 'item-10', name: 'Egg Paneer Roll', price: 75, isVeg: false, rating: 4.4, image: 'assets/images/food/paneer_roll.png', isAsset: true, description: 'Paneer roll with egg coating', available: true),
      MenuItem(id: 'item-11', name: 'Egg Roll', price: 45, isVeg: false, rating: 4.2, image: 'assets/images/food/egg_roll.png', isAsset: true, description: 'Classic Kolkata-style egg roll', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-12', name: 'Double Egg Roll', price: 55, isVeg: false, rating: 4.3, image: 'assets/images/food/egg_roll.png', isAsset: true, description: 'Double egg filling for extra protein', available: true),
      MenuItem(id: 'item-13', name: 'Chicken Roll', price: 60, isVeg: false, rating: 4.5, image: 'assets/images/food/chicken_roll.png', isAsset: true, description: 'Succulent chicken kathi roll', available: true, badge: 'most-ordered'),
      MenuItem(id: 'item-14', name: 'Double Chicken Roll', price: 85, isVeg: false, rating: 4.6, image: 'assets/images/food/chicken_roll.png', isAsset: true, description: 'Extra chicken filling, extra delicious', available: true),
      MenuItem(id: 'item-15', name: 'Egg Chicken Roll', price: 70, isVeg: false, rating: 4.4, image: 'assets/images/food/chicken_roll.png', isAsset: true, description: 'Chicken roll with egg wrap', available: true),
      MenuItem(id: 'item-16', name: 'D.Egg Chicken Roll', price: 85, isVeg: false, rating: 4.5, image: 'assets/images/food/chicken_roll.png', isAsset: true, description: 'Double egg with chicken filling', available: true),
    ],
  ),
  MenuCategory(
    id: 'snacks-starters',
    name: 'Snacks & Starters',
    icon: '≡ƒìù',
    items: [
      MenuItem(id: 'item-17', name: 'Fish Fry (1pc)', price: 90, isVeg: false, rating: 4.6, image: 'assets/images/food/fish_fry.png', isAsset: true, description: 'Golden crispy fried fish', available: true, badge: 'chef'),
      MenuItem(id: 'item-18', name: 'Fish Finger (3pcs)', price: 90, isVeg: false, rating: 4.4, image: 'assets/images/food/fish_fry.png', isAsset: true, description: 'Crunchy fish fingers with tartar sauce', available: true),
      MenuItem(id: 'item-19', name: 'Prawns Cutlet (1pc)', price: 35, isVeg: false, rating: 4.3, image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Crispy prawn cutlet', available: true),
      MenuItem(id: 'item-20', name: 'Chicken Cutlet (1pc)', price: 35, isVeg: false, rating: 4.2, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Classic chicken cutlet', available: true),
      MenuItem(id: 'item-21', name: 'Chicken Satay (2pcs)', price: 70, isVeg: false, rating: 4.5, image: 'assets/images/food/chicken_tikka.png', isAsset: true, description: 'Grilled chicken skewers with peanut sauce', available: true),
      MenuItem(id: 'item-22', name: 'Chicken Lollipop (3pcs)', price: 70, isVeg: false, rating: 4.7, image: 'assets/images/food/chicken_lollipop.png', isAsset: true, description: 'Spicy and crispy chicken lollipops', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-23', name: 'Chicken Pokora (4pcs)', price: 70, isVeg: false, rating: 4.3, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Crispy batter-fried chicken', available: true),
      MenuItem(id: 'item-24', name: 'Crispy Chicken', price: 110, priceL: 160, isVeg: false, rating: 4.6, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Ultra-crispy fried chicken', available: true, badge: 'most-ordered'),
      MenuItem(id: 'item-25', name: 'Drums of Heaven (6pcs)', price: 100, priceL: 180, isVeg: false, rating: 4.7, image: 'assets/images/food/chicken_lollipop.png', isAsset: true, description: 'Sweet and spicy drumsticks', available: true),
      MenuItem(id: 'item-26', name: 'Spring Roll (2pcs)', price: 70, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1606525437364-0e027c36e3f1?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Crispy vegetable spring rolls', available: true),
      MenuItem(id: 'item-27', name: 'Crispy Chilli Babycorn', price: 100, priceL: 150, isVeg: true, rating: 4.4, image: 'https://images.unsplash.com/photo-1567337710282-00832b415979?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Spicy babycorn tossed in chilli sauce', available: true),
    ],
  ),
  MenuCategory(
    id: 'biryani',
    name: 'Biryani',
    icon: '≡ƒìÜ',
    items: [
      MenuItem(id: 'item-28', name: 'Alu Biryani', price: 70, priceL: 90, isVeg: true, rating: 4.1, image: 'assets/images/food/biryani.png', isAsset: true, description: 'Fragrant potato biryani with spices', available: true),
      MenuItem(id: 'item-29', name: 'Egg Chicken Biryani', price: 100, priceL: 140, isVeg: false, rating: 4.6, image: 'assets/images/food/biryani.png', isAsset: true, description: 'Rich egg and chicken biryani', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-30', name: 'Egg Mutton Biryani', price: 170, priceL: 220, isVeg: false, rating: 4.7, image: 'assets/images/food/biryani.png', isAsset: true, description: 'Premium mutton biryani with egg', available: true, badge: 'chef'),
      MenuItem(id: 'item-31', name: 'Extra Chicken', price: 55, isVeg: false, rating: 0, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Add extra chicken to your biryani', available: true),
      MenuItem(id: 'item-32', name: 'Extra Mutton', price: 140, isVeg: false, rating: 0, image: 'assets/images/food/biryani.png', isAsset: true, description: 'Add extra mutton to your biryani', available: true),
    ],
  ),
  MenuCategory(
    id: 'tandoori',
    name: 'Tandoori',
    icon: '≡ƒöÑ',
    items: [
      MenuItem(id: 'item-33', name: 'Tandoori Chicken (4pcs)', price: 190, priceL: 370, isVeg: false, rating: 4.8, image: 'assets/images/food/tandoori_chicken.png', isAsset: true, description: 'Clay oven roasted chicken with spices', available: true, badge: 'chef'),
      MenuItem(id: 'item-34', name: 'Chicken Tikka (6pcs)', price: 100, priceL: 180, isVeg: false, rating: 4.7, image: 'assets/images/food/chicken_tikka.png', isAsset: true, description: 'Succulent marinated chicken tikka', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-35', name: 'Tandoori Chicken Leg (1pc)', price: 100, isVeg: false, rating: 4.5, image: 'assets/images/food/tandoori_chicken.png', isAsset: true, description: 'Full leg piece roasted in tandoor', available: true),
      MenuItem(id: 'item-36', name: 'Chicken Reshmi Kabab', price: 190, isVeg: false, rating: 4.6, image: 'assets/images/food/chicken_tikka.png', isAsset: true, description: 'Soft and creamy reshmi kababs', available: true),
      MenuItem(id: 'item-37', name: 'Fish Tikka (4pcs)', price: 180, isVeg: false, rating: 4.5, image: 'assets/images/food/fish_fry.png', isAsset: true, description: 'Tandoor-grilled fish tikka', available: true),
      MenuItem(id: 'item-38', name: 'Paneer Tikka (4pcs)', price: 170, isVeg: true, rating: 4.4, image: 'assets/images/food/paneer_tikka.png', isAsset: true, description: 'Marinated paneer grilled to perfection', available: true),
    ],
  ),
  MenuCategory(
    id: 'momos',
    name: 'Momos',
    icon: '≡ƒÑƒ',
    items: [
      MenuItem(id: 'item-39', name: 'Chicken Steam Momo (6pcs)', price: 70, isVeg: false, rating: 4.5, image: 'assets/images/food/chicken_steam_momo.png', isAsset: true, description: 'Steamed chicken dumplings with spicy dip', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-40', name: 'Chicken Fried Momo (6pcs)', price: 80, isVeg: false, rating: 4.6, image: 'assets/images/food/chicken_fried_momo.png', isAsset: true, description: 'Crispy fried chicken momos', available: true, badge: 'most-ordered'),
      MenuItem(id: 'item-41', name: 'Chicken Pan Fried Momo (6pcs)', price: 100, isVeg: false, rating: 4.7, image: 'assets/images/food/chicken_fried_momo.png', isAsset: true, description: 'Pan-fried momos with crunchy bottom', available: true),
    ],
  ),
  MenuCategory(
    id: 'main-chinese',
    name: 'Main Course Chinese',
    icon: '≡ƒÑí',
    items: [
      MenuItem(id: 'item-42', name: 'Chilli Chicken (6pcs)', price: 90, priceL: 170, isVeg: false, rating: 4.5, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Spicy Indo-Chinese chilli chicken', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-43', name: 'Chicken 65', price: 100, priceL: 180, isVeg: false, rating: 4.6, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Crispy spiced Chicken 65', available: true),
      MenuItem(id: 'item-44', name: 'Lemon Chicken (6pcs)', price: 100, priceL: 170, isVeg: false, rating: 4.3, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Tangy lemon-flavored chicken', available: true),
      MenuItem(id: 'item-45', name: 'Schezwan Chicken (6pcs)', price: 100, priceL: 170, isVeg: false, rating: 4.4, image: 'assets/images/food/crispy_chicken.png', isAsset: true, description: 'Hot Schezwan-style chicken', available: true),
      MenuItem(id: 'item-46', name: 'Chicken Manchurian (6pcs)', price: 100, priceL: 170, isVeg: false, rating: 4.5, image: 'assets/images/food/chicken_lollipop.png', isAsset: true, description: 'Classic chicken manchurian in gravy', available: true),
      MenuItem(id: 'item-47', name: 'Chilli Paneer (6pcs)', price: 70, priceL: 140, isVeg: true, rating: 4.3, image: 'assets/images/food/paneer_tikka.png', isAsset: true, description: 'Spicy chilli paneer dry/gravy', available: true),
      MenuItem(id: 'item-48', name: 'Veg Manchurian (6pcs)', price: 70, priceL: 140, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1567337710282-00832b415979?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Vegetable manchurian balls in sauce', available: true),
      MenuItem(id: 'item-49', name: 'Mushroom Chilli', price: 100, priceL: 190, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1567337710282-00832b415979?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Spicy mushroom in chilli sauce', available: true),
    ],
  ),
  MenuCategory(
    id: 'main-indian',
    name: 'Main Course Indian',
    icon: '≡ƒì¢',
    items: [
      MenuItem(id: 'item-50', name: 'Egg Tarka', price: 45, priceL: 70, isVeg: false, rating: 4.2, image: 'https://images.unsplash.com/photo-1626500155537-e1e8ac444684?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Simple egg curry with spices', available: true),
      MenuItem(id: 'item-51', name: 'Chicken Do Pyaza (6pcs)', price: 130, priceL: 220, isVeg: false, rating: 4.5, image: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b7?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Chicken cooked with double onions', available: true),
      MenuItem(id: 'item-52', name: 'Kadai Chicken (6pcs)', price: 130, priceL: 220, isVeg: false, rating: 4.6, image: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b7?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Kadai-style spiced chicken curry', available: true, badge: 'chef'),
      MenuItem(id: 'item-53', name: 'Chicken Butter Masala (6pcs)', price: 150, priceL: 250, isVeg: false, rating: 4.8, image: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Rich and creamy butter chicken', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-54', name: 'Mutton Do Pyaza (4pcs)', price: 150, priceL: 280, isVeg: false, rating: 4.6, image: 'https://images.unsplash.com/photo-1545247181-516773cae754?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Tender mutton with caramelized onions', available: true),
      MenuItem(id: 'item-55', name: 'Paneer Butter Masala', price: 140, priceL: 240, isVeg: true, rating: 4.5, image: 'https://images.unsplash.com/photo-1631452180519-c014fe946cea?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Creamy paneer in rich tomato gravy', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-56', name: 'Kadai Paneer', price: 130, priceL: 230, isVeg: true, rating: 4.4, image: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Kadai-style spiced paneer', available: true),
      MenuItem(id: 'item-57', name: 'Chana Masala', price: 40, priceL: 60, isVeg: true, rating: 4.1, image: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Classic chickpea curry', available: true),
      MenuItem(id: 'item-58', name: 'Veg Tarka', price: 100, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1574484284002-952d92456975?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Mixed vegetable curry', available: true),
    ],
  ),
  MenuCategory(
    id: 'rice',
    name: 'Rice',
    icon: '≡ƒìÜ',
    items: [
      MenuItem(id: 'item-59', name: 'Jeera Rice', price: 70, priceL: 120, isVeg: true, rating: 4.1, image: 'https://images.unsplash.com/photo-1596560548464-f010549b84d7?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Fragrant cumin-flavored rice', available: true),
      MenuItem(id: 'item-60', name: 'Veg Fried Rice', price: 80, priceL: 110, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Wok-tossed vegetable fried rice', available: true),
      MenuItem(id: 'item-61', name: 'Egg Fried Rice', price: 70, priceL: 120, isVeg: false, rating: 4.3, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Classic egg fried rice', available: true),
      MenuItem(id: 'item-62', name: 'Chicken Fried Rice', price: 100, priceL: 140, isVeg: false, rating: 4.5, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Chicken fried rice with vegetables', available: true, badge: 'most-ordered'),
      MenuItem(id: 'item-63', name: 'Mixed Fried Rice', price: 110, priceL: 150, isVeg: false, rating: 4.4, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Mixed fried rice with egg and chicken', available: true),
      MenuItem(id: 'item-64', name: 'Kashmiri Pulao', price: 170, isVeg: true, rating: 4.5, image: 'assets/images/food/biryani.png', isAsset: true, description: 'Sweet Kashmiri pulao with dry fruits', available: true),
      MenuItem(id: 'item-65', name: 'Peas Pulao', price: 160, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1596560548464-f010549b84d7?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Aromatic peas pulao', available: true),
    ],
  ),
  MenuCategory(
    id: 'breads',
    name: 'Breads',
    icon: '≡ƒ½ô',
    items: [
      MenuItem(id: 'item-66', name: 'Plain Tandoori Roti', price: 15, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Fresh tandoori roti', available: true),
      MenuItem(id: 'item-67', name: 'Butter Tandoori Roti', price: 30, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Butter-brushed tandoori roti', available: true),
      MenuItem(id: 'item-68', name: 'Laccha Paratha', price: 30, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Layered laccha paratha', available: true),
      MenuItem(id: 'item-69', name: 'Butter Naan', price: 40, isVeg: true, rating: 4.4, image: 'https://images.unsplash.com/photo-1600628421055-4d30de868b8f?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Soft butter naan from tandoor', available: true),
      MenuItem(id: 'item-70', name: 'Garlic Naan', price: 45, isVeg: true, rating: 4.5, image: 'https://images.unsplash.com/photo-1600628421055-4d30de868b8f?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Garlic-infused naan bread', available: true, badge: 'most-ordered'),
      MenuItem(id: 'item-71', name: 'Masala Kulcha', price: 60, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Stuffed masala kulcha', available: true),
    ],
  ),
  MenuCategory(
    id: 'combos',
    name: 'Combos & Specials',
    icon: '≡ƒÄü',
    items: [
      MenuItem(id: 'item-72', name: 'Rita Special Combo', price: 250, isVeg: false, rating: 4.8, image: 'assets/images/food/biryani.png', isAsset: true, description: 'Biryani + 2 Chicken + Naan + Raita', available: true, badge: 'chef'),
      MenuItem(id: 'item-73', name: 'Rita Family Pack', price: 450, isVeg: false, rating: 4.9, image: 'assets/images/food/biryani.png', isAsset: true, description: 'Biryani + 4 pcs Chicken + 4 Naan + Raita + Salad', available: true, badge: 'bestseller'),
      MenuItem(id: 'item-74', name: 'Thali Special', price: 150, isVeg: false, rating: 4.5, image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Rice + Dal + Sabzi + Roti + Salad', available: true),
      MenuItem(id: 'item-75', name: 'Veg Thali', price: 120, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Rice + Dal + 2 Sabzi + Roti + Papad', available: true),
    ],
  ),
  MenuCategory(
    id: 'beverages',
    name: 'Beverages',
    icon: '≡ƒÑñ',
    items: [
      MenuItem(id: 'item-76', name: 'Lassi (Sweet/Salt)', price: 40, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1626200419199-391ae4be7a41?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Creamy traditional lassi', available: true),
      MenuItem(id: 'item-77', name: 'Cold Drink', price: 30, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Chilled soft drink', available: true),
      MenuItem(id: 'item-78', name: 'Mineral Water', price: 20, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=400&q=60', isAsset: false, description: 'Packaged drinking water', available: true),
    ],
  ),
];

/// Get all items as flat list
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
