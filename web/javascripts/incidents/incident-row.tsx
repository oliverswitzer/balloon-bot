import * as React from 'react';
import * as moment from 'moment';
import * as _ from 'lodash';
import { Incident } from './types';

export const IncidentRow = ({incident}: { incident: Incident }) => {
  const createdAt = moment(incident.createdAt);
  const resolvedAt = moment(incident.resolvedAt);
  const duration = moment.duration(resolvedAt.diff(createdAt));

  return (
    <div style={{ height: '10rem'}}>
      <p><span style={{fontWeight: 'bold'}}>Happened:</span> {createdAt.fromNow()}</p>
      <p><span style={{fontWeight: 'bold'}}>Duration:</span> {duration.humanize()}</p>
      <p><span style={{fontWeight: 'bold'}}>Initial message:</span>{_.truncate(incident.messages[0].text, { length: 150 })}</p>
      <br/>
    </div>
  )
};
