import React from 'react';
import '../Table.css';
import Table from '../Table'
import { TEAM_COLUMNS } from '../columns';

const TeamsView = ({ teams }) => {
  return (
    <Table data={teams} columns={TEAM_COLUMNS} />
  );
};

export default TeamsView;