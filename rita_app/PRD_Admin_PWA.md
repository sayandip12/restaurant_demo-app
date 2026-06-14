# PRD: Admin Dashboard PWA
**App:** `admin.domain.com`  
**Version:** 1.0  
**Status:** Draft  
**Last Updated:** June 2026  
**Part of:** Restaurant Management System (3-app architecture)

---

## 1. Purpose & Scope

The Admin PWA is the control center of the restaurant. The owner/manager uses it from their phone to run the restaurant's digital operations — no laptop, no desktop. Everything from confirming orders to printing thermal bills to checking a rider's weekly performance happens here.

**Admin controls:**
- Incoming orders (confirm / reject)
- Assign orders to riders
- Full menu CRUD (add, edit, delete items + categories)
- Track all active and historical orders
- Generate and print thermal bills with GST
- View and manage riders + their 7-day delivery history

---

## 2. Users

| User Type | Description |
|---|---|
| Admin / Owner | Single user, restaurant owner. Uses personal Android phone. Needs to be online during restaurant hours. |

Only one admin role in v1. Multi-admin / manager roles are out of scope.

---

## 3. Tech Stack

| Layer | Technology |
|---|---|
| Framework | React + Vite |
| UI | MUI (Material UI) |
| Data Fetching | React Query (TanStack Query v5) |
| Global State | Zustand (auth + active notifications) |
| Routing | React Router v6 |
| HTTP Client | Axios with interceptors |
| PWA | vite-plugin-pwa (Workbox) |
| Push Notifications | Web Push API via Service Worker |
| Auth | JWT in `httpOnly` cookie |
| Image Upload | Multipart form → backend → Cloudflare R2 / local |
| PDF Printing | Backend generates PDF → `window.open()` → browser print |

---

## 4. Folder Structure

```
admin-app/
├── public/
│   ├── manifest.json
│   ├── icon-192.png
│   └── icon-512.png
├── src/
│   ├── pages/
│   │   ├── Login.jsx
│   │   ├── Dashboard.jsx
│   │   ├── IncomingOrders.jsx
│   │   ├── ActiveOrders.jsx
│   │   ├── OrderDetail.jsx
│   │   ├── OrderHistory.jsx
│   │   ├── MenuManagement.jsx
│   │   ├── AddEditItem.jsx
│   │   ├── RiderManagement.jsx
│   │   ├── RiderDetail.jsx
│   │   └── Reports.jsx
│   ├── components/
│   │   ├── OrderCard.jsx
│   │   ├── AssignRiderModal.jsx
│   │   ├── MenuItemCard.jsx
│   │   ├── MenuItemForm.jsx
│   │   ├── ThermalBillButton.jsx
│   │   ├── RiderHistoryTable.jsx
│   │   ├── StatCard.jsx
│   │   ├── GSTBreakdown.jsx
│   │   └── BottomNav.jsx
│   ├── hooks/
│   │   ├── useOrders.js
│   │   ├── useMenuItems.js
│   │   ├── useRiders.js
│   │   ├── useRiderHistory.js
│   │   └── useDashboardStats.js
│   ├── services/
│   │   └── api.js
│   ├── store/
│   │   └── authStore.js
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
  "name": "Admin — [Restaurant Name]",
  "short_name": "Admin",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#1a1a2e",
  "theme_color": "#e94560",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### Push Notification Triggers
Admin receives push notifications for:
- **New order placed** by any customer → "🛎️ New Order! ORD-042 — ₹345"
- Tapping opens `/incoming-orders`

```javascript
// Service Worker push handler
self.addEventListener('push', (event) => {
  const data = event.data.json();
  self.registration.showNotification(data.title, {
    body: data.body,
    icon: '/icon-192.png',
    badge: '/badge-72.png',
    vibrate: [200, 100, 200],     // vibrate pattern for new orders
    data: { url: data.url }
  });
});
```

---

## 6. Authentication

- Admin has `role: 'admin'` in DB
- Login with phone + password
- JWT set as `httpOnly` cookie
- All API routes behind `requireRole('admin')` middleware on backend
- Session expires in 7 days (long-lived for convenience — owner shouldn't re-login daily)

---

## 7. Navigation Structure

```
Bottom Nav (5 tabs):
┌──────┬──────┬──────┬──────┬──────┐
│  📊  │  📋  │  🍔  │ 🛵  │  📈  │
│ Dash │Orders│ Menu │Riders│Reports│
└──────┴──────┴──────┴──────┴──────┘
```

Active tab highlighted. Badge on Orders tab = count of unconfirmed orders.

---

## 8. Screens & Detailed Flows

### 8.1 Login (`/login`)
- Phone + password
- No register option
- On success → `/dashboard`

---

### 8.2 Dashboard (`/dashboard`)

**The first screen admin sees. Summary of today's operations.**

**4 Stat Cards (top row):**
```
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│  Today's │ │  Active  │ │ Pending  │ │  Today's │
│  Orders  │ │  Orders  │ │ Confirm  │ │  Revenue │
│    24    │ │    3     │ │    2     │ │  ₹8,450  │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
```

**Recent Orders feed (last 5):**
- Each row: order number | customer | amount | status badge | time

**Quick Actions:**
- "View Incoming" button → `/incoming-orders`
- "Add Menu Item" button → `/menu/add`

**React Query:**
```javascript
const useDashboardStats = () =>
  useQuery({
    queryKey: ['dashboardStats'],
    queryFn: () => api.get('/admin/dashboard/stats'),
    refetchInterval: 30000,    // refresh every 30s
  });
