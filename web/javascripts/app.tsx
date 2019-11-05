import { BrowserRouter, Link, Route, Switch } from 'react-router-dom';
import { IncidentHistoryPage } from './pages/incident-history';
import React from 'react';

enum Routes {
  IncidentHistory = '/incident-history',
  Home = '/'
}

const HomePage = () => (
  <>
    <h1>You home, yo</h1>
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
        <Link style={navItemStyle} to={Routes.Home}>Home</Link>
      </li>
      <li style={navListItemStyle}>
        <Link style={navItemStyle} to={Routes.IncidentHistory}>Incident History</Link>
      </li>
    </ul>
  </nav>
);

export const App = () => (
  <BrowserRouter>
    <Navigation />

    <div style={{ padding: '2em', marginTop: '2em' }}>
      <Switch>
        <Route exact path={Routes.Home} component={HomePage}/>
        <Route path={Routes.IncidentHistory} component={IncidentHistoryPage}/>
      </Switch>
    </div>
  </BrowserRouter>
);
