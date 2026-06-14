# PRD: Rider PWA
**App:** `rider.domain.com`  
**Version:** 1.0  
**Status:** Draft  
**Last Updated:** June 2026  
**Part of:** Restaurant Management System (3-app architecture)

---

## 1. Purpose & Scope

The Rider PWA is a mobile-first Progressive Web App used exclusively by delivery riders. It is the simplest of the three apps in scope and functionality — riders have one job: pick up orders and deliver them. The app reflects that.

**Rider does NOT need to:**
- See menu
- Handle payments
- Manage anything

**Rider ONLY needs to:**
- See orders assigned to them
- Accept or reject an assignment
- Update order status step by step
- See their last 7 days of delivery history

---

## 2. Users

| User Type | Description |
|---|---|
| Rider | Delivery person on the ground, uses this on personal Android phone |

Riders are created by Admin — there is no self-registration in this app. Admin adds a rider (name + phone + password) and shares credentials.

---

## 3. Tech Stack

| Layer | Technology |
|---|---|
| Framework | React + Vite |
| UI | MUI (Material UI) — mobile components |
| Data Fetching | React Query (TanStack Query v5) |
| Global State | Zustand (minimal — just auth token + active order) |
| Routing | React Router v6 |
| HTTP Client | Axios with interceptors |
| PWA | vite-plugin-pwa (Workbox under the hood) |
| Push Notifications | Web Push API (Service Worker) |
| Auth | JWT stored in `httpOnly` cookie |

---

## 4. Folder Structure

```
rider-app/
├── public/
│   ├── manifest.json
│   ├── icon-192.png
│   └── icon-512.png
├── src/
│   ├── pages/
│   │   ├── Login.jsx
│   │   ├── Dashboard.jsx
│   │   ├── OrderDetail.jsx
│   │   ├── History.jsx
│   │   └── Profile.jsx
│   ├── components/
│   │   ├── OrderCard.jsx
│   │   ├── StatusStepper.jsx
│   │   ├── StatusButton.jsx
│   │   ├── HistoryRow.jsx
│   │   └── BottomNav.jsx
│   ├── hooks/
│   │   ├── useAssignedOrders.js     ← React Query
│   │   ├── useUpdateStatus.js       ← React Query mutation
│   │   └── useRiderHistory.js       ← React Query
│   ├── services/
│   │   └── api.js                   ← all axios calls
│   ├── store/
│   │   └── authStore.js             ← Zustand
│   ├── sw/
│   │   └── push-handler.js          ← service worker push logic
│   ├── App.jsx
│   └── main.jsx
├── vite.config.js
└── package.json
```

---

## 5. PWA Configuration

### manifest.json
```json
{
  "name": "Rider — [Restaurant Name]",
  "short_name": "Rider",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#121212",
  "theme_color": "#FF6B35",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### vite.config.js (PWA plugin)
```javascript
import { VitePWA } from 'vite-plugin-pwa'

