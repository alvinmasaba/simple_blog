import React, { useMemo, useEffect } from "react";
import { useTable, useSortBy } from "react-table";
import './Table.css'

const Table = ({ data, columns }) => {
  const tableInstance = useTable({
    columns,
    data,
  })

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    rows,
    prepareRow,
  } = useTable(
    {
        columns,
        data,
        initialState: {
          sortBy: [
            {
              id: 'name', // This should match the id of the name column
              desc: false,
            },
          ],
        },
        defaultColumn: { width: 150 },
        sortTypes: {
          lastName: (row1, row2) => {
            const name1 = row1.original.last_name.toLowerCase();
            const name2 = row2.original.last_name.toLowerCase();
            return name1 > name2 ? 1 : -1;
          },

          teamName: (row1, row2) => {
            const name1 = row1.original.name.toLowerCase();
            const name2 = row2.original.name.toLowerCase();
            return name1 > name2 ? 1 : -1;
          }
        },
      },
      useSortBy
  );

  return (
    <div style={{marginTop: "150px"}}>
      <table {...getTableProps()} className="styled-table">
        <thead>
          {headerGroups.map((headerGroup) => (
            <tr {...headerGroup.getHeaderGroupProps()}>
              {headerGroup.headers.map(column => (
                <th {...column.getHeaderProps(column.getSortByToggleProps())}>
                  {column.render('Header')}
                  <span>
                    {column.isSorted
                      ? column.isSortedDesc
                        ? ' 🔽'
                        : ' 🔼'
                      : ''}
                  </span>
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody {...getTableBodyProps()}>
          {rows.map(row => {
            prepareRow(row)
            return (
              <tr {...row.getRowProps()}>
                {row.cells.map((cell) => {
                  return <td {...cell.getCellProps()}>{cell.render('Cell')}</td>
                })}
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
};

export default Table;
