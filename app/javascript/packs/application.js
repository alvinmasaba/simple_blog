import React from 'react';
import ReactDOM from 'react-dom';
import Dashboard from '../src/components/Dashboard';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Dashboard />,
    document.getElementById('dashboard'),
  );
});