```

---

### 8.3 Incoming Orders (`/incoming-orders`)

**Most time-sensitive screen. Admin confirms or rejects new orders here.**

**Layout:** Card list, newest on top.

**Each card shows:**
- Order number + timestamp ("2 mins ago")
- Customer name + phone (tappable)
- Items summary ("Butter Naan ×2, Paneer Tikka ×1")
- Total amount with GST
- Payment method badge
- **Confirm** button (green) + **Reject** button (red)

**Confirm flow:**
```
Admin taps "Confirm"
      ↓
POST /orders/:id/status { status: 'confirmed' }
      ↓
Order moves to Active Orders
      ↓
Customer gets push notification: "Order confirmed! 🎉"
      ↓
Card disappears from Incoming (with slide-out animation)
```

**Reject flow:**
```
Admin taps "Reject"
      ↓
Bottom sheet: "Reason?" (optional) + Confirm Reject
      ↓
POST /orders/:id/status { status: 'cancelled', reason }
      ↓
Customer gets push notification: "Order cancelled. Sorry!"
```

**Realtime behaviour:**
- Socket.io event `order:new` → new card slides in from top
- Fallback: React Query `refetchInterval: 10000`
- Browser tab title: "🛎️ (2) Incoming Orders" when orders present

---

### 8.4 Active Orders (`/active-orders`)

**All confirmed orders currently in progress.**

**Filter tabs:** All | Confirmed | Preparing | Out for Delivery

**Each card shows:**
- Order number + elapsed time ("In progress 12 mins")
- Customer + area
- Assigned rider name (or "Unassigned" badge in orange)
- Current status + next expected status
- Two action buttons: **Assign Rider** | **View Detail**

**Assign Rider Modal:**
```
Admin taps "Assign Rider" on an order card
        ↓
Bottom sheet modal opens
        ↓
Title: "Assign Rider — ORD-042"
        ↓
List of available riders (not currently on another delivery):
  ○ Mohit Kumar  (Last delivered 1h ago)
  ○ Raju Singh   (Available)
  ○ Deepak Roy   (Last delivered 2h ago)
        ↓
Admin taps a rider → "Confirm Assignment" button
        ↓
POST /orders/:id/assign { riderId }
        ↓
