import { useState } from 'react';
import './ProfilePage.css';

const PAST_ORDERS = [
  {
    id: '#RF-2801',
    date: 'June 7, 2026',
    items: 'Chicken Biryani ×2, Raita',
    total: '₹590',
    status: 'Delivered',
  },
  {
    id: '#RF-2764',
    date: 'June 4, 2026',
    items: 'Paneer Tikka, Butter Naan ×3',
    total: '₹420',
    status: 'Delivered',
  },
  {
    id: '#RF-2712',
    date: 'May 30, 2026',
    items: 'Family Pack Thali',
    total: '₹1,250',
    status: 'Delivered',
  },
];

const ADDRESSES = [
  {
    id: 1,
    label: 'Home',
    icon: '🏠',
    address: '42, Green Park Society, Near City Mall, Ranchi - 834001',
  },
  {
    id: 2,
    label: 'Work',
    icon: '🏢',
    address: 'Floor 3, Techno Hub, Main Road, Ranchi - 834002',
  },
];

const TABS = ['Order History', 'Saved Addresses', 'Loyalty Points'];

function ProfilePage() {
  const [activeTab, setActiveTab] = useState(0);

  return (
    <div className="page-content profile-page" id="profile-page">
      <div className="profile-container">

        {/* ── Profile Header ── */}
        <div className="profile-header-card" id="profile-header">
          <div className="profile-avatar">
            <span>RK</span>
          </div>
          <div className="profile-info">
            <h1 className="profile-info__name">Rahul Kumar</h1>
            <p className="profile-info__detail">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" /><polyline points="22,6 12,13 2,6" /></svg>
              rahul.kumar@email.com
            </p>
            <p className="profile-info__detail">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6A19.79 19.79 0 012.12 4.18 2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" /></svg>
              +91 98765 43210
            </p>
          </div>
          <button className="btn-secondary btn-sm profile-edit-btn">Edit Profile</button>
        </div>

        {/* ── Tabs ── */}
        <div className="profile-tabs" id="profile-tabs">
          {TABS.map((tab, idx) => (
            <button
              key={tab}
              className={`profile-tab ${activeTab === idx ? 'profile-tab--active' : ''}`}
              onClick={() => setActiveTab(idx)}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* ── Tab Content ── */}
        <div className="profile-tab-content">

          {/* Order History */}
          {activeTab === 0 && (
            <div className="profile-section" id="order-history">
              {PAST_ORDERS.map(order => (
                <div className="order-history-card" key={order.id}>
                  <div className="order-history-card__top">
                    <div>
                      <span className="order-history-card__id">{order.id}</span>
                      <span className="order-history-card__date">{order.date}</span>
                    </div>
                    <span className="order-history-card__status">{order.status}</span>
                  </div>
                  <p className="order-history-card__items">{order.items}</p>
                  <div className="order-history-card__bottom">
                    <span className="order-history-card__total">{order.total}</span>
                    <button className="btn-primary btn-sm">Reorder</button>
                  </div>
                </div>
              ))}
            </div>
          )}

          {/* Saved Addresses */}
          {activeTab === 1 && (
            <div className="profile-section" id="saved-addresses">
              {ADDRESSES.map(addr => (
                <div className="address-card" key={addr.id}>
                  <div className="address-card__header">
                    <span className="address-card__icon">{addr.icon}</span>
                    <span className="address-card__label">{addr.label}</span>
                  </div>
                  <p className="address-card__text">{addr.address}</p>
                  <div className="address-card__actions">
                    <button className="address-action-btn">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" /><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" /></svg>
                      Edit
                    </button>
                    <button className="address-action-btn address-action-btn--danger">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="3 6 5 6 21 6" /><path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2" /></svg>
                      Delete
                    </button>
                  </div>
                </div>
              ))}
              <button className="add-address-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" /></svg>
                Add New Address
              </button>
            </div>
          )}

          {/* Loyalty Points */}
          {activeTab === 2 && (
            <div className="profile-section" id="loyalty-points">
              <div className="loyalty-card">
                <div className="loyalty-card__header">
                  <span className="loyalty-card__icon">🏆</span>
                  <div>
                    <span className="loyalty-card__title">Rita Rewards</span>
                    <span className="loyalty-card__subtitle">Earn points on every order</span>
                  </div>
                </div>
                <div className="loyalty-card__points">
                  <span className="loyalty-card__number">450</span>
                  <span className="loyalty-card__label">Points</span>
                </div>
                <div className="loyalty-progress">
                  <div className="loyalty-progress__bar">
                    <div className="loyalty-progress__fill" style={{ width: '90%' }} />
                  </div>
                  <div className="loyalty-progress__labels">
                    <span>450 pts</span>
                    <span>500 pts — Next Reward 🎁</span>
                  </div>
                </div>
                <p className="loyalty-card__note">Just 50 more points to unlock ₹100 off on your next order!</p>
              </div>

              <div className="loyalty-perks">
                <h3 className="loyalty-perks__title">How to earn</h3>
                <div className="loyalty-perk">
                  <span className="loyalty-perk__icon">🛒</span>
                  <div>
                    <span className="loyalty-perk__name">Order Food</span>
                    <span className="loyalty-perk__desc">Earn 1 point for every ₹10 spent</span>
                  </div>
                </div>
                <div className="loyalty-perk">
                  <span className="loyalty-perk__icon">👥</span>
                  <div>
                    <span className="loyalty-perk__name">Refer a Friend</span>
                    <span className="loyalty-perk__desc">Get 50 bonus points per referral</span>
                  </div>
                </div>

              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default ProfilePage;
