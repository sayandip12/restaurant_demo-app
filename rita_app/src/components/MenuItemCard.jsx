import { memo } from 'react';
import { useCart } from '../context/CartContext';
import { useToast } from '../context/ToastContext';
import './MenuItemCard.css';

const BADGE_LABELS = {
  bestseller: 'Best Seller',
  chef: 'Chef Recommended',
  'most-ordered': 'Most Ordered',
};

const StarIcon = () => (
  <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.957a1 1 0 00.95.69h4.162c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.287 3.957c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.176 0l-3.37 2.448c-.784.57-1.838-.197-1.539-1.118l1.287-3.957a1 1 0 00-.364-1.118L2.063 9.384c-.783-.57-.38-1.81.588-1.81h4.162a1 1 0 00.95-.69l1.286-3.957z" />
  </svg>
);

const PlusIcon = () => (
  <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
    <path fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clipRule="evenodd" />
  </svg>
);

function MenuItemCard({ item, onOpenModal }) {
  const { addItem, getItemQuantity, updateQuantity } = useCart();
  const { showToast } = useToast();

  const qty = getItemQuantity(item.id);
  const badgeClass = item.badge ? `badge-${item.badge}` : '';
  const badgeLabel = item.badge ? BADGE_LABELS[item.badge] : '';

  const handleAdd = (e) => {
    e.stopPropagation();
    addItem(item);
    showToast(`${item.name} added to cart`, 'success');
  };

  const handleIncrement = (e) => {
    e.stopPropagation();
    updateQuantity(item.id, qty + 1);
  };

  const handleDecrement = (e) => {
    e.stopPropagation();
    updateQuantity(item.id, qty - 1);
  };

  const handleOpenModal = () => {
    if (onOpenModal) onOpenModal(item);
  };

  return (
    <article
      className={`menu-item-card${!item.available ? ' unavailable' : ''}`}
      id={`card-${item.id}`}
      data-testid="menu-item-card"
    >
      {/* Image */}
      <div className="mic-image-wrap" onClick={handleOpenModal}>
        <img
          className="mic-image"
          src={item.image}
          alt={item.name}
          loading="lazy"
          decoding="async"
        />
        {/* Badge */}
        {item.badge && (
          <span className={`mic-badge ${badgeClass}`}>{badgeLabel}</span>
        )}
        {/* Veg / NonVeg */}
        <span
          className={`mic-veg-dot ${item.isVeg ? 'veg' : 'nonveg'}`}
          title={item.isVeg ? 'Vegetarian' : 'Non-Vegetarian'}
        />
      </div>

      {/* Content */}
      <div className="mic-content">
        <h3 className="mic-name" onClick={handleOpenModal}>
          {item.name}
        </h3>
        <p className="mic-desc">{item.description}</p>

        {/* Price */}
        <div className="mic-price-row">
          <span className="mic-price">₹{item.price}</span>
          {item.priceL && (
            <>
              <span className="mic-price-l">/ ₹{item.priceL}</span>
              <span className="mic-price-label">Half / Full</span>
            </>
          )}
        </div>

        {/* Rating */}
        {item.rating > 0 && (
          <span className="mic-rating">
            <StarIcon />
            {item.rating}
          </span>
        )}

        {/* Unavailable */}
        {!item.available && (
          <div className="mic-unavailable">Currently Unavailable</div>
        )}
      </div>

      {/* Actions */}
      {item.available && (
        <div className="mic-actions">
          {qty === 0 ? (
            <button
              className="mic-add-btn"
              onClick={handleAdd}
              aria-label={`Add ${item.name} to cart`}
              data-testid="add-to-cart-btn"
            >
              <PlusIcon />
              ADD
            </button>
          ) : (
            <div className="mic-qty-controls" data-testid="qty-controls">
              <button
                className="mic-qty-btn"
                onClick={handleDecrement}
                aria-label="Decrease quantity"
              >
                −
              </button>
              <span className="mic-qty-count">{qty}</span>
              <button
                className="mic-qty-btn"
                onClick={handleIncrement}
                aria-label="Increase quantity"
              >
                +
              </button>
            </div>
          )}
        </div>
      )}
    </article>
  );
}

export default memo(MenuItemCard);