Rider gets push notification
Order card updates with rider's name
```

**Manual status override:**
- Long-press on order card → "Override Status" option
- Admin can force any status (for edge cases)

---

### 8.5 Order Detail (`/orders/:orderId`)

**Full detail view for any order.**

**Sections:**

**Order Info:**
- Order number, date, time placed
- Status timeline (visual stepper)

**Customer Info:**
- Name, phone (tappable), delivery address

**Items Table:**
```
Item           Qty   Price    GST     Total
────────────────────────────────────────────
Butter Naan     2   ₹30×2   ₹3      ₹63
Paneer Tikka    1   ₹180    ₹9      ₹189
Cold Drink      2   ₹30×2   ₹1.50   ₹61.50
────────────────────────────────────────────
Subtotal                            ₹270
GST (total)                         ₹13.50
Delivery charge                     ₹30
Discount                            ₹0
────────────────────────────────────────────
GRAND TOTAL                         ₹313.50
```

**Payment Info:**
- Method (Razorpay / COD) + status (Paid / Pending)
- Razorpay transaction ID if applicable

**Rider Info:**
- Assigned rider name + phone
- Assignment time + acceptance time

**Actions:**
- **Print Thermal Bill** (see Section 11)
- **Reassign Rider** (if needed)
- **Cancel Order** (with reason, only before Out for Delivery)

---

### 8.6 Menu Management (`/menu`)

**Two tabs: Categories | Items**

#### Categories Tab
- List of all categories with toggle to enable/disable
- Add Category button → inline form: category name + save
- Edit category name inline
- Delete category (only if no items linked)

#### Items Tab
- Grid/list of all menu items
- Each card: image thumbnail | name | price | GST% | veg badge | available toggle
- **Add Item** FAB (floating action button) → `/menu/add`
- Tap item card → `/menu/edit/:id`

**Available Toggle:**
- Switch on each card
- `PATCH /menu/items/:id { is_available: false }`
- Instantly hides item from customer app
- Use case: item ran out mid-day

---

### 8.7 Add / Edit Menu Item (`/menu/add` and `/menu/edit/:id`)

**Form Fields:**
```
Item Name*          [___________________________]
Category*           [Dropdown — Starters ▾     ]
Description         [___________________________]
Price (₹)*          [_______]
GST %*              [5% ▾] (options: 0, 5, 12, 18)
Veg / Non-Veg       [● Veg  ○ Non-Veg]
Available           [Toggle ON/OFF]
Image               [Upload Image button]
                    [Image preview 200×200]
```

**Image upload:**
- Max size: 2MB
- Formats: JPG, PNG, WebP
- Uploaded via `POST /menu/items/:id/image` (multipart)
- Preview shown immediately after selection (FileReader API)
- Stored on Cloudflare R2 / local, URL saved in DB

**Validation:**
- Name: required, max 150 chars
- Price: required, positive number, max ₹9999
- GST: required, must be 0/5/12/18
- Image: optional, size/format check client-side

**On Save (Add):** `POST /menu/items`  
**On Save (Edit):** `PATCH /menu/items/:id`  
**On Delete:** Confirmation dialog → `DELETE /menu/items/:id` (soft delete — sets `is_available: false` and `is_deleted: true`)

---

### 8.8 Order History (`/history`)

**Full searchable/filterable log of all orders.**

**Filters (top of page):**
- Date range picker (default: today)
- Status dropdown (All / Delivered / Cancelled / etc.)
- Rider dropdown (All riders + individual)

**Table columns:**
```
Order #  │ Time       │ Customer │ Items  │ Amount  │ Rider  │ Status  │ Actions
─────────┼────────────┼──────────┼────────┼─────────┼────────┼─────────┼─────────
ORD-042  │ 7:30 PM   │ Rahul S  │ 3 items│ ₹313.50 │ Mohit  │ ✓ Done  │ [Bill]
ORD-041  │ 6:15 PM   │ Priya M  │ 2 items│ ₹220    │ Raju   │ ✓ Done  │ [Bill]
```

**Actions column:**
- **Bill** button → opens thermal PDF
- **View** button → opens order detail

**Pagination:** 20 orders per page

**CSV Export (Phase 3):**
- "Export CSV" button → downloads filtered results as `.csv`
- Columns: Date, Order#, Customer, Items, Subtotal, GST, Total, Rider, Status

---

### 8.9 Rider Management (`/riders`)

**List of all registered riders.**

**Each rider card shows:**
- Name + phone
- Status: Active / Inactive toggle
- "View History" button → `/riders/:id`
- "Edit" → edit name/phone
- "Deactivate" → sets `is_active: false`

**Add Rider:**
- Form: Name + Phone + Password (admin sets initial password)
- `POST /admin/riders`

---

### 8.10 Rider Detail / History (`/riders/:riderId`)

**7-day performance view for a specific rider.**

**Header:** Rider name + phone + active status

**Summary bar:**
```
Last 7 Days
Orders: 13  |  Total Amount: ₹4,110  |  Avg per day: ₹587
```

**Date-wise breakdown table:**
```
Date         Orders    Delivered    Cancelled    Amount
────────────────────────────────────────────────────────
09 Jun 2026    4           4            0         ₹1,240
08 Jun 2026    6           6            0         ₹1,980
07 Jun 2026    3           2            1          ₹890
06 Jun 2026    0           -            -             -
...
────────────────────────────────────────────────────────
TOTAL         13          12            1         ₹4,110
```

**Order list (expandable per date row):**
- Order # | Customer area | Amount | Delivered time

**Print History button (Phase 3):** Opens printable summary PDF

---

### 8.11 Reports (`/reports`)

**Phase 3 — basic financial reporting.**

**Daily Revenue Chart:** Bar chart (last 7 days) using Recharts

**GST Summary:**
```
Period: 01 Jun – 09 Jun 2026
────────────────────────────
Total Orders:     87
Total Revenue:    ₹31,450
Total GST Collected: ₹1,572.50
  GST @ 5%:      ₹1,200
  GST @ 12%:     ₹372.50
