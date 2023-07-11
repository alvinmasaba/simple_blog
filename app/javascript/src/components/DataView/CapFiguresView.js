import React from 'react';
import '../Table.css';
import Table from '../Table'
import { CAP_COLUMNS } from '../columns';

const CapFiguresView = ({ figures }) => {
  return (
    <Table data={figures} columns={CAP_COLUMNS} />
  );
};

export default CapFiguresView;