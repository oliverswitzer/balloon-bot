import * as React from 'react';
import * as moment from 'moment';
import { Incident } from './types';

export const IncidentComponent = ({incident}: { incident: Incident }) => {
  const createdAt = moment(incident.createdAt);
  const resolvedAt = moment(incident.resolvedAt);
  const duration = moment.duration(resolvedAt.diff(createdAt));

  return (
    <>
      <p>Happened: {createdAt.fromNow()}</p>
      <p>Duration: {duration.humanize()}</p>
      <p>Initial message: {incident.messages[0].text}</p>
      <br/>
    </>
  )
};