Net (excl. GST):  ₹29,877.50
```

**Top Items (last 7 days):**
```
1. Butter Naan      ×142    ₹4,260
2. Paneer Tikka     ×89     ₹16,020
3. Cold Drink       ×78     ₹2,340
```

---

## 9. Thermal Bill Feature

### How it works
1. Admin taps **Print Bill** on any order
2. Frontend calls: `GET /orders/:id/bill`
3. Backend generates PDF (80mm width, Courier font)
4. Response: `Content-Type: application/pdf`
5. Frontend: `window.open(billUrl, '_blank')`
6. PDF opens in browser tab
7. Admin presses share → Print (Android Chrome) or Ctrl+P (desktop)

### Bill Format (80mm thermal)
```
================================
      [RESTAURANT NAME]
   Address Line, City - PIN
   Ph: 98XXXXXXXX
================================
Order: ORD-20260601-042
Date : 09 Jun 2026
Time : 7:30 PM
Customer: Rahul Sharma
--------------------------------
ITEM           QTY  AMT
--------------------------------
Butter Naan      2   ₹60.00
Paneer Tikka     1  ₹180.00
Cold Drink       2   ₹60.00
--------------------------------
Subtotal              ₹300.00
GST @5%                ₹15.00
Delivery Chrg          ₹30.00
Discount                ₹0.00
================================
TOTAL                 ₹345.00
================================
Payment: Razorpay (PAID)
Txn ID: pay_XXXXXX
================================
  Thank you! Visit Again! 🙏
================================
```

### GST Line-wise (detailed bill variant)
For tax purposes, admin can toggle "Detailed Bill" which shows per-item GST:
```
Butter Naan ×2
  Price: ₹60 | GST 5%: ₹3.00 | Total: ₹63.00
```

---

## 10. GST Calculation

### Logic (also in `utils/gst.js` on frontend for display)
```javascript
// utils/gst.js

export const calculateItemTotal = (price, qty, gstPercent) => {
  const subtotal = parseFloat((price * qty).toFixed(2));
  const gstAmount = parseFloat((subtotal * gstPercent / 100).toFixed(2));
  return { subtotal, gstAmount, total: subtotal + gstAmount };
};

