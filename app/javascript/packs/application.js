import React from 'react';
import ReactDOM from 'react-dom';
import AdminDashboard from '../src/components/AdminDashboard';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <AdminDashboard />,
    document.getElementById('admin-dashboard'),
  );
});
