import { useState } from 'react';
import './OffersPage.css';

const COUPONS = [
  {
    id: 1,
    code: 'RITA20',
    title: '20% off on first order',
    description: 'Maximum discount ₹100. Valid for new users only.',
    color: 'green',
    validTill: 'June 30, 2026',
  },
  {
    id: 2,
    code: 'FAMILY50',
    title: '₹50 off on Family Pack combos',
    description: 'Applicable on all Family Pack items. Min order ₹300.',
    color: 'orange',
    validTill: 'June 25, 2026',
  },
  {
    id: 3,
    code: 'FREEDEL',
    title: 'Free delivery on orders above ₹500',
    description: 'No delivery charges on orders above ₹500.',
    color: 'blue',
    validTill: 'July 15, 2026',
  },
  {
    id: 4,
    code: 'WEEKEND15',
    title: '15% off on weekend orders',
    description: 'Valid on Saturdays & Sundays only. Max discount ₹150.',
    color: 'purple',
    validTill: 'July 31, 2026',
  },
];

function OffersPage() {
  const [copiedId, setCopiedId] = useState(null);

  const handleCopy = (code, id) => {
    navigator.clipboard?.writeText(code).catch(() => {});
    setCopiedId(id);
    setTimeout(() => setCopiedId(null), 2000);
  };

  return (
    <div className="page-content offers-page" id="offers-page">
      <div className="offers-container">

        {/* ── Page Header ── */}
        <header className="offers-header">
          <h1 className="offers-header__title">Offers & Deals</h1>
          <p className="offers-header__subtitle">Grab these exclusive offers before they expire!</p>
        </header>

        {/* ── Coupon Grid ── */}
        <div className="coupons-grid" id="coupons-grid">
          {COUPONS.map(coupon => (
            <div className={`coupon-card coupon-card--${coupon.color}`} key={coupon.id} id={`coupon-${coupon.id}`}>
              <div className={`coupon-card__strip coupon-card__strip--${coupon.color}`} />
              <div className="coupon-card__body">
                <div className="coupon-card__top">
                  <span className="coupon-card__scissors">✂️</span>
                  <div className="coupon-card__code-box">
                    <span className="coupon-card__code">{coupon.code}</span>
                  </div>
                </div>
                <h3 className="coupon-card__title">{coupon.title}</h3>
                <p className="coupon-card__desc">{coupon.description}</p>
                <div className="coupon-card__bottom">
                  <span className="coupon-card__validity">Valid till {coupon.validTill}</span>
                  <button
                    className={`coupon-copy-btn ${copiedId === coupon.id ? 'coupon-copy-btn--copied' : ''}`}
                    onClick={() => handleCopy(coupon.code, coupon.id)}
                  >
                    {copiedId === coupon.id ? (
                      <>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>
                        Copied!
                      </>
                    ) : (
                      <>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2" /><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" /></svg>
                        Copy Code
                      </>
                    )}
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* ── Referral Card ── */}
        <div className="referral-card" id="referral-card">
          <div className="referral-card__content">
            <span className="referral-card__icon">🎁</span>
            <div>
              <h2 className="referral-card__title">Refer a Friend & Get ₹100 Off</h2>
              <p className="referral-card__desc">Share your referral code with friends. When they order, you both get ₹100 off!</p>
            </div>
          </div>
          <button className="btn-primary">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="18" cy="5" r="3" />
              <circle cx="6" cy="12" r="3" />
              <circle cx="18" cy="19" r="3" />
              <line x1="8.59" y1="13.51" x2="15.42" y2="17.49" />
              <line x1="15.41" y1="6.51" x2="8.59" y2="10.49" />
            </svg>
            Share Now
          </button>
        </div>

        {/* ── Festival Banner ── */}
        <div className="festival-banner" id="festival-banner">
          <span className="festival-banner__emoji">🎉</span>
          <h2 className="festival-banner__title">Special Festival Menu Coming Soon!</h2>
          <p className="festival-banner__desc">Stay tuned for limited-edition festival specials, combos, and exciting rewards.</p>
          <div className="festival-banner__dots">
            <span />
            <span />
            <span />
          </div>
        </div>

      </div>
    </div>
  );
}

export default OffersPage;
