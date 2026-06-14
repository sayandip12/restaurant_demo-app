import { useEffect, useState } from 'react';
import './PrivacyPolicyPage.css';

const SECTIONS = [
  {
    id: 'what-we-collect',
    number: '1',
    title: 'What Information We Collect',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
        <circle cx="12" cy="7" r="4" />
      </svg>
    ),
    content: (
      <>
        <p>
          We only collect the information we absolutely need to get your food to you.
          When you sign up, we'll ask for:
        </p>

        <div className="privacy__info-block">
          <h4 className="privacy__info-label">Your Name and Phone Number</h4>
          <p>
            We use your name to know who you are and your phone number to verify your
            account with a one-time password (OTP). We'll also use it to send you
            updates about your order.
          </p>
        </div>

        <div className="privacy__info-block">
          <h4 className="privacy__info-label">Your Delivery Address</h4>
          <p>This is simply so we know where to deliver your food.</p>
        </div>

        <div className="privacy__highlight privacy__highlight--green">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <polyline points="20 6 9 17 4 12" />
          </svg>
          <div>
            <strong>What We Don't Collect:</strong> We want to be very clear: we never
            ask for or store any payment details like credit cards or bank information,
            since we only accept Cash on Delivery. Our app doesn't use cookies or any
            other tracking tools.
          </div>
        </div>
      </>
    ),
  },
  {
    id: 'how-we-use',
    number: '2',
    title: 'How We Use Your Information',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="12" cy="12" r="10" />
        <line x1="12" y1="8" x2="12" y2="12" />
        <line x1="12" y1="16" x2="12.01" y2="16" />
      </svg>
    ),
    content: (
      <>
        <p>Here's what we do with the information you provide:</p>
        <ul className="privacy__list">
          <li>To manage and secure your account.</li>
          <li>To process your orders and make sure they get delivered to the right place.</li>
          <li>To keep you updated on your order status, like when it's confirmed or on its way.</li>
          <li>To look at general order patterns, which helps us make the app better and more reliable for you.</li>
        </ul>
      </>
    ),
  },
  {
    id: 'who-we-share',
    number: '3',
    title: 'Who We Share Your Information With',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="18" cy="5" r="3" />
        <circle cx="6" cy="12" r="3" />
        <circle cx="18" cy="19" r="3" />
        <line x1="8.59" y1="13.51" x2="15.42" y2="17.49" />
        <line x1="15.41" y1="6.51" x2="8.59" y2="10.49" />
      </svg>
    ),
    content: (
      <>
        <p>
          Your privacy is our priority. We will never sell or rent your personal
          information to anyone.
        </p>
        <p>The only times we share your information are:</p>

        <div className="privacy__info-block">
          <h4 className="privacy__info-label">With Our Delivery Team</h4>
          <p>
            We give your name, address, and phone number to our delivery drivers so
            they can bring you your order.
          </p>
        </div>

        <div className="privacy__info-block">
          <h4 className="privacy__info-label">When Required by Law</h4>
          <p>
            If we are required by law or a court order, we may need to share your
            information with public authorities.
          </p>
        </div>
      </>
    ),
  },
  {
    id: 'data-safety',
    number: '4',
    title: 'Keeping Your Data Safe',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
      </svg>
    ),
    content: (
      <p>
        We take reasonable steps to protect your information from being accessed or
        used by anyone who shouldn't have it. While we do our best to keep everything
        secure, please remember that no system is 100% foolproof.
      </p>
    ),
  },
  {
    id: 'childrens-privacy',
    number: '5',
    title: "Children's Privacy",
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
        <circle cx="9" cy="7" r="4" />
        <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
        <path d="M16 3.13a4 4 0 0 1 0 7.75" />
      </svg>
    ),
    content: (
      <p>
        Our service is intended for users who are 13 years of age or older. We do not
        knowingly collect information from children. If you believe we have accidentally
        collected information from a child, please let us know so we can remove it.
      </p>
    ),
  },
  {
    id: 'policy-changes',
    number: '6',
    title: 'Changes to This Policy',
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
      </svg>
    ),
    content: (
      <p>
        We may update this policy from time to time. If we do, we'll post the changes
        right here on this page and update the "Last updated" date at the top. It's a
        good idea to check back here occasionally to see what's new.
      </p>
    ),
  },
];

