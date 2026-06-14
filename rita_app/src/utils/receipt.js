/**
 * Receipt Utilities
 *
 * Provides: order ID generation, thermal receipt text,
 * PDF generation, and WhatsApp order dispatch.
 *
 * Character width reference:
 *   58mm printer  ≈ 32 chars at 12pt   → use W=32
 *   80mm printer  ≈ 48 chars at 10pt   → use W=48
 *   We default to W=40 which renders correctly on both.
 */

import { jsPDF } from 'jspdf';

/* ─────────────────────────────────────────────
   generateOrderId()
   Format: ORD-YYYYMMDD-0001-XXXX
   Daily counter resets automatically.
   Random 4-char suffix prevents cross-device collisions.
   ───────────────────────────────────────────── */
export function generateOrderId() {
  const now = new Date();
  const yyyy = now.getFullYear();
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const dd = String(now.getDate()).padStart(2, '0');
  const dateStr = `${yyyy}${mm}${dd}`;

  const LAST_DATE_KEY = 'rita-last-order-date';
  const LAST_SEQ_KEY = 'rita-last-order-sequence';

  const lastDate = localStorage.getItem(LAST_DATE_KEY);
  let sequence = 1;

  if (lastDate === dateStr) {
    const lastSeq = parseInt(localStorage.getItem(LAST_SEQ_KEY), 10);
    sequence = (isNaN(lastSeq) ? 0 : lastSeq) + 1;
  }

  localStorage.setItem(LAST_DATE_KEY, dateStr);
  localStorage.setItem(LAST_SEQ_KEY, String(sequence));

  const seqStr = String(sequence).padStart(4, '0');

  // Append random suffix to prevent collisions across devices/browsers
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  let suffix = '';
  for (let i = 0; i < 4; i++) {
    suffix += chars[Math.floor(Math.random() * chars.length)];
  }
  return `ORD-${dateStr}-${seqStr}-${suffix}`;
}

/* ─────────────────────────────────────────────
   centerText(text, width)
   Centers text within a fixed character width.
   ───────────────────────────────────────────── */
function centerText(text, width) {
  if (text.length >= width) return text;
  const padding = Math.floor((width - text.length) / 2);
  return ' '.repeat(padding) + text;
}

/* ─────────────────────────────────────────────
   padRow(left, right, width)
   Left-aligns left text, right-aligns right text
   within a fixed width. Ensures at least 1 space gap.
   ───────────────────────────────────────────── */
function padRow(left, right, width) {
  const gap = width - left.length - right.length;
  return left + ' '.repeat(Math.max(gap, 1)) + right;
}

/* ─────────────────────────────────────────────
   truncate(text, maxLen)
   Truncates text to fit thermal width.
   ───────────────────────────────────────────── */
function truncate(text, maxLen) {
  if (!text) return '';
  return text.length > maxLen ? text.slice(0, maxLen - 1) + '…' : text;
}

/* ─────────────────────────────────────────────
   generateReceipt(order, options)
   Returns a plain-text thermal-printer-friendly receipt.
   Works on 58mm (W=32) and 80mm (W=48) printers.
   Default W=40 is compatible with both at standard
   monospace fonts used by thermal ESC/POS drivers.
   ───────────────────────────────────────────── */
