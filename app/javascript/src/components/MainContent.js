import React from 'react';
import TeamsView from './DataView/TeamsView';
import PlayersView from './DataView/PlayersView';
import UsersView from './DataView/UsersView';
import SalaryCapView from './DataView/SalaryCapView';

const MainContent = (props) => {
  switch (props.selectedTab) {
    case 'teams':
      return <TeamsView />;
    case 'players':
      return <PlayersView />;
    case 'users':
      return <UsersView />;
    case 'salarycap':
      return <SalaryCapView />;
    default:
      return <TeamsView />;
  }
}

export default MainContent;