export default {
  plugins: [
    VitePWA({
      registerType: 'autoUpdate',
      workbox: {
        runtimeCaching: [
          {
            urlPattern: /\/api\/v1\/riders\/.*/,
            handler: 'NetworkFirst',     // try network, fallback cache
            options: { cacheName: 'rider-api-cache' }
          }
        ]
      }
    })
  ]
}
```

### Push Notifications
- When admin assigns an order → backend sends Web Push to rider's device
- Service Worker wakes up (even if browser is closed on Android)
- Shows notification: "New Order Assigned! Tap to view."
- Tapping opens rider app directly to that order's detail page

```javascript
// sw/push-handler.js
self.addEventListener('push', (event) => {
  const data = event.data.json();
  self.registration.showNotification(data.title, {
    body: data.body,
    icon: '/icon-192.png',
    data: { url: data.url }   // e.g. /orders/abc-123
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  clients.openWindow(event.notification.data.url);
});
```

---

## 6. Authentication

- Riders have `role: 'rider'` in DB
- JWT returned on login → stored in `httpOnly` cookie by backend
- Axios automatically sends cookie on all requests
- If cookie expires / 401 returned → redirect to `/login`
- No "forgot password" in v1 — admin resets manually

### Auth Flow
```
Rider opens rider.domain.com
        ↓
Is JWT cookie valid?
  YES → redirect to /dashboard
  NO  → show /login
        ↓
Enter phone + password
        ↓
POST /auth/login
        ↓
Backend sets httpOnly cookie
        ↓
Redirect to /dashboard
```

### Zustand Auth Store
```javascript
// store/authStore.js
const useAuthStore = create((set) => ({
  rider: null,          // { id, name, phone }
  setRider: (rider) => set({ rider }),
  clearRider: () => set({ rider: null }),
}));
```

---

## 7. Screens & User Flows

### 7.1 Login Screen (`/login`)

**Layout:** Full-screen centered card, dark theme  
**Fields:**
- Phone number (numeric keyboard)
- Password (toggle visibility)
- Login button

**Behaviour:**
- On success → save rider info in Zustand → navigate to `/dashboard`
- On failure → show inline error "Invalid phone or password"
- No register option — riders are created by admin only

---

### 7.2 Dashboard (`/dashboard`)

**This is the main screen riders will live on.**

**Layout:** List of assigned orders, each as a card. If none assigned → empty state "No orders assigned yet."

**Order Card shows:**
- Order number (e.g. ORD-20260601-042)
- Customer name + locality (not full address here)
- Total amount
- Current status badge (color-coded)
- Time since assigned

**Polling / Realtime:**
- React Query `refetchInterval: 15000` (every 15 sec) OR Socket.io event `order:assigned`
- If new order appears → brief animation/highlight on the card

**Actions per card:**
- If status is `assigned` → Show **Accept** and **Reject** buttons
- If status is `accepted` or beyond → Show **View Order** button

**Empty state:**
```
🛵 No orders right now.
Admin will assign orders to you.
```

---

### 7.3 Order Detail (`/orders/:orderId`)

**This is the action screen — where rider spends most time during a delivery.**

**Top Section:**
- Order number + order time
- Status stepper (visual horizontal stepper)

**Customer Info:**
- Customer name
- Delivery address (full)
- Phone number (tappable → opens phone dialer)

**Items List:**
- Each item: name × quantity = price
- Subtotal / GST / Grand Total
- Payment method badge: "Razorpay — Paid" or "COD — Collect ₹345"

**Big CTA Button (bottom, full width):**
- Changes label and color based on current status
- See Section 8 for exact flow

**Reject button:**
- Only visible when status is `assigned`
- Opens confirmation bottom sheet: "Are you sure? Order will go back to admin."

---

### 7.4 History (`/history`)

**Shows last 7 days of deliveries for the logged-in rider.**

**Layout:** Date-grouped list

```
TODAY — 09 Jun 2026
┌─────────────────────────────────┐
│ ORD-042  Sector 5, Kalyani      │
│ ₹345    ✓ Delivered  7:45 PM   │
└─────────────────────────────────┘
┌─────────────────────────────────┐
│ ORD-039  Gayeshpur               │
│ ₹190    ✓ Delivered  5:10 PM   │
└─────────────────────────────────┘

YESTERDAY — 08 Jun 2026
...

SUMMARY (bottom of page)
Last 7 Days: 13 orders · ₹4,110 total
```

**React Query hook:**
```javascript
// hooks/useRiderHistory.js
const useRiderHistory = () =>
  useQuery({
    queryKey: ['riderHistory'],
    queryFn: () => api.get('/riders/me/history?days=7'),
    staleTime: 5 * 60 * 1000,   // 5 min cache
  });
```

---

### 7.5 Profile (`/profile`)

- Rider name + phone (read only)
- "Logout" button
- App version number
- "Install App" banner (if not already installed as PWA)

---

## 8. Order Status Flow (Core Feature)

This is the most important flow in the entire rider app.

```
[Admin assigns order]
         ↓
     ASSIGNED
  ┌────────────────────────────────┐
  │  CTA: "Accept Order"  🟢      │  ← tap this
  │  ALT: "Reject"        🔴      │
  └────────────────────────────────┘
         ↓ (on Accept tap)
     ACCEPTED
  ┌────────────────────────────────┐
  │  CTA: "Start Preparing"  🟡   │  ← tap when kitchen starts
  └────────────────────────────────┘
         ↓
     PREPARING
  ┌────────────────────────────────┐
  │  CTA: "Picked Up"  🔵         │  ← tap when food collected
  └────────────────────────────────┘
         ↓
  OUT FOR DELIVERY
  ┌────────────────────────────────┐
  │  CTA: "Mark Delivered"  ✅    │  ← tap on customer doorstep
  └────────────────────────────────┘
         ↓
     DELIVERED 🎉
  ┌────────────────────────────────┐
  │  "Order Complete!"             │
  │  [Back to Dashboard]           │
  └────────────────────────────────┘
```

**Each CTA tap:**
1. Optimistic UI update (button shows loading spinner)
2. `PATCH /orders/:id/status` → `{ status: 'next_status', riderId }`
3. On success → React Query invalidates order cache → UI refreshes
4. On failure → show snackbar error "Update failed. Try again."

**Confirmation dialogs:**
- "Mark Delivered" → bottom sheet: "Confirm delivery? This cannot be undone."
- "Reject" → bottom sheet: "Reject this order? It will return to admin."

**COD reminder:**
- If payment_method is `cod` → yellow banner on Order Detail: "⚠️ Collect ₹345 cash on delivery"

---

## 9. API Endpoints Used

All calls go to `api.domain.com/v1`. Auth cookie sent automatically.

```
POST   /auth/login                    Login
POST   /auth/logout                   Logout

GET    /riders/me/orders              Assigned orders (dashboard)
GET    /orders/:id                    Single order detail
PATCH  /orders/:id/status             Update status
POST   /orders/:id/reject             Reject assignment

GET    /riders/me/history?days=7      7-day delivery history
GET    /riders/me/profile             Rider profile info
```

---

## 10. State Management

```
React Query                          Zustand
─────────────────────────            ──────────────────
Server state:                        Client state:
- assigned orders list               - logged-in rider info
- order detail                       - (nothing else needed)
- history data
- profile data

Auto refetch on focus ✓
Background sync ✓
Optimistic updates ✓
```

**Cart / persistent state:** Riders have no cart. No Zustand complexity needed beyond auth.

---

## 11. Offline Behaviour

| Scenario | Behaviour |
|---|---|
| No internet on dashboard | Show last cached orders + offline banner |
| Tap status CTA with no internet | Show toast: "No internet. Check connection." — do NOT fire API |
| Internet comes back | React Query auto-refetches on window focus |
| Push notification with no internet | Notification queued by OS, delivered when back online |

---

## 12. Error States

| Error | UI Behaviour |
|---|---|
| Login failed | Inline error below form |
| Status update failed | MUI Snackbar: "Update failed. Try again." — revert optimistic update |
| Order not found (404) | "Order not found. It may have been cancelled." + Back button |
| Session expired (401) | Redirect to `/login` + toast: "Session expired, please login again" |
| Server error (500) | Toast: "Something went wrong. Try again in a moment." |

---

## 13. Bottom Navigation

```
┌───────────┬───────────┬───────────┐
│  🏠        │  📋        │  👤        │
│ Dashboard │  History  │  Profile  │
└───────────┴───────────┴───────────┘
```

Active route highlighted. Badge on Dashboard tab showing count of pending orders.

---

## 14. Development Phases

### Phase 1 (MVP — start here)
- [ ] Login screen + JWT auth
- [ ] Dashboard with assigned orders (polling)
- [ ] Order detail screen
- [ ] Status update flow (Accept → Preparing → Out → Delivered)
- [ ] Reject order

### Phase 2
- [ ] 7-day history screen
- [ ] Push notifications (service worker)
- [ ] COD cash reminder banner
- [ ] PWA manifest + install prompt

### Phase 3
- [ ] Offline caching (Workbox NetworkFirst)
- [ ] Bottom nav badge for pending count
- [ ] Confirmation dialogs for Delivered + Reject

---

## 15. Key Notes for Developer

1. **Do not store JWT in localStorage** — backend must set it as `httpOnly` cookie. Axios will send it automatically.
2. **Polling vs Socket.io** — start with React Query `refetchInterval: 15000`. Add Socket.io only if real-time feels laggy in production.
3. **One active order at a time** — in Phase 1, simplify by only showing orders with status `assigned` or `accepted`. This avoids confusion.
4. **COD is critical** — rider needs to know if they must collect cash. Always show payment method prominently on order detail.
5. **Mobile-only design** — all touch targets minimum 48×48px. No hover states. Bottom navigation always fixed.
6. **Test on actual Android Chrome** — PWA install prompt only works on real device, not desktop browser.