export function generateReceipt(order, options = {}) {
  const W = options.width || 40; // character width — 40 fits 58mm and 80mm
  const line  = '─'.repeat(W);
  const dline = '═'.repeat(W);

  const createdAt = new Date(order.createdAt);
  const dateStr = createdAt.toLocaleDateString('en-IN', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  });
  const timeStr = createdAt.toLocaleTimeString('en-IN', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true,
  });

  let r = '';

  // ── Header ──
  r += dline + '\n';
  r += centerText('RITA FOODLAND', W) + '\n';
  r += centerText('Authentic Cuisine', W) + '\n';
  r += centerText('J.N. Colony, Kalyani', W) + '\n';
  r += centerText('Ph: 7003764902', W) + '\n';
  r += dline + '\n';

  // ── Order info ──
  r += `Order : ${order.id}\n`;
  r += `Date  : ${dateStr}\n`;
  r += `Time  : ${timeStr}\n`;
  r += line + '\n';

  // ── Customer details ──
  r += `Name  : ${truncate(order.customerName, W - 8)}\n`;
  r += `Phone : ${order.phone}\n`;

  // Wrap long addresses to fit thermal width
  const addrPrefix = 'Addr  : ';
  const addrMax = W - addrPrefix.length;
  const addr = order.address || '';
  if (addr.length <= addrMax) {
    r += addrPrefix + addr + '\n';
  } else {
    r += addrPrefix + addr.slice(0, addrMax) + '\n';
    // Continuation lines indented
    let rest = addr.slice(addrMax);
    while (rest.length > 0) {
      r += '          ' + rest.slice(0, W - 10) + '\n';
      rest = rest.slice(W - 10);
    }
  }

  if (order.landmark) {
    r += `Land  : ${truncate(order.landmark, W - 8)}\n`;
  }
  if (order.notes) {
    r += `Notes : ${truncate(order.notes, W - 8)}\n`;
  }

  // ── Items ──
  r += line + '\n';
  r += padRow('ITEM', 'AMT', W) + '\n';
  r += line + '\n';

  const items = order.items || [];
  for (const item of items) {
    const qty       = item.quantity;
    const itemTotal = item.price * qty;
    // Item name line — truncate to fit with qty prefix
    const nameLine  = `${qty}x ${truncate(item.name, W - 8)}`;
    r += nameLine + '\n';
    r += padRow('', `Rs.${itemTotal}`, W) + '\n';
  }

  // ── Totals ──
  r += line + '\n';
  r += padRow('  Subtotal', `Rs.${order.subtotal}`, W) + '\n';
  r += dline + '\n';
  r += padRow('  TOTAL', `Rs.${order.total}`, W) + '\n';
  r += dline + '\n';

  // ── Footer ──
  r += '\n';
  r += centerText('Thank you for your order!', W) + '\n';
  r += centerText('We will contact you shortly.', W) + '\n';
  r += '\n';
  r += centerText('* * * RITA FOODLAND * * *', W) + '\n';

  return r;
}

/* ─────────────────────────────────────────────
   generateReceiptPdf(order)
   Generates and downloads a PDF receipt using jsPDF.
   Uses 80mm page width for maximum readability.
   ───────────────────────────────────────────── */
export function generateReceiptPdf(order) {
  // 80mm thermal receipt width ≈ 226 pts
  const pageWidth = 226;
  const doc = new jsPDF({
    unit: 'pt',
    format: [pageWidth, 800], // tall enough for any order
  });

  const margin    = 10;
  let y           = 18;
  const lineH     = 13;
  const smallH    = 11;
  const contentW  = pageWidth - margin * 2;

  const addLine = (text, size = 8, style = 'normal', align = 'left') => {
    doc.setFontSize(size);
    doc.setFont('courier', style);
    if (align === 'center') {
      doc.text(text, pageWidth / 2, y, { align: 'center' });
    } else {
      doc.text(text, margin, y);
    }
    y += size >= 10 ? lineH : smallH;
  };

  const addRight = (textLeft, textRight, size = 8) => {
    doc.setFontSize(size);
    doc.setFont('courier', 'normal');
    if (textLeft) doc.text(textLeft, margin, y);
    doc.text(textRight, margin + contentW, y, { align: 'right' });
    y += size >= 10 ? lineH : smallH;
  };

  const addSep = (double = false) => {
    doc.setDrawColor(80);
    doc.setLineWidth(double ? 1 : 0.5);
    doc.line(margin, y - 2, margin + contentW, y - 2);
    y += 4;
  };

  const createdAt = new Date(order.createdAt);
  const dateStr   = createdAt.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
  const timeStr   = createdAt.toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit', hour12: true });

  // ── Header ──
  addLine('RITA FOODLAND', 13, 'bold', 'center');
  addLine('Authentic Cuisine · J.N. Colony, Kalyani', 7, 'normal', 'center');
  addLine('Ph: 7003764902', 7, 'normal', 'center');
  addSep(true);

  // ── Order info ──
  addLine(`Order : ${order.id}`, 9, 'bold');
  addLine(`Date  : ${dateStr}`);
  addLine(`Time  : ${timeStr}`);
  addSep();

  // ── Customer details ──
  addLine(`Name  : ${order.customerName}`);
  addLine(`Phone : ${order.phone}`);

  // Wrap address
  const addrLines = doc.splitTextToSize(`Addr  : ${order.address}`, contentW);
  for (const al of addrLines) {
    addLine(al);
  }
  if (order.landmark) addLine(`Land  : ${order.landmark}`);
  if (order.notes) {
    const noteLines = doc.splitTextToSize(`Notes : ${order.notes}`, contentW);
    for (const nl of noteLines) addLine(nl);
  }
  addSep();

  // ── Items ──
  addRight('ITEM', 'AMT', 8);
  y += 2;
  addSep();

  const items = order.items || [];
  for (const item of items) {
    const itemTotal = item.price * item.quantity;
    addLine(`${item.quantity}x ${item.name}`);
    addRight('', `Rs.${itemTotal}`);
  }

  addSep();
  addRight('  Subtotal:', `Rs.${order.subtotal}`, 8);
  y += 2;
  addSep(true);
  addRight('  TOTAL:', `Rs.${order.total}`, 11);
  y += 4;
  addSep(true);

  // ── Footer ──
  y += 4;
  addLine('Thank you for your order!', 8, 'normal', 'center');
  addLine('We will contact you shortly.', 7, 'normal', 'center');
  y += 4;
  addLine('* * * RITA FOODLAND * * *', 7, 'normal', 'center');

  // Trim the page to actual content height
  doc.internal.pageSize.setHeight(y + 20);

  doc.save(`${order.id}.pdf`);
}

