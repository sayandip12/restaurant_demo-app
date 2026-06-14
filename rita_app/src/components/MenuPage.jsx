import { useState, useEffect, useRef, useMemo, useCallback } from 'react';
import { Link } from 'react-router-dom';
import CATEGORIES from '../data/menuData';
import { useCart } from '../context/CartContext';
import MenuItemCard from './MenuItemCard';
import MenuItemModal from './MenuItemModal';
import './MenuPage.css';

/* -------- SVG Icons -------- */
const SearchIcon = () => (
  <svg className="menu-search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="8" />
    <path d="M21 21l-4.35-4.35" />
  </svg>
);

const ClearIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
    <path d="M18 6L6 18M6 6l12 12" />
  </svg>
);

const ArrowRightIcon = () => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
    <path d="M5 12h14M12 5l7 7-7 7" />
  </svg>
);

function MenuPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [activeCategory, setActiveCategory] = useState(CATEGORIES[0]?.id || '');
  const [modalItem, setModalItem] = useState(null);
  const sectionRefs = useRef({});
  const observerRef = useRef(null);
  const isScrollingRef = useRef(false);
  const mobileCatScrollRef = useRef(null);

  const scrollCats = useCallback((dir) => {
    if (mobileCatScrollRef.current) {
      const scrollAmount = 200;
      mobileCatScrollRef.current.scrollBy({
        left: dir === 'left' ? -scrollAmount : scrollAmount,
        behavior: 'smooth'
      });
    }
  }, []);

  const {
    items: cartItems,
    subtotal,
    deliveryFee,
    gst,
    grandTotal,
    totalItems,
    updateQuantity,
  } = useCart();

  // ---------- Filtered categories based on search ----------
  const filteredCategories = useMemo(() => {
    const q = searchQuery.toLowerCase().trim();
    if (!q) return CATEGORIES;

    return CATEGORIES.map((cat) => ({
      ...cat,
      items: cat.items.filter(
        (item) =>
          item.name.toLowerCase().includes(q) ||
          item.description.toLowerCase().includes(q)
      ),
    })).filter((cat) => cat.items.length > 0);
  }, [searchQuery]);

  const totalFilteredItems = useMemo(
    () => filteredCategories.reduce((sum, cat) => sum + cat.items.length, 0),
    [filteredCategories]
  );

  // ---------- IntersectionObserver for active category ----------
  useEffect(() => {
    if (observerRef.current) observerRef.current.disconnect();

    const options = {
      root: null,
      rootMargin: `-${parseInt(getComputedStyle(document.documentElement).getPropertyValue('--navbar-height')) + 80}px 0px -60% 0px`,
      threshold: 0,
    };

    observerRef.current = new IntersectionObserver((entries) => {
      if (isScrollingRef.current) return;
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          setActiveCategory(entry.target.id);
        }
      });
    }, options);

    // Observe all visible category sections
    filteredCategories.forEach((cat) => {
      const el = sectionRefs.current[cat.id];
      if (el) observerRef.current.observe(el);
    });

    return () => observerRef.current?.disconnect();
  }, [filteredCategories]);

  // ---------- Scroll to category ----------
  const scrollToCategory = useCallback((catId) => {
    setActiveCategory(catId);
    isScrollingRef.current = true;

    const el = sectionRefs.current[catId];
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    // Re-enable observer after scroll settles
    setTimeout(() => {
      isScrollingRef.current = false;
    }, 800);
  }, []);

  // Auto-scroll mobile category chip into view
  useEffect(() => {
    if (!mobileCatScrollRef.current) return;
    const activeBtn = mobileCatScrollRef.current.querySelector('.menu-mobile-cat-btn.active');
    if (activeBtn) {
      activeBtn.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
    }
  }, [activeCategory]);

  // ---------- Modal ----------
  const openModal = useCallback((item) => setModalItem(item), []);
  const closeModal = useCallback(() => setModalItem(null), []);

  return (
    <div className="menu-page" id="menu-page">
      {/* Mobile horizontal categories */}
      <div className="menu-mobile-cats">
        <button className="menu-scroll-btn left" onClick={() => scrollCats('left')} aria-label="Scroll left">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M15 18l-6-6 6-6" /></svg>
        </button>
        <div className="menu-mobile-cats-scroll" ref={mobileCatScrollRef}>
          {CATEGORIES.map((cat) => (
            <button
              key={cat.id}
              className={`menu-mobile-cat-btn${activeCategory === cat.id ? ' active' : ''}`}
              onClick={() => scrollToCategory(cat.id)}
            >
              {cat.name}
            </button>
          ))}
        </div>
        <button className="menu-scroll-btn right" onClick={() => scrollCats('right')} aria-label="Scroll right">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M9 18l6-6-6-6" /></svg>
        </button>
      </div>

      <div className="menu-layout">
        {/* ======== LEFT SIDEBAR ======== */}
        <aside className="menu-sidebar">
          <div className="menu-sidebar-title">Menu</div>
          <ul className="menu-cat-list">
            {CATEGORIES.map((cat) => (
              <li key={cat.id}>
                <button
                  className={`menu-cat-item${activeCategory === cat.id ? ' active' : ''}`}
                  onClick={() => scrollToCategory(cat.id)}
                >
                  <span>{cat.name}</span>
                  <span className="menu-cat-count">{cat.items.length}</span>
                </button>
              </li>
            ))}
          </ul>
        </aside>

        {/* ======== CENTER CONTENT ======== */}
        <section className="menu-center">
          {/* Search */}
          <div className="menu-search-wrap">
            <div className="menu-search">
              <SearchIcon />
              <input
                type="text"
                className="menu-search-input"
                placeholder="Search dishes..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                id="menu-search"
                data-testid="menu-search"
                autoComplete="off"
              />
              {searchQuery && (
                <button
                  className="menu-search-clear"
                  onClick={() => setSearchQuery('')}
                  aria-label="Clear search"
                >
                  <ClearIcon />
                </button>
              )}
            </div>
          </div>

          {/* Results count */}
          {searchQuery && (
            <div className="menu-results-count">
              Showing <strong>{totalFilteredItems}</strong> dish{totalFilteredItems !== 1 ? 'es' : ''}
            </div>
          )}

          {/* Category sections */}
          {filteredCategories.length > 0 ? (
            filteredCategories.map((cat) => (
              <section
                key={cat.id}
                id={cat.id}
                className="menu-category-section"
                ref={(el) => {
                  sectionRefs.current[cat.id] = el;
                }}
              >
                <div className="menu-category-header">
                  <h2 className="menu-category-header-name">{cat.name}</h2>
                  <span className="menu-category-header-count">
                    {cat.items.length} item{cat.items.length !== 1 ? 's' : ''}
                  </span>
                </div>
                <div className="menu-items-grid">
                  {cat.items.map((item) => (
                    <MenuItemCard
                      key={item.id}
                      item={item}
                      onOpenModal={openModal}
                    />
                  ))}
                </div>
              </section>
            ))
          ) : (
            <div className="menu-no-results">
              <div className="menu-no-results-icon">🔍</div>
              <div className="menu-no-results-title">No dishes found</div>
              <p className="menu-no-results-text">
                Try a different search term
              </p>
            </div>
          )}
        </section>

        {/* ======== RIGHT SIDEBAR — Cart ======== */}
        <aside className="menu-cart-sidebar">
          <div className="menu-cart-card">
            <div className="menu-cart-header">
              <h3 className="menu-cart-title">Your Order</h3>
              {totalItems > 0 && (
                <span className="menu-cart-badge">{totalItems} item{totalItems !== 1 ? 's' : ''}</span>
              )}
            </div>

            {cartItems.length === 0 ? (
              <div className="menu-cart-empty">
                <div className="menu-cart-empty-icon">🛒</div>
                <p className="menu-cart-empty-text">
                  Your cart is empty.<br />Add items from the menu!
                </p>
              </div>
            ) : (
              <>
                <div className="menu-cart-items">
                  {cartItems.map((item) => (
                    <div className="menu-cart-item" key={item.id}>
                      <div className="menu-cart-item-info">
                        <div className="menu-cart-item-name">{item.name}</div>
                        <div className="menu-cart-item-price">₹{item.price} each</div>
                      </div>
                      <div className="menu-cart-item-qty">
                        <button onClick={() => updateQuantity(item.id, item.quantity - 1)}>−</button>
                        <span>{item.quantity}</span>
                        <button onClick={() => updateQuantity(item.id, item.quantity + 1)}>+</button>
                      </div>
                      <div className="menu-cart-item-total">₹{item.price * item.quantity}</div>
                    </div>
                  ))}
                </div>

                <div className="menu-cart-summary">
                  <div className="menu-cart-summary-row">
                    <span>Subtotal</span>
                    <span>₹{subtotal}</span>
                  </div>
                  <div className="menu-cart-summary-row">
                    <span>Delivery Fee</span>
                    <span>₹{deliveryFee}</span>
                  </div>
                  <div className="menu-cart-summary-row">
                    <span>GST (5%)</span>
                    <span>₹{gst}</span>
                  </div>
                  <div className="menu-cart-summary-row total">
                    <span>Grand Total</span>
                    <span>₹{grandTotal}</span>
                  </div>
                </div>

                <div className="menu-cart-checkout">
                  <Link to="/cart" className="menu-cart-checkout-btn">
                    <ArrowRightIcon />
                    Proceed to Checkout
                  </Link>
                </div>
              </>
            )}
          </div>
        </aside>
      </div>

      {/* ======== Mobile Floating Cart Bar ======== */}
      {totalItems > 0 && (
        <div className="menu-mobile-cart-bar">
          <div className="menu-mobile-cart-info">
            <span className="menu-mobile-cart-items">{totalItems} item{totalItems !== 1 ? 's' : ''}</span>
            <span className="menu-mobile-cart-total">₹{grandTotal}</span>
          </div>
          <Link to="/cart" className="menu-mobile-cart-btn">
            View Cart
            <ArrowRightIcon />
          </Link>
        </div>
      )}

      {/* ======== Modal ======== */}
      {modalItem && (
        <MenuItemModal item={modalItem} onClose={closeModal} />
      )}
    </div>
  );
}

export default MenuPage;
