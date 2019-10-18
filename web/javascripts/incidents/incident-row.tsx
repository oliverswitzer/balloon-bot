import * as React from 'react';
import * as moment from 'moment';
import * as _ from 'lodash';
import { IncidentData } from './types';
import { Bold } from '../shared-components/bold';

export const IncidentRow = ({incidentData}: { incidentData: IncidentData }) => {
  const { incident, terms } = incidentData;
  const createdAt = moment(incident.createdAt);
  const resolvedAt = moment(incident.resolvedAt);
  const duration = moment.duration(resolvedAt.diff(createdAt));

  return (
    <div style={{ minHeight: '10rem'}}>
      <p><Bold>Happened:</Bold> {createdAt.fromNow()}</p>
      <p><Bold>Duration:</Bold> {duration.humanize()}</p>
      <p><Bold>Initial message:</Bold>{_.truncate(incident.messages[0].text, { length: 150 })}</p>
      { incidentData.terms.length > 0 &&
        <p><Bold>Top terms for incident:</Bold> {terms.join(", ")}</p>
      }
      <br/>
    </div>
  )
};
