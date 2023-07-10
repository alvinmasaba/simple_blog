import React from 'react';

const Navbar = (props) => {
  return (
    <nav>
      <ul>
        <li onClick={() => props.onTabChange('teams')}>Teams</li>
        <li onClick={() => props.onTabChange('players')}>Players</li>
        <li onClick={() => props.onTabChange('users')}>Users</li>
        <li onClick={() => props.onTabChange('salarycap')}>Salary Cap</li>
      </ul>
    </nav>
  );
}

export default Navbar;
