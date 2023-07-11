import React from 'react';
import TeamsView from './DataView/TeamsView';
import PlayersView from './DataView/PlayersView';
import UsersView from './DataView/UsersView';
import CapFiguresView from './DataView/CapFiguresView';

const MainContent = ({ selectedTab, teams, players, users, capFigures }) => {
    switch (selectedTab) {
      case 'teams':
        return <TeamsView teams={teams} />;
      case 'players':
        return <PlayersView players={players} />;
      case 'users':
        return <UsersView users={users} />;
      case 'capFigures':
        return <CapFiguresView figures={capFigures} />;
      default:
        return null;
    }
  };


export default MainContent;
