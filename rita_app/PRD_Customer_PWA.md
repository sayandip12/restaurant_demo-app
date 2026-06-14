# PRD: Customer PWA
**App:** `customer.domain.com`  
**Version:** 1.0  
**Status:** Draft  
**Last Updated:** June 2026  
**Part of:** Restaurant Management System (3-app architecture)

---

## 1. Purpose & Scope

The Customer PWA is the public-facing ordering interface. Customers visit it on their phone browser, browse the menu, add items to cart, checkout with Razorpay or COD, and track their order status — all without downloading anything. They can optionally install it as a PWA for an app-like experience.

**This app handles:**
- Browse menu (search + filter)
- Cart management
- Address management
- Checkout + payment (Razorpay / COD)
- Real-time order status tracking (no map)
- Order history
- User profile

**This app does NOT handle:**
- Menu management (admin only)
- Rider operations
- Payment refunds (admin handles manually)

---

## 2. Users

| User Type | Description |
|---|---|
| Guest | Can browse menu, cannot checkout |
| Logged-in Customer | Full access: cart, checkout, order tracking, history |

Customers self-register with phone number. No admin approval needed.

---

## 3. Tech Stack

| Layer | Technology |
|---|---|
| Framework | React + Vite |
| UI | MUI (Material UI) — mobile-first |
| Data Fetching | React Query (TanStack Query v5) |
| Cart State | Zustand + localStorage persistence |
| Routing | React Router v6 |
| HTTP Client | Axios with interceptors |
| PWA | vite-plugin-pwa (Workbox) |
| Payment | Razorpay Web SDK (loaded via script tag) |
| Push Notifications | Web Push API via Service Worker |
| Auth | JWT in `httpOnly` cookie |

---

## 4. Folder Structure

```
customer-app/
├── public/
│   ├── manifest.json
│   ├── icon-192.png
│   └── icon-512.png
├── src/
│   ├── pages/
│   │   ├── Home.jsx               ← Menu + search
│   │   ├── ItemDetail.jsx
│   │   ├── Cart.jsx
│   │   ├── Addresses.jsx
│   │   ├── Checkout.jsx
│   │   ├── PaymentCallback.jsx
│   │   ├── OrderTracking.jsx
│   │   ├── OrderHistory.jsx
│   │   ├── Login.jsx
│   │   ├── Register.jsx
│   │   └── Profile.jsx
│   ├── components/
│   │   ├── MenuItemCard.jsx
│   │   ├── CategoryTabs.jsx
│   │   ├── SearchBar.jsx
│   │   ├── VegToggle.jsx
│   │   ├── CartFAB.jsx            ← floating cart button
│   │   ├── CartItem.jsx
│   │   ├── GSTBreakdown.jsx
│   │   ├── StatusTimeline.jsx
│   │   ├── AddressCard.jsx
│   │   ├── AddressForm.jsx
│   │   ├── InstallBanner.jsx
│   │   └── BottomNav.jsx
│   ├── hooks/
│   │   ├── useMenu.js
│   │   ├── useOrderStatus.js
│   │   ├── useOrderHistory.js
│   │   └── useAddresses.js
│   ├── services/
│   │   ├── api.js
│   │   └── razorpay.js
│   ├── store/
│   │   ├── cartStore.js           ← Zustand
│   │   └── authStore.js           ← Zustand
│   ├── utils/
│   │   └── gst.js
│   └── App.jsx
├── vite.config.js
└── package.json
```

---

## 5. PWA Configuration

### manifest.json
```json
{
  "name": "[Restaurant Name]",
  "short_name": "[RestName]",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#FF6B35",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### Install Prompt (InstallBanner.jsx)
```javascript
// Show custom banner instead of browser default prompt
useEffect(() => {
  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    setDeferredPrompt(e);
    setShowBanner(true);
  });
}, []);

