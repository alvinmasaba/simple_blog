import React from 'react';

export const TEAM_COLUMNS = [
    {
      Header: 'Team',
      accessor: 'id',
      Cell: ({ cell: { row: { original } } }) => {
        const { name, id } = original;
        return (
          <a href={`/admin/teams/${id}`}>
            { `${titleize(name)}`}
          </a>
        );
      }
    },
    // add more column configurations here...
  ];

export const PLAYER_COLUMNS = [
    {
      Header: 'Name',
      accessor: d => `${d.first_name} ${d.last_name}`, // this is just used to uniquely identify each row
      Cell: ({ cell: { value, row: { original: { id } } } }) => (
        <a href={`/admin/players/${id}`}>
          {titleize(value)}
        </a>
      ),
      sortType: 'lastName', // This will sort alphabetically
    },

    {
      Header: 'Team',
      accessor: d => `${d.first_name}`
    },
  ];

export const CAP_COLUMNS = [
    {
      Header: 'salary Cap',
      accessor: 'salary_cap'
    },

    {
      Header: 'Luxury Tax',
      accessor: 'luxury_tax'
    },  
    // add more column configurations here...
  ];

export const USER_COLUMNS = [
    {
      Header: 'Username',
      accessor: 'username'
    },

    {
      Header: 'Email',
      accessor: 'email'
    },

    // add more column configurations here...
  ];


const titleize = (str) => {
  return str
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
};