import React, { useEffect, useState } from 'react';

const AdminDashboard = () => {
  const [teams, setTeams] = useState([]);
  const [players, setPlayers] = useState([]);
  const [users, setUsers] = useState([]);
  const [capFigures, setCapFigures] = useState([]);

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
      {/* Here is where you'd use teams, players, and users to render your dashboard */}
    </div>
  );
};

export default AdminDashboard;