const handleInstall = async () => {
  deferredPrompt.prompt();
  const { outcome } = await deferredPrompt.userChoice;
  if (outcome === 'accepted') setShowBanner(false);
};
```

Banner shows on home page after 30 seconds if not already installed. Can be dismissed (stores in localStorage so it doesn't show again for 7 days).

### Push Notifications
Customer receives push for:
- Order confirmed by admin
- Out for delivery
- Delivered

```javascript
// Service Worker
self.addEventListener('push', (event) => {
  const data = event.data.json();
  self.registration.showNotification(data.title, {
    body: data.body,
    icon: '/icon-192.png',
    data: { url: `/orders/${data.orderId}` }
  });
});
```

### Offline Behaviour
- Menu pages cached via Workbox `CacheFirst` — customer can browse menu offline
- Cart state persisted in localStorage — survives refresh and offline
- Checkout, payment, order tracking — require network. Show offline banner + disable actions.

```javascript
// vite.config.js Workbox config
runtimeCaching: [
  {
    urlPattern: /\/api\/v1\/menu.*/,
    handler: 'CacheFirst',
    options: {
      cacheName: 'menu-cache',
      expiration: { maxAgeSeconds: 60 * 60 }   // 1 hour
    }
  },
  {
    urlPattern: /\/api\/v1\/orders.*/,
    handler: 'NetworkOnly'                      // never cache orders
  }
]
```

---

## 6. Authentication

### Register Flow
```
Enter Name + Phone + Password
       ↓
POST /auth/register
       ↓
OTP (Phase 2) or direct login (Phase 1)
       ↓
JWT cookie set
       ↓
Redirect to /
```

### Login Flow
```
Enter Phone + Password
      ↓
POST /auth/login { phone, password }
      ↓
Backend sets httpOnly JWT cookie
      ↓
Redirect to previous page or /
```

### Guest Browsing
- Menu is public — no auth required
- Cart can be built without login
- Login required at: clicking "Checkout"
- If not logged in → show login modal → after login → resume checkout

### Zustand Auth Store
```javascript
const useAuthStore = create(
  persist(
    (set) => ({
      user: null,            // { id, name, phone }
      isLoggedIn: false,
      setUser: (user) => set({ user, isLoggedIn: true }),
      logout: () => set({ user: null, isLoggedIn: false }),
    }),
    { name: 'auth-storage' }
  )
);
```

---

## 7. Screens & Detailed Flows

### 7.1 Home / Menu (`/`)

**This is where customers spend most time.**

**Layout (top to bottom):**
```
┌────────────────────────────────┐
│  🍽️ [Restaurant Name]    🛒(3) │  ← header with cart icon + count
├────────────────────────────────┤
│  🔍 Search items...            │  ← search bar
├────────────────────────────────┤
│  [Starters] [Main] [Biryani]   │  ← horizontal scrollable category tabs
│  [Beverages] [Desserts]        │
├────────────────────────────────┤
│  🥦 Veg Only  ○                │  ← toggle
├────────────────────────────────┤
│  ┌──────────────────────────┐  │
│  │ 🖼️  Butter Naan          │  │  ← item card
│  │      Soft, fluffy naan   │  │
│  │      ₹30 (+₹1.50 GST)   │  │
│  │                  [+ ADD] │  │
│  └──────────────────────────┘  │
│  ┌──────────────────────────┐  │
│  │ 🖼️  Paneer Tikka     🔴  │  │  ← non-veg badge
│  │      ...                 │  │
│  └──────────────────────────┘  │
│              ...               │
├────────────────────────────────┤
│  [🛒 View Cart — 3 items ₹313] │  ← sticky bottom cart bar (when cart > 0)
└────────────────────────────────┘
```

**Search:**
- Client-side filtering (no API call per keystroke)
- Filters by `item.name.toLowerCase().includes(query)`
- Clears category filter when searching
- Show "No results for 'xyz'" with clear button

**Category Tabs:**
- Horizontally scrollable, snap-to
- Clicking a tab scrolls menu to that section (or filters to that category)
- "All" tab shows everything

**Veg Toggle:**
- Filters to `is_veg: true` items only
- State persists across page navigation (Zustand)

**Add to Cart Button:**
- First tap → "+" changes to "−  1  +" quantity control
- Subsequent taps adjust quantity
- Quantity change immediately updates Zustand cart store + localStorage

**Sticky Cart Bar:**
- Shows when cart has at least 1 item
- Always visible above bottom nav
- Shows total item count + grand total (including GST)
- Tapping navigates to `/cart`

**React Query:**
```javascript
const useMenu = () =>
  useQuery({
    queryKey: ['menu'],
    queryFn: () => api.get('/menu'),
    staleTime: 30 * 60 * 1000,   // 30 min — menu doesn't change often
  });
