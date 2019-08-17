import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Main } from './main';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Main/>,
    document.body.appendChild(document.createElement('div')),
  )
});
