import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import './Hero.css';

const SLIDER_IMAGES = [
  'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=800&q=80', // Soup
  'https://images.unsplash.com/photo-1626132647523-66f5bf380027?auto=format&fit=crop&w=800&q=80', // Chole Bhature (Indian Curry placeholder)
  'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=800&q=80'  // Crispy Fried Chicken
];

const FEATURES = [
  { 
    icon: (
      <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 3a9 9 0 0 0-9 9v2h18v-2a9 9 0 0 0-9-9z"/>
        <path d="M12 3v-2"/>
        <path d="M3 14h18v2H3z"/>
      </svg>
    ), 
    title: 'Thali Specials', 
    desc: 'Traditional and special thali combos for every appetite' 
  },
  { 
    icon: (
      <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <line x1="12" y1="2" x2="12" y2="22"/>
        <line x1="2" y1="12" x2="22" y2="12"/>
        <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
        <line x1="4.93" y1="19.07" x2="19.07" y2="4.93"/>
      </svg>
    ), 
    title: 'AC Dining', 
    desc: 'Comfortable air-conditioned dining all year round' 
  },
  { 
    icon: (
      <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <rect x="3" y="5" width="12" height="12" rx="1"/>
        <path d="M15 9h3l3 3v5h-6"/>
        <circle cx="7" cy="17" r="2"/>
        <circle cx="17" cy="17" r="2"/>
      </svg>
    ), 
    title: 'City Delivery', 
    desc: 'Fast delivery across the city at your doorstep' 
  },
  { 
    icon: (
      <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M2 12h20"/>
        <path d="M4 12a8 8 0 0 0 16 0"/>
        <path d="M8 12V8"/>
        <path d="M12 12V8"/>
        <path d="M16 12V8"/>
        <line x1="6" y1="4" x2="18" y2="8"/>
        <line x1="6" y1="2" x2="18" y2="6"/>
      </svg>
    ), 
    title: 'Indian & Chinese', 
    desc: 'Wide range of authentic Indian and Chinese dishes' 
  },
];

const Hero = () => {
  const [isVisible, setIsVisible] = useState(false);
  const [currentSlide, setCurrentSlide] = useState(0);

  useEffect(() => {
    const timer = setTimeout(() => setIsVisible(true), 100);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const slideTimer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % SLIDER_IMAGES.length);
    }, 4000);
    return () => clearTimeout(slideTimer);
  }, []);

  return (
    <>
      <section className="hero-section" id="home">
        <div className="hero-content">
          
          {/* Hero Content — Left Side */}
          <div className={`hero-left ${isVisible ? 'is-visible' : ''}`}>
            <div className="hero-text-wrapper">
              <span className="hero-badge-pill">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{marginRight: '6px'}}>
                  <path d="M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z"/>
                </svg>
                AUTHENTIC INDIAN & CHINESE CUISINE
              </span>
              <h1 className="hero-title">Rita Foodland</h1>
              <p className="hero-tagline">Enjoy Your Foodie Mood</p>
              <p className="hero-desc">Delicious meals crafted with quality ingredients, authentic recipes and a passion for great taste.</p>

              <div className="hero-cta-group">
                <Link to="/menu" className="btn-primary hero-btn">
                  Order Now <span style={{marginLeft: '8px'}}>&rarr;</span>
                </Link>
              </div>
            </div>
          </div>

          {/* Hero Content — Right Side (Slider) */}
          <div className={`hero-right ${isVisible ? 'is-visible' : ''}`}>
            <div className="hero-slider-container">
              {SLIDER_IMAGES.map((img, index) => {
                let positionClass = '';
                if (index === currentSlide) {
                  positionClass = 'active';
                } else if (index === (currentSlide - 1 + SLIDER_IMAGES.length) % SLIDER_IMAGES.length) {
                  positionClass = 'prev';
                }
                
                return (
                  <div key={index} className={`hero-slide ${positionClass}`} aria-hidden={index !== currentSlide}>
                    <img src={img} alt="Restaurant Food Showcase" />
                  </div>
                );
              })}
            </div>
          </div>

        </div>
      </section>

      {/* Feature Cards Strip */}
      <section className="hero-features container" aria-label="Key features">
        <div className="features-grid">
          {FEATURES.map((feature, index) => (
            <div className="feature-card" key={index}>
              <span className="feature-icon" aria-hidden="true">{feature.icon}</span>
              <div className="feature-text">
                <h3 className="feature-title">{feature.title}</h3>
                <p className="feature-desc">{feature.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </section>
    </>
  );
};

export default Hero;
