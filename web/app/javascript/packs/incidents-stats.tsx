import { Main } from './components/incidents/main';
import * as React from 'react';
import * as ReactDOM from 'react-dom';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Main/>,
    document.body.appendChild(document.createElement('div')),
  )
});
