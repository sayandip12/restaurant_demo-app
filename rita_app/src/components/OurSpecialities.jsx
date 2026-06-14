import { getSpecials } from '../data/menuData';
import { useCart } from '../context/CartContext';
import { useToast } from '../context/ToastContext';
import './OurSpecialities.css';

const OurSpecialities = () => {
  const specials = getSpecials();
  const { addItem, getItemQuantity, updateQuantity } = useCart();
  const { showToast } = useToast();

  const handleAdd = (item) => {
    addItem(item);
    showToast(`${item.name} added to cart`, 'success');
  };

  return (
    <section className="specialities-section section" id="specialities">
      <div className="container">
        <h2 className="section-title">Our Specialities</h2>
        <p className="section-subtitle">What makes us special</p>

        <div className="specialities-grid">
          {specials.map((item) => {
            const qty = getItemQuantity(item.id);

            return (
              <article className="special-card" key={item.id}>
                {/* Image */}
                <div className="special-card-img-wrapper">
                  <img
                    src={item.image}
                    alt={item.name}
                    className="special-card-img"
                    loading="lazy"
                  />
                </div>

                {/* Content */}
                <div className="special-card-content">
                  <span className="badge badge-chef">👨‍🍳 Chef Recommended</span>

                  <h3 className="special-card-name">{item.name}</h3>
                  <p className="special-card-desc">{item.description}</p>

                  <div className="special-card-footer">
                    <div className="special-price-row">
                      <span className="special-price">₹{item.price}</span>
                      <span className={`veg-indicator ${item.isVeg ? '' : 'nonveg'}`} title={item.isVeg ? 'Veg' : 'Non-Veg'} />
                    </div>

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

export default OurSpecialities;
