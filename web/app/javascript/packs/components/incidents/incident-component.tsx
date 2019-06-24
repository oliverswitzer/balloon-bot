import * as React from 'react';
import * as moment from 'moment';
import { Incident } from './types';

export const IncidentComponent = ({incident}: { incident: Incident }) => {
  const createdAt = moment(incident.createdAt);
  const resolvedAt = moment(incident.resolvedAt);
  const duration = moment.duration(resolvedAt.diff(createdAt));

  return (
    <div style={{ border: '1px solid black', textAlign: 'center', paddingLeft: '10vw', paddingRight: '10vw', margin: '5vh auto', width: '50vw' }}>
      <p><span style={{fontWeight: 'bold'}}>Happened:</span> {createdAt.fromNow()}</p>
      <p><span style={{fontWeight: 'bold'}}>Duration:</span> {duration.humanize()}</p>
      <p><span style={{fontWeight: 'bold'}}>Initial message:</span> {incident.messages[0].text}</p>
      <br/>
    </div>
  )
};
