import React, { useEffect, useState } from 'react';
import MainContent from './MainContent';
import './Table.css'

const AdminDashboard = () => {
  const [teams, setTeams] = useState([]);
  const [players, setPlayers] = useState([]);
  const [users, setUsers] = useState([]);
  const [capFigures, setCapFigures] = useState([]);
  const [selectedTab, setSelectedTab] = useState('teams');

  useEffect(() => {
    fetch('/admin/teams.json')
      .then(response => response.json())
      .then(data => setTeams(data));

    fetch('/admin/players.json')
      .then(response => response.json())
      .then(data => setPlayers(data));

    fetch('/admin/users.json')
      .then(response => response.json())
      .then(data => setUsers(data));

    fetch('/admin/cap_figures.json')
      .then(response => response.json())
      .then(data => setCapFigures(data));
  }, []);

  return (
    <div>
      <h1>Admin Dashboard</h1>
      <div style={{display: 'flex', flexDirection: 'column', alignItems: 'stretch'}}>
        <div style={{display: 'flex', justifyContent: 'center'}}>
          <button onClick={() => setSelectedTab('teams')}>Teams</button>
          <button onClick={() => setSelectedTab('players')}>Players</button>
          <button onClick={() => setSelectedTab('users')}>Users</button>
          <button onClick={() => setSelectedTab('capFigures')}>Cap Figures</button>
        </div>

        <MainContent 
          selectedTab={selectedTab} 
          teams={teams} 
          players={players} 
          users={users} 
          capFigures={capFigures}
        />
      </div>
    </div>
  );
};

export default AdminDashboard;
