import React from 'react';
import '../Table.css';
import Table from '../Table'
import { PLAYER_COLUMNS } from '../columns';

const PlayersView = ({ players }) => {
  return (
    <Table data={players} columns={PLAYER_COLUMNS} />
  );
};

export default PlayersView;