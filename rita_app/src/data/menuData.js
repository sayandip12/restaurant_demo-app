// Menu data sourced from Rita Foodland's actual menu cards
// Images use local assets for key dishes, accurate Unsplash for the rest

import biryaniImg from '../assets/food/biryani.png';
import noodlesImg from '../assets/food/noodles.png';
import momosImg from '../assets/food/momos.png';
import tandooriImg from '../assets/food/tandoori.png';

// Generated food images
import vegNoodlesImg from '../assets/food/veg_noodles.png';
import eggNoodlesImg from '../assets/food/egg_noodles.png';
import chickenNoodlesImg from '../assets/food/chicken_noodles.png';
import mixedNoodlesImg from '../assets/food/mixed_noodles.png';
import vegPastaImg from '../assets/food/veg_pasta.png';
import chickenPastaImg from '../assets/food/chicken_pasta.png';
import eggRollImg from '../assets/food/egg_roll.png';
import chickenRollImg from '../assets/food/chicken_roll.png';
import paneerRollImg from '../assets/food/paneer_roll.png';
import fishFryImg from '../assets/food/fish_fry.png';
import chickenLollipopImg from '../assets/food/chicken_lollipop.png';
import crispyChickenImg from '../assets/food/crispy_chicken.png';
import chickenSteamMomoImg from '../assets/food/chicken_steam_momo.png';
import chickenFriedMomoImg from '../assets/food/chicken_fried_momo.png';
import tandooriChickenImg from '../assets/food/tandoori_chicken.png';
import chickenTikkaImg from '../assets/food/chicken_tikka.png';
import paneerTikkaImg from '../assets/food/paneer_tikka.png';

let _id = 0;
const id = () => `item-${++_id}`;

