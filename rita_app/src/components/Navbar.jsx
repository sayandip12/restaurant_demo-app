import { useState, useEffect, useCallback } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useCart } from '../context/CartContext';
import logoImage from '../assets/logo.png';
import './Navbar.css';

const NAV_LINKS = [
  { to: '/', label: 'Home' },
  { to: '/menu', label: 'Menu' },
  { to: '/contact', label: 'Contact' },
];

const Navbar = () => {
  const [scrolled, setScrolled] = useState(false);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const { totalItems } = useCart();
  const location = useLocation();

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    if (drawerOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => { document.body.style.overflow = ''; };
  }, [drawerOpen]);

  const closeDrawer = useCallback(() => setDrawerOpen(false), []);

  const isActive = (path) => {
    if (path === '/') return location.pathname === '/';
    return location.pathname.startsWith(path);
  };

  return (
    <>
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`} id="main-navbar">
        <div className="navbar__container">
          <Link to="/" className="navbar__logo" aria-label="Rita Foodland Home">
            <div className="navbar__logo-icon">
              <img src={logoImage} alt="Rita Foodland Logo" className="navbar__logo-img" />
            </div>
            <div className="navbar__logo-text">
              <span className="navbar__logo-name">RITA FOODLAND</span>
              <span className="navbar__logo-tagline">AUTHENTIC CUISINE</span>
            </div>
          </Link>

          <nav className="navbar__links" id="desktop-nav">
            {NAV_LINKS.map((link) => (
              <Link
                key={link.to}
                to={link.to}
                className={`navbar__link ${isActive(link.to) ? 'navbar__link--active' : ''}`}
              >
                {link.label}
              </Link>
            ))}
          </nav>

          <div className="navbar__actions">
            <Link to="/cart" className="navbar__cart" aria-label="View cart">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z" />
                <line x1="3" y1="6" x2="21" y2="6" />
                <path d="M16 10a4 4 0 01-8 0" />
              </svg>
              {totalItems > 0 && (
                <span className="navbar__cart-badge" id="cart-badge">{totalItems}</span>
              )}
            </Link>

            <button
              className={`navbar__hamburger ${drawerOpen ? 'navbar__hamburger--open' : ''}`}
              onClick={() => setDrawerOpen(!drawerOpen)}
              aria-label="Toggle navigation menu"
              id="mobile-toggle"
            >
              <span />
              <span />
              <span />
            </button>
          </div>
        </div>
      </header>

      {/* Mobile drawer overlay */}
      <div
        className={`navbar__overlay ${drawerOpen ? 'navbar__overlay--visible' : ''}`}
        onClick={closeDrawer}
        aria-hidden="true"
      />

      {/* Mobile slide-in drawer */}
      <aside
        className={`navbar__drawer ${drawerOpen ? 'navbar__drawer--open' : ''}`}
        id="mobile-menu"
      >
        <div className="navbar__drawer-header">
          <div className="navbar__logo">
            <div className="navbar__logo-icon">
              <img src={logoImage} alt="Rita Foodland Logo" className="navbar__logo-img" />
            </div>
            <div className="navbar__logo-text">
              <span className="navbar__logo-name">RITA FOODLAND</span>
              <span className="navbar__logo-tagline">AUTHENTIC CUISINE</span>
            </div>
          </div>
          <button className="navbar__drawer-close" onClick={closeDrawer} aria-label="Close menu">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <line x1="18" y1="6" x2="6" y2="18" />
              <line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        </div>

        <nav className="navbar__drawer-links">
          {NAV_LINKS.map((link) => (
            <Link
              key={link.to}
              to={link.to}
              className={`navbar__drawer-link ${isActive(link.to) ? 'navbar__drawer-link--active' : ''}`}
              onClick={closeDrawer}
            >
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="navbar__drawer-footer">
          <p className="navbar__drawer-contact">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
            </svg>
            7003764902
          </p>
        </div>
      </aside>
    </>
  );
};

export default Navbar;
