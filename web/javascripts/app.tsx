import 'primereact/resources/themes/nova-dark/theme.css';
import 'primereact/resources/primereact.min.css';
import 'primeicons/primeicons.css';
import 'primeflex/primeflex.scss';

import { BrowserRouter, Link, Route, Switch } from 'react-router-dom';
import { IncidentHistoryPage } from './pages/incident-history';
import React from 'react';
import { Card } from 'primereact/card';

enum Routes {
  IncidentHistory = '/incident-history',
  Dashboard = '/'
}

const data = {
  labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
  datasets: [
    {
      label: 'First Dataset',
      data: [65, 59, 80, 81, 56, 55, 40],
      fill: false,
      borderColor: '#4bc0c0'
    },
    {
      label: 'Second Dataset',
      data: [28, 48, 40, 19, 86, 27, 90],
      fill: false,
      borderColor: '#565656'
    }
  ]
};

const DashboardPage = () => (
  <>
    <div style={{ display: 'flex' }}>
      <div className='p-col-4'>
        <Card subTitle="Total time holding deployments">
          <h1 style={{ fontSize: '3em' }}>
            340 minutes
          </h1>
        </Card>
      </div>
      <div className='p-col-8'>
        <Card subTitle="Held deployments over time">
          <h1 style={{ fontSize: '3em' }}>
            A cool graph will go here
          </h1>
        </Card>
      </div>
    </div>
  </>
);

let navListItemStyle = { display: 'inline-block' };
let navItemStyle = {
  padding: '1em',
  border: '1px solid black',
  borderRadius: '10%',
  margin: '0 .5em 0 .5em',
  backgroundColor: 'white',
  fontFamily: 'monospace',
  fontSize: '1.2em'
};
const Navigation = () => (
  <nav>
    <ul>
      <li style={navListItemStyle}>
        <Link style={navItemStyle} to={Routes.Dashboard}>Dashboard</Link>
      </li>
      <li style={navListItemStyle}>
        <Link style={navItemStyle} to={Routes.IncidentHistory}>Incident History</Link>
      </li>
    </ul>
  </nav>
);

export const App = () => (
  <BrowserRouter>
    <Navigation/>

    <div style={{ padding: '2em', marginTop: '2em' }}>
      <Switch>
        <Route exact path={Routes.Dashboard} component={DashboardPage}/>
        <Route path={Routes.IncidentHistory} component={IncidentHistoryPage}/>
      </Switch>
    </div>
  </BrowserRouter>
);