```

---

### 7.2 Item Detail (`/items/:itemId`)

Accessed by tapping on item name/image (not the +ADD button).

**Shows:**
- Large image (or placeholder)
- Name, description (full)
- Veg / Non-veg badge
- Price breakdown:
  ```
  Price:      ₹30.00
  GST (5%):    ₹1.50
  Total:      ₹31.50
  ```
- Quantity control + Add to Cart button
- "People also order" (Phase 3 — same category items)

---

### 7.3 Cart (`/cart`)

**Full cart review before checkout.**

**Layout:**
```
┌────────────────────────────────────┐
│ Your Cart (3 items)                │
├────────────────────────────────────┤
│ Butter Naan      − 2 +    ₹60.00  │
│ GST (5%):                  ₹3.00  │
├────────────────────────────────────┤
│ Paneer Tikka     − 1 +   ₹180.00  │
│ GST (5%):                  ₹9.00  │
├────────────────────────────────────┤
│ Cold Drink       − 2 +    ₹60.00  │
│ GST (5%):                  ₹3.00  │
├────────────────────────────────────┤
│ ➕ Add more items                  │  ← back to menu
├────────────────────────────────────┤
│ BILL SUMMARY                       │
│ Subtotal:              ₹300.00     │
│ GST:                    ₹15.00     │
│ Delivery:               ₹30.00     │
│ Discount:                ₹0.00     │
│ ─────────────────────────────────  │
│ TOTAL:                 ₹345.00     │
├────────────────────────────────────┤
│      [Proceed to Checkout]         │
└────────────────────────────────────┘
```

**Behaviour:**
- Quantity changes update Zustand store (no API call — cart is local until checkout)
- Remove item: swipe left on item row (MUI) or reduce qty to 0
- Empty cart state: "Your cart is empty. Start ordering!" + Browse Menu button
- "Proceed to Checkout" → check if logged in → if yes → `/checkout` → if no → show login modal

**Zustand Cart Store:**
```javascript
// store/cartStore.js
const useCartStore = create(
  persist(
    (set, get) => ({
      items: [],     // [{ id, name, price, gstPercent, quantity, imageUrl }]
      
      addItem: (item) => set((state) => {
        const existing = state.items.find(i => i.id === item.id);
        if (existing) {
          return { items: state.items.map(i =>
            i.id === item.id ? { ...i, quantity: i.quantity + 1 } : i
          )};
        }
        return { items: [...state.items, { ...item, quantity: 1 }] };
      }),

      updateQty: (id, qty) => set((state) => ({
        items: qty === 0
          ? state.items.filter(i => i.id !== id)
          : state.items.map(i => i.id === id ? { ...i, quantity: qty } : i)
      })),

      clearCart: () => set({ items: [] }),

      getTotal: () => {
        const items = get().items;
        const subtotal = items.reduce((s, i) => s + i.price * i.quantity, 0);
        const totalGst = items.reduce((s, i) =>
          s + (i.price * i.quantity * i.gstPercent / 100), 0);
        return { subtotal, totalGst, items };
      }
    }),
    { name: 'cart-storage' }    // persists in localStorage
  )
);
```

---

### 7.4 Address Management (`/addresses`)

**Accessed from Checkout screen or Profile.**

**List view:**
- Saved addresses with label (Home / Work / Other)
- Default address highlighted with star
- Edit / Delete per address
- "Add New Address" button

**Add Address Form:**
```
Label*         [Home ▾]     (Home / Work / Other / Custom)
Full Address*  [___________________________________________]
City*          [_____________________]
Pincode*       [______]
Set as default [Toggle]
               [Save Address]
```

**Validation:**
- All fields except label required
- Pincode: 6 digits
- Address stored in `addresses` table linked to `user_id`

---

### 7.5 Checkout (`/checkout`)

**Two-step process: Address → Payment.**

#### Step 1: Select / Confirm Address
```
┌─────────────────────────────────┐
│ Deliver to:                     │
│                                 │
│ ● 🏠 Home (default)             │
│   123 Main St, Kalyani - 741235 │
│   [Edit]                        │
│                                 │
│ ○ 🏢 Work                       │
│   456 Office Rd, Kolkata        │
│                                 │
│ [+ Add New Address]             │
└─────────────────────────────────┘
```

#### Step 2: Payment Method
```
┌─────────────────────────────────┐
│ Payment Method:                 │
│                                 │
│ ● 💳 Pay Online (Razorpay)      │
│   UPI / Card / Net Banking      │
│                                 │
│ ○ 💵 Cash on Delivery (COD)     │
│   Pay ₹345 to rider             │
└─────────────────────────────────┘

Order Summary:
Subtotal:      ₹300
GST:            ₹15
Delivery:       ₹30
Total:         ₹345

[Place Order →]
```

**Place Order click (Razorpay):**
```
POST /payments/create-order { amount, cartItems }
       ↓
