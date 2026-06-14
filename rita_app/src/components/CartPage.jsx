import { useState, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { useCart } from '../context/CartContext';
import { useToast } from '../context/ToastContext';
import {
  generateOrderId,
  generateReceipt,
  generateReceiptPdf,
  sendOrderToWhatsApp,
} from '../utils/receipt';
import { saveOrderToSupabase } from '../services/orderService';
import './CartPage.css';

/* ──────── SVG Icons ──────── */
const TrashIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="3 6 5 6 21 6" />
    <path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2" />
    <line x1="10" y1="11" x2="10" y2="17" />
    <line x1="14" y1="11" x2="14" y2="17" />
  </svg>
);

const ArrowRightIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
    <path d="M5 12h14M12 5l7 7-7 7" />
  </svg>
);

const ArrowLeftIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
    <path d="M19 12H5M12 19l-7-7 7-7" />
  </svg>
);

const MenuIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M3 12h18M3 6h18M3 18h18" />
  </svg>
);

const PlusIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
    <path d="M12 5v14M5 12h14" />
  </svg>
);

const PrintIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="6 9 6 2 18 2 18 9" />
    <path d="M6 18H4a2 2 0 01-2-2v-5a2 2 0 012-2h16a2 2 0 012 2v5a2 2 0 01-2 2h-2" />
    <rect x="6" y="14" width="12" height="8" />
  </svg>
);

const DownloadIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" />
    <polyline points="7 10 12 15 17 10" />
    <line x1="12" y1="15" x2="12" y2="3" />
  </svg>
);

const WhatsAppIcon = () => (
  <svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
    <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
  </svg>
);

const CheckCircleIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M22 11.08V12a10 10 0 11-5.93-9.14" />
    <polyline points="22 4 12 14.01 9 11.01" />
  </svg>
);

const SpinnerIcon = () => (
  <svg className="spinner-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
    <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83" />
  </svg>
);

/* ──────── Validation helpers ──────── */
function validateForm(form) {
  const errors = {};

  // Name: required, min 2 characters
  if (!form.name.trim()) {
    errors.name = 'Full name is required';
  } else if (form.name.trim().length < 2) {
    errors.name = 'Name must be at least 2 characters';
  }

  // Phone: required, exactly 10 digits, starts with 6-9
  if (!form.phone.trim()) {
    errors.phone = 'Phone number is required';
  } else if (!/^\d{10}$/.test(form.phone.trim())) {
    errors.phone = 'Phone number must be exactly 10 digits';
  } else if (!/^[6-9]/.test(form.phone.trim())) {
    errors.phone = 'Phone number must start with 6, 7, 8, or 9';
  }

  // Address: required, min 10 characters
  if (!form.address.trim()) {
    errors.address = 'Delivery address is required';
  } else if (form.address.trim().length < 10) {
    errors.address = 'Please enter a complete address (min 10 characters)';
  }

  return errors;
}

/* ──────── Step Progress Bar ──────── */
function StepIndicator({ step }) {
  const steps = ['Cart', 'Checkout', 'Confirmation'];
  return (
    <div className="checkout-steps" id="checkout-steps">
      {steps.map((label, idx) => {
        const stepNum = idx + 1;
        const isActive = step === stepNum;
        const isComplete = step > stepNum;
        return (
          <div
            key={label}
            className={`checkout-step ${isActive ? 'checkout-step--active' : ''} ${isComplete ? 'checkout-step--complete' : ''}`}
          >
            <div className="checkout-step__circle">
              {isComplete ? '✓' : stepNum}
            </div>
            <span className="checkout-step__label">{label}</span>
          </div>
        );
      })}
    </div>
  );
}

/* ════════════════════════════════════════════
   CartPage — 3-step checkout wizard
   Step 1: Cart review
   Step 2: Checkout form
   Step 3: Confirmation + thermal receipt
   ════════════════════════════════════════════ */
