// app/javascript/packs/AdminDashboard.js
import React from 'react';
import ReactDOM from 'react-dom';
import AdminDashboard from '../src/components/AdminDashboard'

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('admin-dashboard');
  ReactDOM.render(<AdminDashboard />, container);
});


