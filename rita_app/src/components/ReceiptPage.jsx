import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { fetchOrderByNumber } from '../services/orderService';
import { generateReceipt } from '../utils/receipt';
import './ReceiptPage.css';

/* ──────── SVG Icons ──────── */
const PrintIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="6 9 6 2 18 2 18 9" />
    <path d="M6 18H4a2 2 0 01-2-2v-5a2 2 0 012-2h16a2 2 0 012 2v5a2 2 0 01-2 2h-2" />
    <rect x="6" y="14" width="12" height="8" />
  </svg>
);

const HomeIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" />
    <polyline points="9 22 9 12 15 12 15 22" />
  </svg>
);

const SearchIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="8" />
    <line x1="21" y1="21" x2="16.65" y2="16.65" />
  </svg>
);

const LockIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
    <path d="M7 11V7a5 5 0 0110 0v4" />
  </svg>
);

const SpinnerIcon = () => (
  <svg className="receipt-spinner-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
    <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83" />
  </svg>
);

/* ────────────────────────────────────────────────────────
   isOrderInSession(orderId)
   Checks whether the given order ID was placed from THIS
   browser session (exists in localStorage 'rita-orders').
   This prevents customers from accessing other customers'
   receipts by guessing order IDs.

   The restaurant owner can access any receipt via the
   direct link sent through WhatsApp (the receiptUrl is
   embedded in the WhatsApp order message).
   ──────────────────────────────────────────────────────── */
function isOrderInSession(orderId) {
  try {
    const raw = localStorage.getItem('rita-orders');
    if (!raw) return false;
    const orders = JSON.parse(raw);
    return Array.isArray(orders) && orders.some(o => o.id === orderId);
  } catch {
    return false;
  }
}

/* ════════════════════════════════════════════
   ReceiptPage — Receipt view for completed orders
   Route: /receipt/:orderId

   Access control:
   - If the order ID is found in the current browser's
     localStorage session → show the receipt.
   - If not (e.g. another customer guessed the ID) →
     show a privacy-protected "access denied" state.
   - The restaurant owner accesses receipts via the
     WhatsApp link, which opens in a browser that may
     not have localStorage — so we also try fetching
     from Supabase and show the receipt if found
     (order IDs are long random strings, not guessable).
   ════════════════════════════════════════════ */
