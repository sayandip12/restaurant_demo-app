import { createContext, useContext, useReducer, useEffect, useCallback, useMemo } from 'react';

const CartContext = createContext(null);

// Phase 1: Fees disabled — set to 0. Keep variables for future compatibility.
const DELIVERY_FEE = 0;
const GST_RATE = 0;

// Load from localStorage
const loadCart = () => {
  try {
    const saved = localStorage.getItem('rita-cart');
    return saved ? JSON.parse(saved) : [];
  } catch {
    return [];
  }
};

const cartReducer = (state, action) => {
  switch (action.type) {
    case 'ADD_ITEM': {
      const existing = state.find(i => i.id === action.item.id);
      if (existing) {
        return state.map(i =>
          i.id === action.item.id
            ? { ...i, quantity: i.quantity + (action.quantity || 1) }
            : i
        );
      }
      return [...state, { ...action.item, quantity: action.quantity || 1 }];
    }
    case 'REMOVE_ITEM':
      return state.filter(i => i.id !== action.id);
    case 'UPDATE_QUANTITY': {
      if (action.quantity <= 0) {
        return state.filter(i => i.id !== action.id);
      }
      return state.map(i =>
        i.id === action.id ? { ...i, quantity: action.quantity } : i
      );
    }
    case 'CLEAR':
      return [];
    default:
      return state;
  }
};

export const CartProvider = ({ children }) => {
  const [items, dispatch] = useReducer(cartReducer, null, loadCart);

  // Persist to localStorage
  useEffect(() => {
    localStorage.setItem('rita-cart', JSON.stringify(items));
  }, [items]);

  const addItem = useCallback((item, quantity = 1) => {
    dispatch({ type: 'ADD_ITEM', item, quantity });
  }, []);

  const removeItem = useCallback((id) => {
    dispatch({ type: 'REMOVE_ITEM', id });
  }, []);

  const updateQuantity = useCallback((id, quantity) => {
    dispatch({ type: 'UPDATE_QUANTITY', id, quantity });
  }, []);

  const clearCart = useCallback(() => {
    dispatch({ type: 'CLEAR' });
  }, []);

  const getItemQuantity = useCallback((id) => {
    const item = items.find(i => i.id === id);
    return item ? item.quantity : 0;
  }, [items]);

  const totals = useMemo(() => {
    const subtotal = items.reduce((sum, i) => sum + i.price * i.quantity, 0);
    const deliveryFee = items.length > 0 ? DELIVERY_FEE : 0;
    const gst = Math.round(subtotal * GST_RATE);
    const grandTotal = subtotal + deliveryFee + gst;
    const totalItems = items.reduce((sum, i) => sum + i.quantity, 0);
    return { subtotal, deliveryFee, gst, grandTotal, totalItems };
  }, [items]);

  const value = useMemo(() => ({
    items,
    ...totals,
    addItem,
    removeItem,
    updateQuantity,
    clearCart,
    getItemQuantity,
  }), [items, totals, addItem, removeItem, updateQuantity, clearCart, getItemQuantity]);

  return (
    <CartContext.Provider value={value}>
      {children}
    </CartContext.Provider>
  );
};

export const useCart = () => {
  const context = useContext(CartContext);
  if (!context) throw new Error('useCart must be used within CartProvider');
  return context;
};

export default CartContext;