export const calculateOrderTotals = (items, deliveryCharge = 0, discount = 0) => {
  const subtotal = items.reduce((sum, i) => sum + i.subtotal, 0);
  const totalGst = items.reduce((sum, i) => sum + i.gstAmount, 0);
  const grandTotal = parseFloat(
    (subtotal + totalGst + deliveryCharge - discount).toFixed(2)
  );
  return { subtotal, totalGst, deliveryCharge, discount, grandTotal };
};
```

**Important:** GST is calculated and **stored at order creation time** (snapshot). If admin later changes price of Butter Naan from ₹30 to ₹35, old orders still show ₹30. `order_items` table stores `item_price` and `gst_percent` separately for this reason.

**GST rates used in India for food:**
- 0% — unprocessed food (not applicable here)
- 5% — standard restaurant food
- 12% — packaged/branded food items
- 18% — non-essential (aerated drinks, etc.)

---

## 11. API Endpoints Used

```
POST   /auth/login
POST   /auth/logout

GET    /admin/dashboard/stats

GET    /orders?status=placed            Incoming orders
GET    /orders?status=active            Active orders
GET    /orders?dateFrom=&dateTo=        History with filters
GET    /orders/:id                      Order detail
PATCH  /orders/:id/status               Confirm / cancel / override
POST   /orders/:id/assign               Assign rider
GET    /orders/:id/bill                 PDF thermal bill

GET    /menu/categories
POST   /menu/categories
PATCH  /menu/categories/:id
DELETE /menu/categories/:id
GET    /menu/items
POST   /menu/items
PATCH  /menu/items/:id
DELETE /menu/items/:id
POST   /menu/items/:id/image            Image upload (multipart)

GET    /admin/riders                    All riders
POST   /admin/riders                    Add rider
PATCH  /admin/riders/:id               Edit rider
GET    /riders/:id/history?days=7       Rider history

GET    /admin/reports/summary           Revenue + GST report
```

---

## 12. Error States & Edge Cases

| Scenario | Handling |
|---|---|
| New order comes while admin is on Menu screen | Push notification alerts, badge updates on Orders tab |
| Assign rider to already-assigned order | Backend returns 409 → toast "This order already has a rider assigned" |
| Delete category that has items | Backend returns 400 → toast "Remove items from this category first" |
| Upload image > 2MB | Client-side check → show error before upload |
| Print bill on cancelled order | Bill still generates, shows "CANCELLED" watermark |
| No riders registered | Assign Rider modal shows "No riders available. Add riders first." |
| Revenue report with no orders | Show empty state "No orders in this period" |

---

## 13. Development Phases

### Phase 1 (MVP)
- [ ] Login
- [ ] Dashboard stats
- [ ] Incoming Orders with confirm/reject
- [ ] Active Orders with rider assignment
- [ ] Basic menu management (add/edit/delete items)
- [ ] Order Detail view

### Phase 2
- [ ] Order History with filters
- [ ] Rider Management (add/view/deactivate)
- [ ] Rider 7-day history
- [ ] Push notifications for new orders
- [ ] PWA manifest + install prompt

### Phase 3
- [ ] Thermal bill PDF generation + print
- [ ] GST Reports
- [ ] CSV export
- [ ] Top items report
- [ ] Image upload for menu items

---

## 14. Key Notes for Developer

1. **Admin app is the most complex** — build it after Customer PWA is working. Start with Incoming Orders since that's the highest-value feature.
2. **Real-time orders are critical** — missing a new order notification is the worst UX failure. Ensure push notifications work before launch. Test on physical Android.
3. **Soft delete menu items** — never hard delete. `is_deleted: true` + `is_available: false`. Old `order_items` reference `menu_item_id` — hard delete breaks order history.
4. **Image upload is optional at launch** — ship with no-image support first (placeholder icon). Add image upload in Phase 3 so it doesn't block MVP.
5. **Print on Android Chrome** — `window.print()` works on Android Chrome. No external print library needed. PDF opens → user taps share → print. Test this on actual thermal printer before promising it to owner.
6. **Date/time always show in IST** — all timestamps stored as UTC in DB, convert to IST on frontend using `toLocaleString('en-IN', { timeZone: 'Asia/Kolkata' })`.
