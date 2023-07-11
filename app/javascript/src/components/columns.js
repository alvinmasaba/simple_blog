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
      accessor: d => d.team ? d.team.name : 'No Team',
      Cell: ({ cell: { value, row: { original: { team } } } }) => (
        team ? 
        <a href={`/admin/teams/${team.id}`}>
          {titleize(value)}
        </a> : 
        value
      ),
      sortType: 'teamName',
    },
  ];

export const CAP_COLUMNS = [
    {
      Header: 'Year',
      accessor: 'year'
    },

    {
      Header: 'Salary Cap',
      accessor: 'salary_cap'
    },

    {
      Header: 'Luxury Tax',
      accessor: 'luxury_tax'
    },
    
    {
      Header: 'Apron',
      accessor: 'apron'
    },

    {
      Header: 'Second Apron',
      accessor: 'second_apron'
    },

    {
      Header: 'Minimum Payroll',
      accessor: 'min_payroll'
    },

    {
      Header: 'Non-Taxpayer MLE',
      accessor: 'nontaxpayermle'
    },

    {
      Header: 'Taxpayer MLE',
      accessor: 'taxpayermle'
    },

    {
      Header: 'Room MLE',
      accessor: 'roommle'
    },

    {
      Header: 'Bi-Annual Exception',
      accessor: 'bae'
    },

    {
      Header: 'Cap Hold',
      accessor: 'cap_hold'
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