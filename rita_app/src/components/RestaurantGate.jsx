import { useEffect, useState } from 'react';
import './RestaurantGate.css';

const RestaurantGate = ({ onComplete }) => {
  const [isOpening, setIsOpening] = useState(false);
  const [isRemoved, setIsRemoved] = useState(false);

  const handleGateClick = () => {
    if (isOpening) return;
    setIsOpening(true);
    
    // Call onComplete after animation finishes
    setTimeout(() => {
      setIsRemoved(true);
      if (onComplete) onComplete();
    }, 500);
  };

  if (isRemoved) return null;

  return (
    <div 
      className={`gate ${isOpening ? 'gate--opening' : 'gate--clickable'}`} 
      id="restaurant-gate"
      onClick={handleGateClick}
    >
      {!isOpening && <div className="gate__pulse-text">Click to Enter</div>}
      <div className="gate__frame">
        {/* Left Door */}
        <div className="gate__door gate__door--left">
          <div className="gate__panel">
            <span className="gate__text">RITA</span>
          </div>
          <div className="gate__handle gate__handle--left">
            <div className="gate__handle-inner" />
          </div>
        </div>

        {/* Right Door */}
        <div className="gate__door gate__door--right">
          <div className="gate__panel">
            <span className="gate__text">FOODLAND</span>
          </div>
          <div className="gate__handle gate__handle--right">
            <div className="gate__handle-inner" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default RestaurantGate;
