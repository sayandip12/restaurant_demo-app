import { useRef } from 'react';
import { Link } from 'react-router-dom';
import CATEGORIES from '../data/menuData';
import './CategoryChips.css';

const CategoryChips = () => {
  const scrollRef = useRef(null);

  const scrollCats = (dir) => {
    if (scrollRef.current) {
      const scrollAmount = 200;
      scrollRef.current.scrollBy({
        left: dir === 'left' ? -scrollAmount : scrollAmount,
        behavior: 'smooth'
      });
    }
  };

  return (
    <section className="category-chips-section" id="categories">
      <div className="container">
        <div className="chips-wrapper">
          <button className="chips-scroll-btn left" onClick={() => scrollCats('left')} aria-label="Scroll left">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M15 18l-6-6 6-6" /></svg>
          </button>
          
          <div className="chips-scroll-container" ref={scrollRef}>
            {CATEGORIES.map((cat) => (
              <Link
                to={`/menu#${cat.id}`}
                className="category-chip"
                key={cat.id}
              >
                <span className="chip-name">{cat.name}</span>
              </Link>
            ))}
          </div>

          <button className="chips-scroll-btn right" onClick={() => scrollCats('right')} aria-label="Scroll right">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M9 18l6-6-6-6" /></svg>
          </button>
        </div>
      </div>
    </section>
  );
};

export default CategoryChips;
