import { getPopularItems } from '../data/menuData';
import { useCart } from '../context/CartContext';
import { useToast } from '../context/ToastContext';
import './PopularDishes.css';

const BADGE_MAP = {
  bestseller: '🏆 Best Seller',
  chef: '👨‍🍳 Chef Pick',
  'most-ordered': '🔥 Most Ordered',
};

const PopularDishes = () => {
  const items = getPopularItems();
  const { addItem, getItemQuantity, updateQuantity } = useCart();
  const { showToast } = useToast();

  const handleAdd = (item) => {
    addItem(item);
    showToast(`${item.name} added to cart`, 'success');
  };

  return (
    <section className="popular-section section" id="popular-dishes">
      <div className="container">
        <h2 className="section-title">Popular Dishes</h2>
        <p className="section-subtitle">Most loved by our customers</p>

        <div className="popular-grid">
          {items.map((item) => {
            const qty = getItemQuantity(item.id);

            return (
              <article className="popular-card card" key={item.id} id={`dish-${item.id}`}>
                {/* Image */}
                <div className="popular-card-img-wrapper">
                  <img
                    src={item.image}
                    alt={item.name}
                    className="popular-card-img"
                    loading="lazy"
                  />
                  {/* Badge overlay */}
                  {item.badge && (
                    <span className={`popular-badge badge badge-${item.badge}`}>
                      {BADGE_MAP[item.badge] || item.badge}
                    </span>
                  )}
                  {/* Veg/NonVeg indicator */}
                  <span
                    className={`veg-indicator popular-veg-dot ${item.isVeg ? '' : 'nonveg'}`}
                    title={item.isVeg ? 'Vegetarian' : 'Non-Vegetarian'}
                  />
                </div>

                {/* Body */}
                <div className="popular-card-body">
                  <h3 className="popular-card-name">{item.name}</h3>
                  <p className="popular-card-desc">{item.description}</p>

                  <div className="popular-card-footer">
                    <div className="popular-price-row">
                      <span className="popular-price">₹{item.price}</span>
                      {item.rating > 0 && (
                        <span className="rating">
                          <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                          </svg>
                          {item.rating}
                        </span>
                      )}
                    </div>

                    {/* Add to Cart / Quantity Controls */}
                    {qty === 0 ? (
                      <button
                        className="popular-add-btn"
                        onClick={() => handleAdd(item)}
                        aria-label={`Add ${item.name} to cart`}
                      >
                        Add +
                      </button>
                    ) : (
                      <div className="popular-qty-controls">
                        <button
                          className="qty-btn"
                          onClick={() => updateQuantity(item.id, qty - 1)}
                          aria-label="Decrease quantity"
                        >
                          −
                        </button>
                        <span className="qty-count">{qty}</span>
                        <button
                          className="qty-btn"
                          onClick={() => updateQuantity(item.id, qty + 1)}
                          aria-label="Increase quantity"
                        >
                          +
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              </article>
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default PopularDishes;
