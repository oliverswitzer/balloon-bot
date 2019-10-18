import * as React from 'react';
import * as moment from 'moment';
import * as _ from 'lodash';
import { IncidentData } from './types';

export const IncidentRow = ({incidentData}: { incidentData: IncidentData }) => {
  const { incident, terms } = incidentData;
  const createdAt = moment(incident.createdAt);
  const resolvedAt = moment(incident.resolvedAt);
  const duration = moment.duration(resolvedAt.diff(createdAt));

  return (
    <div style={{ minHeight: '10rem'}}>
      <p><span style={{fontWeight: 'bold'}}>Happened:</span> {createdAt.fromNow()}</p>
      <p><span style={{fontWeight: 'bold'}}>Duration:</span> {duration.humanize()}</p>
      <p><span style={{fontWeight: 'bold'}}>Initial message:</span>{_.truncate(incident.messages[0].text, { length: 150 })}</p>
      { incidentData.terms.length > 0 &&
        <p><span style={{fontWeight: 'bold'}}>Top terms for incident:</span> {terms.join(", ")}</p>
      }
      <br/>
    </div>
  )
};
