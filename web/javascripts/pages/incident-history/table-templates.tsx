import { Incident, IncidentData } from './types';
import { Bold } from '../../shared-components/bold';
import * as moment from 'moment';
import * as _ from 'lodash';
import * as React from 'react';
import { computeDuration } from './helpers/time-helpers';
import { Panel } from 'primereact/panel';
import { useState } from 'react';
import { Dialog } from 'primereact/dialog';
import { MessageFeed } from './message-feed';

enum TimeSeverity {
  SHORT = 'SHORT',
  MEDIUM = 'MEDIUM',
  LONG = 'LONG'
}

function calculateSeverity(incident: Incident): TimeSeverity {
  let incidentDuration = computeDuration(incident.createdAt, incident.resolvedAt);

  if (incidentDuration.asMinutes() <= 15)
    return TimeSeverity.SHORT;
  else if (incidentDuration.asHours() <= 4)
    return TimeSeverity.MEDIUM;
  else
    return TimeSeverity.LONG;
}

const balloonIconMapping: { [severity in TimeSeverity]: string } = {
  SHORT: '/balloons-green.svg',
  MEDIUM: '/balloons-orange.svg',
  LONG: '/balloons-red.svg'
};
const severityText: { [severity in TimeSeverity]: string } = {
  SHORT: 'Mild time impact',
  MEDIUM: 'Medium time impact',
  LONG: 'Severe time impact'
};

export const ListViewTemplate = ({ incidentData }: { incidentData: IncidentData; }) => {
  const { incident, terms } = incidentData;
  const incidentSeverity = calculateSeverity(incident);

  return <div>
    <div className="p-col-12">
      <div style={{
        display: 'flex',
        justifyContent: 'left',
        alignItems: 'center',
        padding: '2em',
        borderBottom: '1px solid #d9dad9'
      }}>
        <img src={balloonIconMapping[incidentSeverity]}/>
        <div style={{ paddingLeft: '2em' }} className="p-grid">
          <div className="p-col-12"><Bold><>Incident # {incident.id} — {severityText[incidentSeverity]}</>
          </Bold></div>
          <div className="p-col-12"><Bold>Happened at:</Bold> {moment(incident.createdAt).format('lll')}</div>
          <div className="p-col-12"><Bold>Resolved at:</Bold> {moment(incident.resolvedAt).format('lll')}</div>
          <div className="p-col-12"><Bold>First message:</Bold> {incident.messages[0].text}</div>
          {terms.length > 0 &&
          <div className="p-col-12"><Bold>Terms:</Bold> {terms.join(', ')}</div>
          }
        </div>
      </div>
    </div>
  </div>;
};

export const GridViewTemplate = ({ incidentData }: { incidentData: IncidentData }) => {
  const { incident, terms } = incidentData;
  const incidentSeverity = calculateSeverity(incident);

  const [showDialog, setShowDialog] = useState(false);

  return (
    <div className="p-col-12 p-sm-6 p-md-4">
      <Panel header={`Incident # ${incidentData.incident.id} — ${severityText[incidentSeverity]}`}>
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          alignItems: 'center',
          padding: '2em'
        }}>
          <img
            onClick={() => setShowDialog(true)}
            style={{ width: '35%', cursor: 'pointer' }}
            src={balloonIconMapping[incidentSeverity]}
          />
          <div style={{ minHeight: '10rem' }}>
            <p><Bold>Happened:</Bold> {moment(incident.createdAt).fromNow()}</p>
            <p><Bold>Duration:</Bold> {computeDuration(incident.createdAt, incident.resolvedAt).humanize()}</p>
            <p><Bold>Initial message:</Bold>{_.truncate(incident.messages[0].text, { length: 150 })}</p>
            {terms.length > 0 &&
              <p><Bold>Top terms for incident:</Bold> {terms.join(', ')}</p>
            }
            <br/>
          </div>
        </div>
      </Panel>

      <Dialog header="Message history" visible={showDialog} onHide={() => setShowDialog(false)}>
        {showDialog && <MessageFeed incident={incident}/>}
      </Dialog>
    </div>
  )
};