/* ─────────────────────────────────────────────
   sendOrderToWhatsApp(order, restaurantPhone)
   Formats the order as a clean WhatsApp message
   using WhatsApp bold (*text*) markdown.
   Opens wa.me link which works on mobile and desktop.
   No server-side automation. Direct link only.
   ───────────────────────────────────────────── */
export function sendOrderToWhatsApp(order, restaurantPhone = '917003764902') {
  const createdAt = new Date(order.createdAt);
  const dateStr   = createdAt.toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
  const timeStr   = createdAt.toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit', hour12: true });

  const items = (order.items || [])
    .map(item => `  • ${item.quantity}x ${item.name} — Rs.${item.price * item.quantity}`)
    .join('\n');

  // Build message using WhatsApp bold markdown (*text*)
  let msg = '';
  msg += `🍽️ *NEW ORDER — Rita Foodland*\n`;
  msg += `━━━━━━━━━━━━━━━━━━━━\n`;
  msg += `*Order ID:* ${order.id}\n`;
  msg += `*Date:*     ${dateStr}\n`;
  msg += `*Time:*     ${timeStr}\n`;
  msg += `━━━━━━━━━━━━━━━━━━━━\n`;
  msg += `*Customer Details*\n`;
  msg += `*Name:*    ${order.customerName}\n`;
  msg += `*Phone:*   +91 ${order.phone}\n`;
  msg += `*Address:* ${order.address}\n`;
  if (order.landmark) msg += `*Near:*    ${order.landmark}\n`;
  if (order.notes)    msg += `*Notes:*   ${order.notes}\n`;
  msg += `━━━━━━━━━━━━━━━━━━━━\n`;
  msg += `*Order Items*\n`;
  msg += items + '\n';
  msg += `━━━━━━━━━━━━━━━━━━━━\n`;
  msg += `*Subtotal:* Rs.${order.subtotal}\n`;
  msg += `*TOTAL:*    Rs.${order.total}\n`;
  msg += `━━━━━━━━━━━━━━━━━━━━\n`;

  if (order.receiptUrl) {
    msg += `🧾 *Receipt:* ${order.receiptUrl}\n`;
    msg += `━━━━━━━━━━━━━━━━━━━━\n`;
  }

  msg += `_Status: PENDING — Please confirm with customer_`;

  const encoded = encodeURIComponent(msg);
  const url     = `https://wa.me/${restaurantPhone}?text=${encoded}`;
  window.open(url, '_blank', 'noopener,noreferrer');
}
