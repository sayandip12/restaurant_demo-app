import React from 'react';
import './ContactPage.css';

const ContactPage = () => {
  return (
    <div className="contact-page page-content">
      <div className="container">
        <section className="section contact-section">
          <div className="contact-header">
            <h1 className="section-title">Get In Touch</h1>
            <p className="section-subtitle">We'd love to hear from you. Reach out for catering, feedback, or inquiries.</p>
          </div>
          
          <div className="contact-info-container">
            <div className="contact-info-card card">
              <h3 className="contact-info-title">Contact Information</h3>
              <div className="contact-info-list">
                <div className="contact-info-item">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z" />
                    <circle cx="12" cy="10" r="3" />
                  </svg>
                  <div>
                    <strong>Address</strong>
                    <p>J.N. Colony, Kalyani, Nadia</p>
                  </div>
                </div>
                <div className="contact-info-item">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z" />
                  </svg>
                  <div>
                    <strong>Phone</strong>
                    <p><a href="tel:+917003764902">7003764902</a> / <a href="tel:+918013119338">8013119338</a></p>
                  </div>
                </div>
                <div className="contact-info-item">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                    <polyline points="22,6 12,13 2,6" />
                  </svg>
                  <div>
                    <strong>Email</strong>
                    <p><a href="mailto:roym6281@gmail.com">roym6281@gmail.com</a></p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
};

export default ContactPage;