Backend creates Razorpay order → returns { razorpay_order_id, amount, key }
       ↓
Frontend opens Razorpay checkout modal (SDK)
       ↓
Customer pays
       ↓
Razorpay calls onSuccess with { razorpay_payment_id, razorpay_signature }
       ↓
POST /payments/verify { razorpay_payment_id, razorpay_order_id, razorpay_signature }
       ↓
Backend verifies HMAC → creates order in DB
       ↓
Redirect to /orders/:newOrderId (tracking page)
       ↓
Clear cart (Zustand)
```

**Place Order click (COD):**
```
POST /orders { items, addressId, paymentMethod: 'cod' }
       ↓
Order created → payment_status: 'pending'
       ↓
Redirect to /orders/:newOrderId
       ↓
Clear cart
```

**Razorpay SDK integration:**
```javascript
// services/razorpay.js
export const openRazorpay = ({ orderId, amount, key, name, prefill, onSuccess, onFailure }) => {
  const options = {
    key,
    amount,
    currency: 'INR',
    name: '[Restaurant Name]',
    order_id: orderId,
    prefill: { name: prefill.name, contact: prefill.phone },
    theme: { color: '#FF6B35' },
    handler: onSuccess,
    modal: { ondismiss: onFailure }
  };
  const rzp = new window.Razorpay(options);
  rzp.open();
};
```

---

### 7.6 Order Tracking (`/orders/:orderId`)

**The screen customer checks after placing order. Most-used post-order screen.**

**Layout:**
```
┌─────────────────────────────────────┐
│ Order #ORD-20260601-042             │
│ Placed at 7:30 PM                  │
├─────────────────────────────────────┤
│                                     │
│  ✅ Order Placed        7:30 PM    │
│     |                               │
│  ✅ Confirmed           7:32 PM    │
│     |                               │
│  🔄 Preparing          ...         │  ← current step (animated)
│     |                               │
│  ⬜ Out for Delivery               │
│     |                               │
│  ⬜ Delivered                      │
│                                     │
├─────────────────────────────────────┤
│ Estimated delivery: ~30-40 mins     │
├─────────────────────────────────────┤
│ Delivering to:                      │
│ 123 Main St, Kalyani                │
├─────────────────────────────────────┤
│ Rider: Mohit Kumar   📞             │  ← tap to call (after out for delivery)
├─────────────────────────────────────┤
│ YOUR ORDER                          │
│ Butter Naan ×2        ₹60          │
│ Paneer Tikka ×1      ₹180          │
│ Cold Drink ×2         ₹60          │
│ GST                   ₹15          │
│ Delivery               ₹30          │
│ TOTAL                 ₹345         │
│ Payment: Razorpay ✅               │
└─────────────────────────────────────┘
```

**Polling:**
```javascript
const useOrderStatus = (orderId) =>
  useQuery({
    queryKey: ['orderStatus', orderId],
    queryFn: () => api.get(`/orders/${orderId}/status`),
    refetchInterval: (data) =>
      data?.status === 'delivered' ? false : 15000,  // stop polling when delivered
  });
```

**Status-based UI changes:**
- `placed` → "Order received! Waiting for confirmation"
- `confirmed` → "Your order is confirmed! Kitchen is getting ready"
- `preparing` → "Your food is being prepared" (animated cooking icon)
- `out_for_delivery` → "On the way! Rider's number visible" 
- `delivered` → Confetti animation + "Enjoy your meal! 🎉"

**Rider phone:** Only visible when status is `out_for_delivery` or `delivered`. Before that, show "—".

---

### 7.7 Order History (`/orders`)

**List of all past orders by the logged-in customer.**

**Each order card:**
```
┌──────────────────────────────────────┐
│ ORD-20260601-042    09 Jun, 7:30 PM  │
│ Butter Naan, Paneer Tikka, +1 more   │
│ ₹345               ✓ Delivered       │
│                    [Reorder]  [View] │
└──────────────────────────────────────┘
```

**Reorder:** Adds same items to cart (if all items still available). If some items unavailable → show which ones were skipped.

**View:** Opens `/orders/:orderId` (read-only, no polling since delivered)

**Pagination:** 10 orders per page, infinite scroll or "Load more"

---

### 7.8 Profile (`/profile`)

```
👤 Rahul Sharma
📞 98XXXXXXXX