function CartPage() {
  const {
    items,
    subtotal,
    grandTotal,
    totalItems,
    updateQuantity,
    removeItem,
    clearCart,
  } = useCart();
  const { showToast } = useToast();

  // Step management: 1=cart, 2=checkout, 3=confirmation
  const [step, setStep] = useState(1);

  // Checkout form state
  const [form, setForm] = useState({
    name: '',
    phone: '',
    address: '',
    landmark: '',
    notes: '',
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);

  // Placed order data (used in step 3)
  const [placedOrder, setPlacedOrder] = useState(null);

  const handleRemove = (item) => {
    removeItem(item.id);
    showToast(`${item.name} removed from cart`, 'info');
  };

  const handleFormChange = useCallback((e) => {
    const { name, value } = e.target;

    // Restrict phone to numeric only
    if (name === 'phone' && value !== '' && !/^\d*$/.test(value)) {
      return;
    }

    setForm((prev) => ({ ...prev, [name]: value }));
    // Clear error on change
    setErrors((prev) => ({ ...prev, [name]: '' }));
  }, []);

  const handleProceedToCheckout = () => {
    setStep(2);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleBackToCart = () => {
    setStep(1);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handlePlaceOrder = async () => {
    // Validate
    const validationErrors = validateForm(form);
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }

    // Prevent duplicate submissions
    if (loading) return;
    setLoading(true);

    try {
      // Generate order ID & timestamp
      const orderId = generateOrderId();
      const createdAt = new Date().toISOString();

      // Build order object — Supabase-compatible structure
      const order = {
        id: orderId,
        customerName: form.name.trim(),
        phone: form.phone.trim(),
        address: form.address.trim(),
        landmark: form.landmark.trim(),
        notes: form.notes.trim(),
        items: items.map((item) => ({
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
          image: item.image || '',
        })),
        subtotal,
        total: grandTotal,
        status: 'pending',
        createdAt,
        receiptUrl: `${window.location.origin}/receipt/${orderId}`,
      };

      // Store in localStorage (append to existing orders)
      const existingRaw = localStorage.getItem('rita-orders');
      const existingOrders = existingRaw ? JSON.parse(existingRaw) : [];
      existingOrders.push(order);
      localStorage.setItem('rita-orders', JSON.stringify(existingOrders));

      // Persist to Supabase (non-blocking — localStorage is the primary fallback)
      try {
        const result = await saveOrderToSupabase(order);
        if (!result.success) {
          console.warn('[Checkout] Supabase save failed, localStorage backup intact:', result.error);
        }
      } catch (supabaseErr) {
        console.error('[Checkout] Supabase persistence error:', supabaseErr);
      }

      // Clear the cart
      clearCart();

      // Save order for confirmation display
      setPlacedOrder(order);
      setStep(3);
      window.scrollTo({ top: 0, behavior: 'smooth' });

      showToast('Order placed successfully!', 'success');
    } catch (err) {
      console.error('Order placement failed:', err);
      showToast('Something went wrong. Please try again.', 'error');
      setLoading(false); // Re-enable button on failure
    }
  };

  const handlePrint = () => {
    window.print();
  };

  const handleDownloadPdf = () => {
    if (placedOrder) {
      generateReceiptPdf(placedOrder);
    }
  };

  const handleWhatsApp = () => {
    if (placedOrder) {
      sendOrderToWhatsApp(placedOrder);
    }
  };

  /* ────── EMPTY CART STATE ────── */
  if (items.length === 0 && step === 1) {
    return (
      <div className="cart-page" id="cart-page">
        <div className="cart-container">
          <div className="cart-header">
            <h1 className="cart-title">Your Cart</h1>
          </div>
          <div className="cart-empty" data-testid="cart-empty">
            <div className="cart-empty-icon">🛒</div>
            <h2 className="cart-empty-title">Your cart is empty</h2>
            <p className="cart-empty-text">
              Looks like you haven&apos;t added anything to your cart yet.
            </p>
            <Link to="/menu" className="cart-empty-btn">
              <MenuIcon />
              Browse Menu
            </Link>
          </div>
        </div>
      </div>
    );
  }

  /* ────── STEP 3: CONFIRMATION + RECEIPT ────── */
  if (step === 3 && placedOrder) {
    const receiptText = generateReceipt(placedOrder);
    const createdAt = new Date(placedOrder.createdAt);
    const dateStr = createdAt.toLocaleDateString('en-IN', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
    });
    const timeStr = createdAt.toLocaleTimeString('en-IN', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true,
    });

    return (
      <div className="cart-page" id="cart-page">
        <div className="cart-container">
          <StepIndicator step={3} />

          {/* Confirmation Banner */}
          <div className="confirmation-banner" id="order-confirmation">
            <div className="confirmation-icon">
              <CheckCircleIcon />
            </div>
            <h1 className="confirmation-title">Order Placed Successfully!</h1>
            <p className="confirmation-order-id">
              Order ID: <strong>{placedOrder.id}</strong>
            </p>
            <p className="confirmation-message">
              Restaurant will contact you shortly.
            </p>
          </div>

          {/* Thermal Receipt */}
          <div className="receipt-wrapper" id="receipt-print-area">
            <div className="receipt-paper">
              <pre className="receipt-text">{receiptText}</pre>
            </div>
          </div>

          {/* Receipt Actions — Order: Print, PDF, WhatsApp */}
          <div className="receipt-actions" id="receipt-actions">
            <button
              className="receipt-action-btn receipt-action-btn--primary"
              onClick={handlePrint}
              id="btn-print-receipt"
            >
              <PrintIcon />
              Print Receipt
            </button>
            <button
              className="receipt-action-btn receipt-action-btn--secondary"
              onClick={handleDownloadPdf}
              id="btn-download-pdf"
            >
              <DownloadIcon />
              Download PDF
            </button>
            <button
              className="receipt-action-btn receipt-action-btn--whatsapp"
              onClick={handleWhatsApp}
              id="btn-send-whatsapp"
            >
              <WhatsAppIcon />
              Send Order via WhatsApp
            </button>
          </div>

          {/* Back to Menu */}
          <div className="receipt-footer-actions">
            <Link to="/menu" className="cart-add-more">
              <MenuIcon />
              Continue Ordering
            </Link>
          </div>
        </div>
      </div>
    );
  }

  /* ────── STEP 2: CHECKOUT FORM ────── */
  if (step === 2) {
    return (
      <div className="cart-page" id="cart-page">
        <div className="cart-container">
          <StepIndicator step={2} />

          <div className="checkout-header">
            <button className="checkout-back-btn" onClick={handleBackToCart}>
              <ArrowLeftIcon />
              Back to Cart
            </button>
            <h1 className="cart-title">Checkout</h1>
          </div>

          {/* Order Summary Mini */}
          <div className="checkout-order-summary" id="checkout-order-summary">
            <div className="checkout-summary-title">Order Summary</div>
            {items.map((item) => (
              <div className="checkout-summary-item" key={item.id}>
                <span className="checkout-summary-qty">{item.quantity}×</span>
                <span className="checkout-summary-name">{item.name}</span>
                <span className="checkout-summary-price">₹{item.price * item.quantity}</span>
              </div>
            ))}
            <div className="checkout-summary-total">
              <span>Total</span>
              <span>₹{grandTotal}</span>
            </div>
          </div>

          {/* Checkout Form */}
          <form
            className="checkout-form"
            id="checkout-form"
            onSubmit={(e) => {
              e.preventDefault();
              handlePlaceOrder();
            }}
            noValidate
          >
            <h2 className="checkout-form-title">Delivery Details</h2>

            {/* Full Name */}
            <div className={`form-group ${errors.name ? 'form-group--error' : ''}`}>
              <label className="form-label" htmlFor="checkout-name">
                Full Name <span className="form-required">*</span>
              </label>
              <input
                className="form-input"
                type="text"
                id="checkout-name"
                name="name"
                placeholder="Enter your full name"
                value={form.name}
                onChange={handleFormChange}
                autoComplete="name"
              />
              {errors.name && <span className="form-error">{errors.name}</span>}
            </div>

            {/* Phone Number */}
            <div className={`form-group ${errors.phone ? 'form-group--error' : ''}`}>
              <label className="form-label" htmlFor="checkout-phone">
                Phone Number <span className="form-required">*</span>
              </label>
              <div className="form-input-prefix">
                <span className="form-prefix">+91</span>
                <input
                  className="form-input form-input--prefixed"
                  type="tel"
                  id="checkout-phone"
                  name="phone"
                  placeholder="10-digit mobile number"
                  value={form.phone}
                  onChange={handleFormChange}
                  maxLength={10}
                  inputMode="numeric"
                  autoComplete="tel"
                />
              </div>
              {errors.phone && <span className="form-error">{errors.phone}</span>}
            </div>

            {/* Delivery Address */}
            <div className={`form-group ${errors.address ? 'form-group--error' : ''}`}>
              <label className="form-label" htmlFor="checkout-address">
                Delivery Address <span className="form-required">*</span>
              </label>
              <textarea
                className="form-input form-textarea"
                id="checkout-address"
                name="address"
                placeholder="Enter your full delivery address"
                rows="3"
                value={form.address}
                onChange={handleFormChange}
                autoComplete="street-address"
              />
              {errors.address && <span className="form-error">{errors.address}</span>}
            </div>

            {/* Landmark (optional) */}
            <div className="form-group">
              <label className="form-label" htmlFor="checkout-landmark">
                Landmark <span className="form-optional">(optional)</span>
              </label>
              <input
                className="form-input"
                type="text"
                id="checkout-landmark"
                name="landmark"
                placeholder="e.g., Near ABC School"
                value={form.landmark}
                onChange={handleFormChange}
              />
            </div>

            {/* Order Notes (optional) */}
            <div className="form-group">
              <label className="form-label" htmlFor="checkout-notes">
                Order Notes <span className="form-optional">(optional)</span>
              </label>
              <textarea
                className="form-input form-textarea"
                id="checkout-notes"
                name="notes"
                placeholder="Any special instructions for the restaurant"
                rows="2"
                value={form.notes}
                onChange={handleFormChange}
              />
            </div>

            {/* Place Order Button */}
            <button
              type="submit"
              className={`cart-checkout-btn ${loading ? 'cart-checkout-btn--loading' : ''}`}
              disabled={loading}
              id="btn-place-order"
              data-testid="place-order-btn"
            >
              {loading ? (
                <>
                  <SpinnerIcon />
                  Placing Order…
                </>
              ) : (
                <>
                  Place Order
                  <ArrowRightIcon />
                </>
              )}
            </button>
          </form>
        </div>
      </div>
    );
  }

  /* ────── STEP 1: CART REVIEW (default) ────── */
  return (
    <div className="cart-page" id="cart-page">
      <div className="cart-container">
        <StepIndicator step={1} />

        {/* Header */}
        <div className="cart-header">
          <h1 className="cart-title">Your Cart</h1>
          <span className="cart-count">
            {totalItems} item{totalItems !== 1 ? 's' : ''}
          </span>
        </div>

        {/* Cart Items */}
        <div className="cart-items-list" data-testid="cart-items-list">
          {items.map((item) => (
            <div className="cart-item" key={item.id} data-testid="cart-item">
              <img
                className="cart-item-image"
                src={item.image}
                alt={item.name}
                loading="lazy"
              />
              <div className="cart-item-info">
                <div className="cart-item-name">{item.name}</div>
                <div className="cart-item-price">₹{item.price} each</div>
              </div>
              <div className="cart-item-qty">
                <button
                  onClick={() => updateQuantity(item.id, item.quantity - 1)}
                  aria-label="Decrease quantity"
                >
                  −
                </button>
                <span>{item.quantity}</span>
                <button
                  onClick={() => updateQuantity(item.id, item.quantity + 1)}
                  aria-label="Increase quantity"
                >
                  +
                </button>
              </div>
              <div className="cart-item-total">₹{item.price * item.quantity}</div>
              <button
                className="cart-item-remove"
                onClick={() => handleRemove(item)}
                aria-label={`Remove ${item.name}`}
                data-testid="cart-item-remove"
              >
                <TrashIcon />
              </button>
            </div>
          ))}
        </div>

        {/* Price Summary — Phase 1: Only subtotal/total (GST & delivery are 0) */}
        <div className="cart-summary" data-testid="cart-summary">
          <div className="cart-summary-title">Price Summary</div>
          <div className="cart-summary-row">
            <span>Subtotal</span>
            <span>₹{subtotal}</span>
          </div>
          <hr className="cart-summary-divider" />
          <div className="cart-summary-row total">
            <span>Total</span>
            <span>₹{grandTotal}</span>
          </div>
        </div>

        {/* Actions */}
        <div className="cart-actions">
          <button
            className="cart-checkout-btn"
            onClick={handleProceedToCheckout}
            data-testid="checkout-btn"
          >
            Proceed to Checkout
            <ArrowRightIcon />
          </button>
          <Link to="/menu" className="cart-add-more">
            <PlusIcon />
            Add more items
          </Link>
        </div>
      </div>
    </div>
  );
}

export default CartPage;
