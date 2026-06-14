import { useState, lazy, Suspense } from 'react';
import { Routes, Route, useLocation } from 'react-router-dom';
import Navbar from './components/Navbar';
import Footer from './components/Footer';
import MobileNav from './components/MobileNav';
import WhatsAppButton from './components/WhatsAppButton';
import RestaurantGate from './components/RestaurantGate';
import Homepage from './components/Homepage';
import MandalaBackground from './components/MandalaBackground';
import './App.css';

// Lazy load non-critical pages
const MenuPage = lazy(() => import('./components/MenuPage'));
const CartPage = lazy(() => import('./components/CartPage'));
const TrackOrder = lazy(() => import('./components/TrackOrder'));
const ProfilePage = lazy(() => import('./components/ProfilePage'));
const OffersPage = lazy(() => import('./components/OffersPage'));
const AdminDashboard = lazy(() => import('./components/AdminDashboard'));
const PrivacyPolicyPage = lazy(() => import('./components/PrivacyPolicyPage'));
const ContactPage = lazy(() => import('./components/ContactPage'));
const ReceiptPage = lazy(() => import('./components/ReceiptPage'));

// Toggle for client demos — shows gate animation on first load
const DEMO_MODE = true;

const PageLoader = () => (
  <div className="page-loader">
    <div className="loader-spinner" />
  </div>
);

function App() {
  const [gateComplete, setGateComplete] = useState(!DEMO_MODE);
  const location = useLocation();

  // Skip gate on non-home routes
  const showGate = DEMO_MODE && !gateComplete && location.pathname === '/';

  return (
    <>
      {showGate && (
        <RestaurantGate onComplete={() => setGateComplete(true)} />
      )}

      <MandalaBackground />

      <div className={`app-layout ${showGate ? 'behind-gate' : ''}`}>
        <Navbar />
        <main className="main-content">
          <Suspense fallback={<PageLoader />}>
            <Routes>
              <Route path="/" element={<Homepage />} />
              <Route path="/menu" element={<MenuPage />} />
              <Route path="/cart" element={<CartPage />} />
              <Route path="/track" element={<TrackOrder />} />
              <Route path="/profile" element={<ProfilePage />} />
              <Route path="/offers" element={<OffersPage />} />
              <Route path="/admin" element={<AdminDashboard />} />
              <Route path="/privacy-policy" element={<PrivacyPolicyPage />} />
              <Route path="/contact" element={<ContactPage />} />
              <Route path="/receipt/:orderId" element={<ReceiptPage />} />
            </Routes>
          </Suspense>
        </main>
        <Footer />
        <MobileNav />
        <WhatsAppButton />
      </div>
    </>
  );
}

export default App;