[Manage Addresses]
[Order History]
[Install App]        ← show if not installed as PWA
[Logout]
```

---

## 8. Cart Behaviour (Edge Cases)

| Scenario | Behaviour |
|---|---|
| Item goes unavailable while in cart | Show warning banner on cart: "⚠️ Butter Naan is no longer available and was removed" — remove from cart on checkout |
| Cart quantity > available stock | Not applicable in v1 (no inventory management) |
| Customer adds item, logs out, logs back in | Cart persists in localStorage — still there |
| Customer uses two devices | Cart is device-local (localStorage) — no cross-device sync in v1 |
| Restaurant is closed | Show "We're closed right now. We'll be back at 11:00 AM." — disable checkout |

---

## 9. API Endpoints Used

```
POST   /auth/register
POST   /auth/login
POST   /auth/logout

GET    /menu                              Full menu (public)
GET    /menu/categories                   Categories list

GET    /addresses                         Customer's saved addresses
POST   /addresses                         Add new address
PATCH  /addresses/:id                     Edit address
DELETE /addresses/:id                     Remove address
PATCH  /addresses/:id/set-default         Set as default

POST   /payments/create-order             Create Razorpay order
POST   /payments/verify                   Verify payment

POST   /orders                            Place COD order
GET    /orders/my                         Order history
GET    /orders/:id                        Order detail + current status
GET    /orders/:id/status                 Status only (for polling)

GET    /users/me                          Profile info
PATCH  /users/me                          Update name/email

POST   /push/subscribe                    Register push subscription
```

---

## 10. Error States

| Error | UI Behaviour |
|---|---|
| Payment failed (Razorpay) | Show "Payment failed. Try again or use COD." — order not created |
| Payment succeeded but verify fails | Show "Payment done but order confirmation failed. Contact us." — show support number |
| Item unavailable at checkout | "Some items are unavailable and removed from your cart. Please review." |
| Network error on Place Order | "Couldn't place order. Check connection and try again." — order NOT placed, cart intact |
| 401 on checkout | Redirect to login with "Please login to continue" |
| Address delete (is default) | Set next available address as default |

---

## 11. GST Display Logic

Customer-facing GST display should be transparent but not overwhelming:

**On menu card:** Show price, small "(+5% GST)" text in grey  
**On item detail:** Full breakdown — base price + GST amount = total  
**On cart:** Per item row shows item total (GST included), summary shows GST subtotal  
**On order tracking:** Full bill breakdown including per-line GST

```javascript
// utils/gst.js
export const getDisplayPrice = (price, gstPercent) => {
  const gst = price * gstPercent / 100;
  return {
    base: price,
    gst: parseFloat(gst.toFixed(2)),
    total: parseFloat((price + gst).toFixed(2))
  };
};
```

---

## 12. Development Phases

### Phase 1 (MVP)
- [ ] Menu listing (no auth needed)
- [ ] Category tabs + veg filter + search
- [ ] Cart (Zustand + localStorage)
- [ ] Register + Login
- [ ] Address management
- [ ] COD checkout (no Razorpay yet)
- [ ] Order tracking (polling)
- [ ] Order history

### Phase 2
- [ ] Razorpay integration
- [ ] Push notifications (status updates)
- [ ] PWA manifest + install prompt

### Phase 3
- [ ] Service Worker caching (offline menu)
- [ ] Reorder feature
- [ ] Item detail page
- [ ] Restaurant open/closed hours check

---

## 13. Key Notes for Developer

1. **Cart is local until checkout** — never save cart to DB until the customer actually places the order. Reduces API calls and complexity.
2. **Menu is public** — `GET /menu` requires no auth token. Important for first-time visitors and Google indexing.
3. **Razorpay SDK loading** — add `<script src="https://checkout.razorpay.com/v1/checkout.js">` to `index.html`. Do not lazy-load — Razorpay needs to be available immediately when customer clicks Pay.
4. **Polling stops at delivered** — use `refetchInterval` as a function that returns `false` when status is `delivered`. Don't keep polling forever.
5. **COD is most common in India** — prioritize COD UX. Don't hide it below Razorpay. Show both equally.
6. **Price display on cards** — show base price prominently (₹30), GST as small sub-text. Don't show ₹31.50 as the main price — customers will compare with nearby shops.
7. **Mobile keyboard on forms** — set correct `inputMode` on all inputs: `inputMode="numeric"` for phone + pincode, `inputMode="decimal"` for nothing here but relevant if you add tip field.
8. **Empty states matter** — design and implement empty states for: empty cart, no order history, no saved addresses, no search results. These happen on first visit and set the tone.
