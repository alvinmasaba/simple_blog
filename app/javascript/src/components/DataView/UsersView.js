import React from 'react';
import '../Table.css';
import Table from '../Table'
import { USER_COLUMNS } from '../columns';

const UsersView = ({ users }) => {
  return (
    <Table data={users} columns={USER_COLUMNS} />
  );
};

export default UsersView;