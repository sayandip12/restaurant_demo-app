import { Link, useLocation } from 'react-router-dom';
import { useCart } from '../context/CartContext';
import './MobileNav.css';

const TABS = [
  {
    to: '/',
    label: 'Home',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" />
        <polyline points="9 22 9 12 15 12 15 22" />
      </svg>
    ),
  },
  {
    to: '/menu',
    label: 'Menu',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="3" width="7" height="7" rx="1" />
        <rect x="14" y="3" width="7" height="7" rx="1" />
        <rect x="3" y="14" width="7" height="7" rx="1" />
        <rect x="14" y="14" width="7" height="7" rx="1" />
      </svg>
    ),
  },
  {
    to: '/track',
    label: 'Order Status',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M16 4h2a2 2 0 012 2v14a2 2 0 01-2 2H6a2 2 0 01-2-2V6a2 2 0 012-2h2" />
        <rect x="8" y="2" width="8" height="4" rx="1" ry="1" />
        <line x1="8" y1="10" x2="16" y2="10" />
        <line x1="8" y1="14" x2="14" y2="14" />
        <line x1="8" y1="18" x2="12" y2="18" />
      </svg>
    ),
  },
  {
    to: '/cart',
    label: 'Cart',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" />
        <line x1="3" y1="6" x2="21" y2="6" />
        <path d="M16 10a4 4 0 01-8 0" />
      </svg>
    ),
  },
];

const MobileNav = () => {
  const { totalItems } = useCart();
  const location = useLocation();

  const isActive = (path) => {
    if (path === '/') return location.pathname === '/';
    return location.pathname.startsWith(path);
  };

  return (
    <nav className="mobile-nav" id="mobile-bottom-nav">
      {TABS.map((tab) => (
        <Link
          key={tab.to}
          to={tab.to}
          className={`mobile-nav__tab ${isActive(tab.to) ? 'mobile-nav__tab--active' : ''}`}
          aria-label={tab.label}
        >
          <span className="mobile-nav__icon">
            {tab.icon}
            {tab.to === '/cart' && totalItems > 0 && (
              <span className="mobile-nav__badge">{totalItems}</span>
            )}
          </span>
          <span className="mobile-nav__label">{tab.label}</span>
        </Link>
      ))}
    </nav>
  );
};

export default MobileNav;