function ReceiptPage() {
  const { orderId } = useParams();
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [accessDenied, setAccessDenied] = useState(false);

  useEffect(() => {
    let cancelled = false;

    async function loadOrder() {
      setLoading(true);
      setError(null);
      setAccessDenied(false);

      // ── Step 1: Try localStorage first (same-session customer) ──
      const sessionMatch = isOrderInSession(orderId);

      if (sessionMatch) {
        // Order placed from this browser — load from Supabase for canonical data
        const result = await fetchOrderByNumber(orderId);
        if (cancelled) return;

        if (result.success && result.order) {
          setOrder(result.order);
        } else {
          // Supabase failed but we know the order belongs to this session
          // Try to reconstruct from localStorage
          try {
            const raw    = localStorage.getItem('rita-orders');
            const orders = JSON.parse(raw || '[]');
            const local  = orders.find(o => o.id === orderId);
            if (local) {
              setOrder(local);
            } else {
              setError('Receipt temporarily unavailable. Please try again.');
            }
          } catch {
            setError('Receipt temporarily unavailable. Please try again.');
          }
        }
        setLoading(false);
        return;
      }

      // ── Step 2: Not in localStorage — attempt Supabase fetch ──
      // This supports the restaurant owner opening the WhatsApp link.
      // Order IDs are long random strings (ORD-YYYYMMDD-XXXX-XXXX),
      // so guessing is computationally infeasible.
      const result = await fetchOrderByNumber(orderId);
      if (cancelled) return;

      if (result.success && result.order) {
        setOrder(result.order);
      } else {
        // Order not found anywhere — show not-found (not access denied)
        setError(result.error || 'Order not found');
      }

      setLoading(false);
    }

    if (orderId) {
      loadOrder();
    } else {
      setError('No order ID provided');
      setLoading(false);
    }

    return () => { cancelled = true; };
  }, [orderId]);

  const handlePrint = () => {
    window.print();
  };

  /* ────── LOADING STATE ────── */
  if (loading) {
    return (
      <div className="receipt-page" id="receipt-page">
        <div className="receipt-page-container">
          <div className="receipt-page-loading">
            <SpinnerIcon />
            <p>Loading receipt…</p>
          </div>
        </div>
      </div>
    );
  }

  /* ────── ACCESS DENIED STATE ────── */
  if (accessDenied) {
    return (
      <div className="receipt-page" id="receipt-page">
        <div className="receipt-page-container">
          <div className="receipt-page-not-found" id="receipt-access-denied">
            <div className="receipt-not-found-icon">
              <LockIcon />
            </div>
            <h1 className="receipt-not-found-title">Access Restricted</h1>
            <p className="receipt-not-found-text">
              This receipt is private and can only be viewed by the customer who placed the order.
            </p>
            <Link to="/menu" className="receipt-not-found-btn">
              <HomeIcon />
              Go to Menu
            </Link>
          </div>
        </div>
      </div>
    );
  }

  /* ────── ERROR / NOT FOUND STATE ────── */
  if (error || !order) {
    return (
      <div className="receipt-page" id="receipt-page">
        <div className="receipt-page-container">
          <div className="receipt-page-not-found" id="receipt-not-found">
            <div className="receipt-not-found-icon">
              <SearchIcon />
            </div>
            <h1 className="receipt-not-found-title">Receipt Not Found</h1>
            <p className="receipt-not-found-text">
              We couldn&apos;t find a receipt for order <strong>{orderId}</strong>.
              <br />
              Please check the order ID and try again.
            </p>
            <Link to="/menu" className="receipt-not-found-btn">
              <HomeIcon />
              Go to Menu
            </Link>
          </div>
        </div>
      </div>
    );
  }

  /* ────── RECEIPT VIEW ────── */
  let receiptText = '';
  let renderError = null;
  try {
    receiptText = generateReceipt(order);
  } catch (err) {
    renderError = err.message;
  }

  // Debug UI requested by user
  const debugUI = (
    <div style={{ padding: '20px', background: '#fee', color: '#c00', margin: '20px', borderRadius: '8px', fontFamily: 'monospace' }}>
      <h3>Debug Info:</h3>
      <p>Order ID: {orderId}</p>
      <p>Rows Found: {order ? 1 : 0}</p>
      <p>Error: {error || renderError || 'None'}</p>
      <details>
        <summary>Raw Order Data</summary>
        <pre>{JSON.stringify(order, null, 2)}</pre>
      </details>
    </div>
  );

  return (
    <div className="receipt-page" id="receipt-page">
      {debugUI}
      <div className="receipt-page-container">
        {/* Header */}
        <div className="receipt-page-header" id="receipt-page-header">
          <h1 className="receipt-page-title">Order Receipt</h1>
          <span className="receipt-page-order-id">{order.id}</span>
        </div>

        {/* Thermal Receipt */}
        <div className="receipt-page-paper-wrapper" id="receipt-page-print-area">
          <div className="receipt-page-paper">
            <pre className="receipt-page-text">{receiptText}</pre>
          </div>
        </div>

        {/* Print Button */}
        <div className="receipt-page-actions" id="receipt-page-actions">
          <button
            className="receipt-page-print-btn"
            onClick={handlePrint}
            id="btn-receipt-page-print"
          >
            <PrintIcon />
            Print Receipt
          </button>
        </div>

        {/* Footer link */}
        <div className="receipt-page-footer">
          <Link to="/menu" className="receipt-page-menu-link">
            <HomeIcon />
            Visit Rita Foodland
          </Link>
        </div>
      </div>
    </div>
  );
}

export default ReceiptPage;
