import './TrackOrder.css';

const STEPS = [
  {
    id: 1,
    title: 'Order Received',
    description: 'Your order has been placed successfully',
    time: '2:35 PM',
    status: 'completed',
  },
  {
    id: 2,
    title: 'Preparing',
    description: 'The kitchen is preparing your food',
    time: '2:38 PM',
    status: 'completed',
  },
  {
    id: 3,
    title: 'Ready',
    description: 'Your order is packed and ready',
    time: '',
    status: 'active',
  },
  {
    id: 4,
    title: 'Out for Delivery',
    description: 'Rider is on the way to you',
    time: '',
    status: 'upcoming',
  },
  {
    id: 5,
    title: 'Delivered',
    description: 'Enjoy your meal!',
    time: '',
    status: 'upcoming',
  },
];

const ORDER_ITEMS = [
  { name: 'Chicken Biryani', qty: 2, price: 280 },
  { name: 'Chicken Momo (6 pcs)', qty: 1, price: 120 },
  { name: 'Cold Drink', qty: 2, price: 40 },
];

const subtotal = ORDER_ITEMS.reduce((s, i) => s + i.price * i.qty, 0);
const deliveryFee = 30;
const total = subtotal + deliveryFee;

function CheckIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <polyline points="20 6 9 17 4 12" />
    </svg>
  );
}

function TrackOrder() {
  return (
    <div className="page-content track-page" id="track-order">
      <div className="track-container">

        {/* ── Order Header Card ── */}
        <div className="track-header-card" id="track-header">
          <div className="track-header-card__top">
            <div>
              <span className="track-header-card__label">Order ID</span>
              <h1 className="track-header-card__id">#RF-2847</h1>
            </div>
            <span className="track-header-card__status-badge">In Progress</span>
          </div>
          <div className="track-header-card__meta">
            <div className="track-meta-item">
              <span className="track-meta-item__icon">🕐</span>
              <div>
                <span className="track-meta-item__label">Placed</span>
                <span className="track-meta-item__value">10 minutes ago</span>
              </div>
            </div>
            <div className="track-meta-item">
              <span className="track-meta-item__icon">⏱️</span>
              <div>
                <span className="track-meta-item__label">Estimated Delivery</span>
                <span className="track-meta-item__value">30–40 mins</span>
              </div>
            </div>
          </div>
        </div>

        {/* ── Progress Timeline ── */}
        <div className="track-timeline-card" id="track-timeline">
          <h2 className="track-section-title">Order Status</h2>
          <div className="timeline">
            {STEPS.map((step, idx) => (
              <div className={`timeline__step timeline__step--${step.status}`} key={step.id}>
                {/* Connector line (not for first step) */}
                {idx > 0 && (
                  <div className={`timeline__line timeline__line--${STEPS[idx - 1].status === 'completed' && step.status !== 'upcoming' ? 'filled' : step.status === 'upcoming' ? 'dashed' : 'filled'}`} />
                )}
                <div className="timeline__dot-wrap">
                  <div className={`timeline__dot timeline__dot--${step.status}`}>
                    {step.status === 'completed' && <CheckIcon />}
                    {step.status === 'active' && <span className="timeline__pulse" />}
                  </div>
                </div>
                <div className="timeline__content">
                  <span className="timeline__title">{step.title}</span>
                  <span className="timeline__desc">{step.description}</span>
                  {step.time && <span className="timeline__time">{step.time}</span>}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ── Order Summary ── */}
        <div className="track-summary-card" id="track-summary">
          <h2 className="track-section-title">Order Summary</h2>
          <ul className="track-items">
            {ORDER_ITEMS.map((item, idx) => (
              <li className="track-items__row" key={idx}>
                <span className="track-items__qty">{item.qty}×</span>
                <span className="track-items__name">{item.name}</span>
                <span className="track-items__price">₹{item.price * item.qty}</span>
              </li>
            ))}
          </ul>
          <div className="track-totals">
            <div className="track-totals__row">
              <span>Subtotal</span>
              <span>₹{subtotal}</span>
            </div>
            <div className="track-totals__row">
              <span>Delivery Fee</span>
              <span>₹{deliveryFee}</span>
            </div>
            <div className="track-totals__row track-totals__row--total">
              <span>Total</span>
              <span>₹{total}</span>
            </div>
          </div>
        </div>

        {/* ── Removed Map Placeholder ── */}

        {/* ── Need Help ── */}
        <button className="track-help-btn" id="track-help-btn">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
          </svg>
          Need Help?
        </button>
      </div>
    </div>
  );
}

export default TrackOrder;
