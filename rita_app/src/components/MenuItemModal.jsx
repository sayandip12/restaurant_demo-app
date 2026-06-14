import { useState, useEffect, useCallback } from 'react';
import { useCart } from '../context/CartContext';
import { useToast } from '../context/ToastContext';
import './MenuItemModal.css';

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

const CloseIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
    <path d="M18 6L6 18M6 6l12 12" />
  </svg>
);

const CartIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" />
    <line x1="3" y1="6" x2="21" y2="6" />
    <path d="M16 10a4 4 0 01-8 0" />
  </svg>
);

const LeafIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
    <path d="M11 20A7 7 0 019.8 6.9C15.5 4.9 17 3.5 19 2c1 2 2 4.5 2 8 0 5.5-4.5 10-10 10z" />
    <path d="M2 21c0-3 1.85-5.36 5.08-6C9.5 14.52 12 13 13 12" />
  </svg>
);

function MenuItemModal({ item, onClose }) {
  const { addItem, getItemQuantity, updateQuantity } = useCart();
  const { showToast } = useToast();
  const [qty, setQty] = useState(1);

  const cartQty = getItemQuantity(item.id);
  const isInCart = cartQty > 0;

  // Initialize qty from cart if item is already there
  useEffect(() => {
    if (isInCart) setQty(cartQty);
  }, [isInCart, cartQty]);

  // Lock body scroll
  useEffect(() => {
    document.body.classList.add('modal-open');
    return () => document.body.classList.remove('modal-open');
  }, []);

  // ESC to close
  useEffect(() => {
    const handleKey = (e) => {
      if (e.key === 'Escape') onClose();
    };
    window.addEventListener('keydown', handleKey);
    return () => window.removeEventListener('keydown', handleKey);
  }, [onClose]);

  const handleBackdropClick = useCallback(
    (e) => {
      if (e.target === e.currentTarget) onClose();
    },
    [onClose]
  );

  const handleAddToCart = () => {
    if (isInCart) {
      updateQuantity(item.id, qty);
      showToast(`Updated ${item.name} quantity`, 'success');
    } else {
      addItem(item, qty);
      showToast(`${item.name} added to cart`, 'success');
    }
    onClose();
  };

  const badgeClass = item.badge ? `badge-${item.badge}` : '';
  const badgeLabel = item.badge ? BADGE_LABELS[item.badge] : '';

  return (
    <div
      className="mim-backdrop"
      onClick={handleBackdropClick}
      role="dialog"
      aria-modal="true"
      aria-label={`${item.name} details`}
      data-testid="menu-item-modal"
    >
      <div className="mim-modal">
        {/* Close */}
        <button className="mim-close" onClick={onClose} aria-label="Close modal">
          <CloseIcon />
        </button>

        {/* Image */}
        <img className="mim-image" src={item.image} alt={item.name} />

        {/* Content */}
        <div className="mim-content">
          {/* Header */}
          <div className="mim-header">
            <h2 className="mim-name">{item.name}</h2>
            <div className="mim-indicators">
              <span
                className={`mic-veg-dot ${item.isVeg ? 'veg' : 'nonveg'}`}
                title={item.isVeg ? 'Vegetarian' : 'Non-Vegetarian'}
              />
            </div>
          </div>

          {/* Badge */}
          {item.badge && (
            <span className={`mim-badge ${badgeClass}`}>{badgeLabel}</span>
          )}

          {/* Rating */}
          {item.rating > 0 && (
            <span className="mim-rating">
              <StarIcon />
              {item.rating}
            </span>
          )}

          {/* Description */}
          <p className="mim-desc">{item.description}</p>

          {/* Ingredients */}
          <div className="mim-ingredients">
            <LeafIcon />
            Freshly prepared with premium ingredients
          </div>

          <hr className="mim-divider" />

          {/* Price */}
          <div className="mim-price">
            ₹{item.price}
            {item.priceL && (
              <>
                <span className="mim-price-l">/ ₹{item.priceL}</span>
                <span className="mim-price-label">Half / Full</span>
              </>
            )}
          </div>

          {/* Quantity */}
          <div className="mim-qty-row">
            <span className="mim-qty-label">Quantity</span>
            <div className="mim-qty-selector">
              <button
                className="mim-qty-btn"
                onClick={() => setQty((q) => Math.max(1, q - 1))}
                aria-label="Decrease quantity"
              >
                −
              </button>
              <span className="mim-qty-count">{qty}</span>
              <button
                className="mim-qty-btn"
                onClick={() => setQty((q) => q + 1)}
                aria-label="Increase quantity"
              >
                +
              </button>
            </div>
          </div>

          {/* CTA */}
          <button
            className="mim-cta"
            onClick={handleAddToCart}
            disabled={!item.available}
            data-testid="modal-add-btn"
          >
            <CartIcon />
            {isInCart ? `Update Cart — ₹${item.price * qty}` : `Add to Cart — ₹${item.price * qty}`}
          </button>
        </div>
      </div>
    </div>
  );
}

export default MenuItemModal;
