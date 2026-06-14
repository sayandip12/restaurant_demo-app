import Hero from './Hero';
import PopularDishes from './PopularDishes';
import CategoryChips from './CategoryChips';
import OurSpecialities from './OurSpecialities';
import './Homepage.css';

const Homepage = () => {
  return (
    <div className="homepage" id="homepage">
      <Hero />
      <CategoryChips />
      <PopularDishes />
      <OurSpecialities />
    </div>
  );
};

export default Homepage;
