/**
 * Order Service — Supabase Persistence
 *
 * Handles saving and fetching orders from the Supabase `orders` table.
 * This is a non-blocking addition to the existing localStorage flow.
 * If Supabase fails, the order still exists in localStorage.
 *
 * Field mapping (local → Supabase):
 *   order.id         → order_number
 *   customerName     → customer_name
 *   phone            → phone
 *   address          → address
 *   landmark         → landmark
 *   notes            → notes
 *   subtotal         → subtotal
 *   total            → total
 *   status           → status
 *   createdAt        → created_at
 */

import { supabase } from '../lib/supabase';

/**
 * Persists an order to the Supabase `orders` table.
 *
 * @param {Object} order — The local order object (same structure stored in localStorage)
 * @returns {Object} — { success: boolean, data?: any, error?: string }
 */
export async function saveOrderToSupabase(order) {
  try {
    // Map local order fields → Supabase column names
    const row = {
      order_number: order.id,
      customer_name: order.customerName,
      phone: order.phone,
      address: order.address,
      landmark: order.landmark || '',
      notes: order.notes || '',
      items: order.items || [],
      subtotal: order.subtotal,
      total: order.total,
      status: order.status,
      created_at: order.createdAt,
    };

    console.log('[OrderService] Saving order to Supabase:', row.order_number);

    const { data, error } = await supabase
      .from('orders')
      .insert([row])
      .select();

    if (error) {
      console.error('[OrderService] Supabase insert error:', error.message);
      return { success: false, error: error.message };
    }

    console.log('[OrderService] Order saved to Supabase successfully:', data);
    return { success: true, data };
  } catch (err) {
    console.error('[OrderService] Unexpected error saving to Supabase:', err);
    return { success: false, error: err.message };
  }
}

/**
 * Fetches a single order from Supabase by its order_number.
 * Used by the public receipt page (/receipt/:orderId).
 *
 * @param {string} orderNumber — e.g. "ORD-20260611-0002"
 * @returns {Object} — { success: boolean, order?: Object, error?: string }
 */
export async function fetchOrderByNumber(orderNumber) {
  try {
    console.log('[OrderService] Fetching order from Supabase:', orderNumber);

    const { data, error } = await supabase
      .from('orders')
      .select('*')
      .eq('order_number', orderNumber)
      .order('created_at', { ascending: false })
      .limit(1);

    if (error) {
      console.error('[OrderService] Supabase fetch error:', error.message);
      return { success: false, error: error.message };
    }

    if (!data || data.length === 0) {
      return { success: false, error: 'Order not found' };
    }

    // Map Supabase columns back to the local order shape
    // so receipt utilities can consume it directly
    const row = data[0];
    const order = {
      id: row.order_number,
      customerName: row.customer_name,
      phone: row.phone,
      address: row.address,
      landmark: row.landmark || '',
      notes: row.notes || '',
      items: row.items || [],
      subtotal: Number(row.subtotal),
      total: Number(row.total),
      status: row.status,
      createdAt: row.created_at,
    };

    console.log('[OrderService] Order fetched successfully:', order.id);
    return { success: true, order };
  } catch (err) {
    console.error('[OrderService] Unexpected error fetching order:', err);
    return { success: false, error: err.message };
  }
}

