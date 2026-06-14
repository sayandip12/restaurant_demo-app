/* ============================================
   AdminDashboard — Coming Soon Placeholder
   /admin route
   The real admin system has not been built yet.
   This placeholder prevents customers from seeing
   fake data or accessing internal restaurant tools.
   ============================================ */

import './AdminDashboard.css';

function AdminDashboard() {
  return (
    <div className="admin-coming-soon-page" id="admin-dashboard">
      <div className="admin-coming-soon-blur" aria-hidden="true" />

      <div className="admin-coming-soon-card" role="main">
        {/* Lock icon */}
        <div className="admin-coming-soon-icon" aria-hidden="true">
          <svg
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.5"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
            <path d="M7 11V7a5 5 0 0110 0v4" />
          </svg>
        </div>

        {/* Branding */}
        <div className="admin-coming-soon-brand">
          <span className="admin-coming-soon-logo">RF</span>
          <span className="admin-coming-soon-name">Rita Foodland</span>
        </div>

        <h1 className="admin-coming-soon-title">Admin Dashboard</h1>
        <p className="admin-coming-soon-subtitle">Coming Soon</p>

        <p className="admin-coming-soon-description">
          The restaurant management dashboard is currently under development.
          <br />
          Please contact the restaurant owner directly for order assistance.
        </p>

        {/* Divider */}
        <div className="admin-coming-soon-divider" />

        {/* Planned features */}
        <p className="admin-coming-soon-features-label">Planned Features</p>
        <ul className="admin-coming-soon-features" aria-label="Planned admin features">
          <li>
            <span className="admin-feature-dot" aria-hidden="true" />
            Order Management &amp; Status Tracking
          </li>
          <li>
            <span className="admin-feature-dot" aria-hidden="true" />
            Real-Time Order Dashboard
          </li>
          <li>
            <span className="admin-feature-dot" aria-hidden="true" />
            Customer Management
          </li>
          <li>
            <span className="admin-feature-dot" aria-hidden="true" />
            Sales Analytics
          </li>
          <li>
            <span className="admin-feature-dot" aria-hidden="true" />
            Menu Management
          </li>
        </ul>

        {/* Contact CTA */}
        <a
          href="tel:+917003764902"
          className="admin-coming-soon-contact-btn"
          id="admin-contact-owner-btn"
        >
          <svg
            width="18"
            height="18"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            aria-hidden="true"
          >
            <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
          </svg>
          Contact Restaurant Owner
        </a>
      </div>
    </div>
  );
}

export default AdminDashboard;
