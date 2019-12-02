import 'primereact/resources/themes/nova-dark/theme.css';
import 'primereact/resources/primereact.min.css';
import 'primeicons/primeicons.css';
import 'primeflex/primeflex.scss';

import { HashRouter, Link, Route, Switch } from 'react-router-dom';
import { IncidentHistoryPage } from './pages/incident-history';
import React from 'react';
import { DashboardPage } from './pages/dashboard';

enum Routes {
  IncidentHistory = '/incident-history',
  Dashboard = '/'
}

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
  <HashRouter>
    <Navigation/>

    <div style={{ padding: '2em', marginTop: '2em' }}>
      <Switch>
        <Route exact path={Routes.Dashboard} component={DashboardPage}/>
        <Route path={Routes.IncidentHistory} component={IncidentHistoryPage}/>
      </Switch>
    </div>
  </HashRouter>
);