function PrivacyPolicyPage() {
  const [isVisible, setIsVisible] = useState(false);
  const [activeSection, setActiveSection] = useState(null);

  useEffect(() => {
    const timer = setTimeout(() => setIsVisible(true), 80);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    // Scroll to top on mount
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  return (
    <div className="page-content privacy-page" id="privacy-policy-page">

      {/* ── Hero Banner ── */}
      <header className={`privacy-hero ${isVisible ? 'is-visible' : ''}`} id="privacy-hero">
        <div className="privacy-hero__inner container">
          <div className="privacy-hero__badge">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            </svg>
            Your Privacy Matters
          </div>
          <h1 className="privacy-hero__title">Privacy Policy</h1>
          <p className="privacy-hero__subtitle">
            Learn how Rita Foodland collects, uses and protects your information.
          </p>
          <div className="privacy-hero__meta">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
              <line x1="16" y1="2" x2="16" y2="6" />
              <line x1="8" y1="2" x2="8" y2="6" />
              <line x1="3" y1="10" x2="21" y2="10" />
            </svg>
            Last Updated: September 16, 2025
          </div>
        </div>
      </header>

      {/* ── Main Content ── */}
      <div className="privacy-layout container">

        {/* Table of Contents — Sidebar */}
        <aside className="privacy-toc" aria-label="Table of contents">
          <h3 className="privacy-toc__title">Contents</h3>
          <nav className="privacy-toc__nav">
            {SECTIONS.map((section) => (
              <a
                key={section.id}
                href={`#section-${section.id}`}
                className={`privacy-toc__link ${activeSection === section.id ? 'is-active' : ''}`}
                onClick={() => setActiveSection(section.id)}
              >
                <span className="privacy-toc__num">{section.number}</span>
                {section.title}
              </a>
            ))}
          </nav>
        </aside>

        {/* Sections */}
        <main className={`privacy-content ${isVisible ? 'is-visible' : ''}`} id="privacy-content">

          {/* Intro */}
          <div className="privacy__intro">
            <p>
              Welcome to Rita Foodland! This Privacy Policy explains what information we
              collect when you use our app, how we use it, and how we keep it safe. Your
              privacy is very important to us, and we're committed to protecting your
              personal data.
            </p>
          </div>

          {/* Policy Sections */}
          {SECTIONS.map((section, index) => (
            <section
              key={section.id}
              id={`section-${section.id}`}
              className="privacy__section"
              style={{ animationDelay: `${index * 60}ms` }}
            >
              <div className="privacy__section-header">
                <div className="privacy__section-icon" aria-hidden="true">
                  {section.icon}
                </div>
                <h2 className="privacy__section-title">
                  <span className="privacy__section-num">{section.number}.</span>
                  {section.title}
                </h2>
              </div>
              <div className="privacy__section-body">
                {section.content}
              </div>
            </section>
          ))}

          {/* Contact Footer Card */}
          <div className="privacy__contact-card" id="privacy-contact">
            <div className="privacy__contact-icon" aria-hidden="true">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
              </svg>
            </div>
            <div>
              <h3 className="privacy__contact-title">Have Questions?</h3>
              <p className="privacy__contact-desc">
                If you have any questions about this Privacy Policy or how we handle
                your data, feel free to reach out to us directly.
              </p>
              <div className="privacy__contact-phones">
                <a href="tel:+917003764902" className="privacy__contact-link">7003764902</a>
                <span className="privacy__contact-sep">·</span>
                <a href="tel:+918013119338" className="privacy__contact-link">8013119338</a>
              </div>
            </div>
          </div>

        </main>
      </div>
    </div>
  );
}

export default PrivacyPolicyPage;