const CATEGORIES = [
  {
    id: 'noodles-pasta',
    name: 'Noodles & Pasta',
    icon: '🍜',
    items: [
      { id: id(), name: 'Veg Noodles', price: 45, priceL: 65, isVeg: true, rating: 4.2, image: vegNoodlesImg, description: 'Fresh vegetable noodles tossed in aromatic sauces', available: true },
      { id: id(), name: 'Egg Noodles', price: 50, priceL: 70, isVeg: false, rating: 4.3, image: eggNoodlesImg, description: 'Classic egg noodles with crunchy vegetables', available: true },
      { id: id(), name: 'Chicken Noodles', price: 60, priceL: 90, isVeg: false, rating: 4.5, image: chickenNoodlesImg, description: 'Tender chicken strips with hakka noodles', available: true, badge: 'bestseller' },
      { id: id(), name: 'Egg Chicken Noodle', price: 70, priceL: 100, isVeg: false, rating: 4.4, image: chickenNoodlesImg, description: 'Egg and chicken combination noodles', available: true },
      { id: id(), name: 'Mixed Noodles', price: 120, priceL: 160, isVeg: false, rating: 4.6, image: mixedNoodlesImg, description: 'Ultimate mix of egg, chicken, and prawn noodles', available: true, badge: 'chef' },
      { id: id(), name: 'Veg Pasta', price: 45, priceL: 65, isVeg: true, rating: 4.1, image: vegPastaImg, description: 'Italian-style pasta with seasonal vegetables', available: true },
      { id: id(), name: 'Egg Pasta', price: 55, priceL: 75, isVeg: false, rating: 4.2, image: vegPastaImg, description: 'Creamy egg pasta in rich sauce', available: true },
      { id: id(), name: 'Chicken Pasta', price: 75, priceL: 100, isVeg: false, rating: 4.4, image: chickenPastaImg, description: 'Juicy chicken pasta in white sauce', available: true },
    ],
  },
  {
    id: 'rolls',
    name: 'Rolls',
    icon: '🌯',
    items: [
      { id: id(), name: 'Paneer Roll', price: 65, isVeg: true, rating: 4.3, image: paneerRollImg, description: 'Spiced paneer wrapped in flaky paratha', available: true },
      { id: id(), name: 'Egg Paneer Roll', price: 75, isVeg: false, rating: 4.4, image: paneerRollImg, description: 'Paneer roll with egg coating', available: true },
      { id: id(), name: 'Egg Roll', price: 45, isVeg: false, rating: 4.2, image: eggRollImg, description: 'Classic Kolkata-style egg roll', available: true, badge: 'bestseller' },
      { id: id(), name: 'Double Egg Roll', price: 55, isVeg: false, rating: 4.3, image: eggRollImg, description: 'Double egg filling for extra protein', available: true },
      { id: id(), name: 'Chicken Roll', price: 60, isVeg: false, rating: 4.5, image: chickenRollImg, description: 'Succulent chicken kathi roll', available: true, badge: 'most-ordered' },
      { id: id(), name: 'Double Chicken Roll', price: 85, isVeg: false, rating: 4.6, image: chickenRollImg, description: 'Extra chicken filling, extra delicious', available: true },
      { id: id(), name: 'Egg Chicken Roll', price: 70, isVeg: false, rating: 4.4, image: chickenRollImg, description: 'Chicken roll with egg wrap', available: true },
      { id: id(), name: 'D.Egg Chicken Roll', price: 85, isVeg: false, rating: 4.5, image: chickenRollImg, description: 'Double egg with chicken filling', available: true },
    ],
  },
  {
    id: 'snacks-starters',
    name: 'Snacks & Starters',
    icon: '🍗',
    items: [
      { id: id(), name: 'Fish Fry (1pc)', price: 90, isVeg: false, rating: 4.6, image: fishFryImg, description: 'Golden crispy fried fish', available: true, badge: 'chef' },
      { id: id(), name: 'Fish Finger (3pcs)', price: 90, isVeg: false, rating: 4.4, image: fishFryImg, description: 'Crunchy fish fingers with tartar sauce', available: true },
      { id: id(), name: 'Prawns Cutlet (1pc)', price: 35, isVeg: false, rating: 4.3, image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=800&q=80', description: 'Crispy prawn cutlet', available: true },
      { id: id(), name: 'Chicken Cutlet (1pc)', price: 35, isVeg: false, rating: 4.2, image: crispyChickenImg, description: 'Classic chicken cutlet', available: true },
      { id: id(), name: 'Chicken Satay (2pcs)', price: 70, isVeg: false, rating: 4.5, image: chickenTikkaImg, description: 'Grilled chicken skewers with peanut sauce', available: true },
      { id: id(), name: 'Chicken Lollipop (3pcs)', price: 70, isVeg: false, rating: 4.7, image: chickenLollipopImg, description: 'Spicy and crispy chicken lollipops', available: true, badge: 'bestseller' },
      { id: id(), name: 'Chicken Pokora (4pcs)', price: 70, isVeg: false, rating: 4.3, image: crispyChickenImg, description: 'Crispy batter-fried chicken', available: true },
      { id: id(), name: 'Crispy Chicken', price: 110, priceL: 160, isVeg: false, rating: 4.6, image: crispyChickenImg, description: 'Ultra-crispy fried chicken', available: true, badge: 'most-ordered' },
      { id: id(), name: 'Drums of Heaven (6pcs)', price: 100, priceL: 180, isVeg: false, rating: 4.7, image: chickenLollipopImg, description: 'Sweet and spicy drumsticks', available: true },
      { id: id(), name: 'Spring Roll (2pcs)', price: 70, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1606525437364-0e027c36e3f1?auto=format&fit=crop&w=800&q=80', description: 'Crispy vegetable spring rolls', available: true },
      { id: id(), name: 'Crispy Chilli Babycorn', price: 100, priceL: 150, isVeg: true, rating: 4.4, image: 'https://images.unsplash.com/photo-1567337710282-00832b415979?auto=format&fit=crop&w=800&q=80', description: 'Spicy babycorn tossed in chilli sauce', available: true },
    ],
  },
  {
    id: 'biryani',
    name: 'Biryani',
    icon: '🍚',
    items: [
      { id: id(), name: 'Alu Biryani', price: 70, priceL: 90, isVeg: true, rating: 4.1, image: biryaniImg, description: 'Fragrant potato biryani with spices', available: true },
      { id: id(), name: 'Egg Chicken Biryani', price: 100, priceL: 140, isVeg: false, rating: 4.6, image: biryaniImg, description: 'Rich egg and chicken biryani', available: true, badge: 'bestseller' },
      { id: id(), name: 'Egg Mutton Biryani', price: 170, priceL: 220, isVeg: false, rating: 4.7, image: biryaniImg, description: 'Premium mutton biryani with egg', available: true, badge: 'chef' },
      { id: id(), name: 'Extra Chicken', price: 55, isVeg: false, rating: 0, image: crispyChickenImg, description: 'Add extra chicken to your biryani', available: true },
      { id: id(), name: 'Extra Mutton', price: 140, isVeg: false, rating: 0, image: biryaniImg, description: 'Add extra mutton to your biryani', available: true },
    ],
  },
  {
    id: 'tandoori',
    name: 'Tandoori',
    icon: '🔥',
    items: [
      { id: id(), name: 'Tandoori Chicken (4pcs)', price: 190, priceL: 370, isVeg: false, rating: 4.8, image: tandooriChickenImg, description: 'Clay oven roasted chicken with spices', available: true, badge: 'chef' },
      { id: id(), name: 'Chicken Tikka (6pcs)', price: 100, priceL: 180, isVeg: false, rating: 4.7, image: chickenTikkaImg, description: 'Succulent marinated chicken tikka', available: true, badge: 'bestseller' },
      { id: id(), name: 'Tandoori Chicken Leg (1pc)', price: 100, isVeg: false, rating: 4.5, image: tandooriChickenImg, description: 'Full leg piece roasted in tandoor', available: true },
      { id: id(), name: 'Chicken Reshmi Kabab', price: 190, isVeg: false, rating: 4.6, image: chickenTikkaImg, description: 'Soft and creamy reshmi kababs', available: true },
      { id: id(), name: 'Fish Tikka (4pcs)', price: 180, isVeg: false, rating: 4.5, image: fishFryImg, description: 'Tandoor-grilled fish tikka', available: true },
      { id: id(), name: 'Paneer Tikka (4pcs)', price: 170, isVeg: true, rating: 4.4, image: paneerTikkaImg, description: 'Marinated paneer grilled to perfection', available: true },
    ],
  },
  {
    id: 'momos',
    name: 'Momos',
    icon: '🥟',
    items: [
      { id: id(), name: 'Chicken Steam Momo (6pcs)', price: 70, isVeg: false, rating: 4.5, image: chickenSteamMomoImg, description: 'Steamed chicken dumplings with spicy dip', available: true, badge: 'bestseller' },
      { id: id(), name: 'Chicken Fried Momo (6pcs)', price: 80, isVeg: false, rating: 4.6, image: chickenFriedMomoImg, description: 'Crispy fried chicken momos', available: true, badge: 'most-ordered' },
      { id: id(), name: 'Chicken Pan Fried Momo (6pcs)', price: 100, isVeg: false, rating: 4.7, image: chickenFriedMomoImg, description: 'Pan-fried momos with crunchy bottom', available: true },
    ],
  },
  {
    id: 'main-chinese',
    name: 'Main Course Chinese',
    icon: '🥡',
    items: [
      { id: id(), name: 'Chilli Chicken (6pcs)', price: 90, priceL: 170, isVeg: false, rating: 4.5, image: crispyChickenImg, description: 'Spicy Indo-Chinese chilli chicken', available: true, badge: 'bestseller' },
      { id: id(), name: 'Chicken 65', price: 100, priceL: 180, isVeg: false, rating: 4.6, image: crispyChickenImg, description: 'Crispy spiced Chicken 65', available: true },
      { id: id(), name: 'Lemon Chicken (6pcs)', price: 100, priceL: 170, isVeg: false, rating: 4.3, image: crispyChickenImg, description: 'Tangy lemon-flavored chicken', available: true },
      { id: id(), name: 'Schezwan Chicken (6pcs)', price: 100, priceL: 170, isVeg: false, rating: 4.4, image: crispyChickenImg, description: 'Hot Schezwan-style chicken', available: true },
      { id: id(), name: 'Chicken Manchurian (6pcs)', price: 100, priceL: 170, isVeg: false, rating: 4.5, image: chickenLollipopImg, description: 'Classic chicken manchurian in gravy', available: true },
      { id: id(), name: 'Chilli Paneer (6pcs)', price: 70, priceL: 140, isVeg: true, rating: 4.3, image: paneerTikkaImg, description: 'Spicy chilli paneer dry/gravy', available: true },
      { id: id(), name: 'Veg Manchurian (6pcs)', price: 70, priceL: 140, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1567337710282-00832b415979?auto=format&fit=crop&w=800&q=80', description: 'Vegetable manchurian balls in sauce', available: true },
      { id: id(), name: 'Mushroom Chilli', price: 100, priceL: 190, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1567337710282-00832b415979?auto=format&fit=crop&w=800&q=80', description: 'Spicy mushroom in chilli sauce', available: true },
    ],
  },
  {
    id: 'main-indian',
    name: 'Main Course Indian',
    icon: '🍛',
    items: [
      { id: id(), name: 'Egg Tarka', price: 45, priceL: 70, isVeg: false, rating: 4.2, image: 'https://images.unsplash.com/photo-1626500155537-e1e8ac444684?auto=format&fit=crop&w=800&q=80', description: 'Simple egg curry with spices', available: true },
      { id: id(), name: 'Chicken Do Pyaza (6pcs)', price: 130, priceL: 220, isVeg: false, rating: 4.5, image: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b7?auto=format&fit=crop&w=800&q=80', description: 'Chicken cooked with double onions', available: true },
      { id: id(), name: 'Kadai Chicken (6pcs)', price: 130, priceL: 220, isVeg: false, rating: 4.6, image: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b7?auto=format&fit=crop&w=800&q=80', description: 'Kadai-style spiced chicken curry', available: true, badge: 'chef' },
      { id: id(), name: 'Chicken Butter Masala (6pcs)', price: 150, priceL: 250, isVeg: false, rating: 4.8, image: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=800&q=80', description: 'Rich and creamy butter chicken', available: true, badge: 'bestseller' },
      { id: id(), name: 'Mutton Do Pyaza (4pcs)', price: 150, priceL: 280, isVeg: false, rating: 4.6, image: 'https://images.unsplash.com/photo-1545247181-516773cae754?auto=format&fit=crop&w=800&q=80', description: 'Tender mutton with caramelized onions', available: true },
      { id: id(), name: 'Paneer Butter Masala', price: 140, priceL: 240, isVeg: true, rating: 4.5, image: 'https://images.unsplash.com/photo-1631452180519-c014fe946cea?auto=format&fit=crop&w=800&q=80', description: 'Creamy paneer in rich tomato gravy', available: true, badge: 'bestseller' },
      { id: id(), name: 'Kadai Paneer', price: 130, priceL: 230, isVeg: true, rating: 4.4, image: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?auto=format&fit=crop&w=800&q=80', description: 'Kadai-style spiced paneer', available: true },
      { id: id(), name: 'Chana Masala', price: 40, priceL: 60, isVeg: true, rating: 4.1, image: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?auto=format&fit=crop&w=800&q=80', description: 'Classic chickpea curry', available: true },
      { id: id(), name: 'Veg Tarka', price: 100, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1574484284002-952d92456975?auto=format&fit=crop&w=800&q=80', description: 'Mixed vegetable curry', available: true },
    ],
  },
  {
    id: 'rice',
    name: 'Rice',
    icon: '🍚',
    items: [
      { id: id(), name: 'Jeera Rice', price: 70, priceL: 120, isVeg: true, rating: 4.1, image: 'https://images.unsplash.com/photo-1596560548464-f010549b84d7?auto=format&fit=crop&w=800&q=80', description: 'Fragrant cumin-flavored rice', available: true },
      { id: id(), name: 'Veg Fried Rice', price: 80, priceL: 110, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80', description: 'Wok-tossed vegetable fried rice', available: true },
      { id: id(), name: 'Egg Fried Rice', price: 70, priceL: 120, isVeg: false, rating: 4.3, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80', description: 'Classic egg fried rice', available: true },
      { id: id(), name: 'Chicken Fried Rice', price: 100, priceL: 140, isVeg: false, rating: 4.5, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80', description: 'Chicken fried rice with vegetables', available: true, badge: 'most-ordered' },
      { id: id(), name: 'Mixed Fried Rice', price: 110, priceL: 150, isVeg: false, rating: 4.4, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80', description: 'Mixed fried rice with egg and chicken', available: true },
      { id: id(), name: 'Kashmiri Pulao', price: 170, isVeg: true, rating: 4.5, image: biryaniImg, description: 'Sweet Kashmiri pulao with dry fruits', available: true },
      { id: id(), name: 'Peas Pulao', price: 160, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1596560548464-f010549b84d7?auto=format&fit=crop&w=800&q=80', description: 'Aromatic peas pulao', available: true },
    ],
  },
  {
    id: 'breads',
    name: 'Breads',
    icon: '🫓',
    items: [
      { id: id(), name: 'Plain Tandoori Roti', price: 15, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80', description: 'Fresh tandoori roti', available: true },
      { id: id(), name: 'Butter Tandoori Roti', price: 30, isVeg: true, rating: 4.2, image: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=800&q=80', description: 'Butter-brushed tandoori roti', available: true },
      { id: id(), name: 'Laccha Paratha', price: 30, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?auto=format&fit=crop&w=800&q=80', description: 'Layered laccha paratha', available: true },
      { id: id(), name: 'Butter Naan', price: 40, isVeg: true, rating: 4.4, image: 'https://images.unsplash.com/photo-1600628421055-4d30de868b8f?auto=format&fit=crop&w=800&q=80', description: 'Soft butter naan from tandoor', available: true },
      { id: id(), name: 'Garlic Naan', price: 45, isVeg: true, rating: 4.5, image: 'https://images.unsplash.com/photo-1600628421055-4d30de868b8f?auto=format&fit=crop&w=800&q=80', description: 'Garlic-infused naan bread', available: true, badge: 'most-ordered' },
      { id: id(), name: 'Masala Kulcha', price: 60, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?auto=format&fit=crop&w=800&q=80', description: 'Stuffed masala kulcha', available: true },
    ],
  },
  {
    id: 'combos',
    name: 'Combos & Specials',
    icon: '🎁',
    items: [
      { id: id(), name: 'Rita Special Combo', price: 250, isVeg: false, rating: 4.8, image: biryaniImg, description: 'Biryani + 2 Chicken + Naan + Raita', available: true, badge: 'chef' },
      { id: id(), name: 'Rita Family Pack', price: 450, isVeg: false, rating: 4.9, image: biryaniImg, description: 'Biryani + 4 pcs Chicken + 4 Naan + Raita + Salad', available: true, badge: 'bestseller' },
      { id: id(), name: 'Thali Special', price: 150, isVeg: false, rating: 4.5, image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', description: 'Rice + Dal + Sabzi + Roti + Salad', available: true },
      { id: id(), name: 'Veg Thali', price: 120, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80', description: 'Rice + Dal + 2 Sabzi + Roti + Papad', available: true },
    ],
  },
  {
    id: 'beverages',
    name: 'Beverages',
    icon: '🥤',
    items: [
      { id: id(), name: 'Lassi (Sweet/Salt)', price: 40, isVeg: true, rating: 4.3, image: 'https://images.unsplash.com/photo-1626200419199-391ae4be7a41?auto=format&fit=crop&w=800&q=80', description: 'Creamy traditional lassi', available: true },
      { id: id(), name: 'Cold Drink', price: 30, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=800&q=80', description: 'Chilled soft drink', available: true },
      { id: id(), name: 'Mineral Water', price: 20, isVeg: true, rating: 4.0, image: 'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=800&q=80', description: 'Packaged drinking water', available: true },
    ],
  },
];

// Flatten for search
export const getAllItems = () => {
  const items = [];
  CATEGORIES.forEach(cat => {
    cat.items.forEach(item => {
      items.push({ ...item, category: cat.name, categoryId: cat.id });
    });
  });
  return items;
};

// Popular items (bestsellers + chef recommended)
export const getPopularItems = () => {
  return getAllItems().filter(i => i.badge === 'bestseller' || i.badge === 'chef').slice(0, 8);
};

// Specials
export const getSpecials = () => {
  return getAllItems().filter(i => i.badge === 'chef').slice(0, 4);
};

export default CATEGORIES;
