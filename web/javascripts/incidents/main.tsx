import 'primereact/resources/themes/nova-dark/theme.css';
import 'primereact/resources/primereact.min.css';
import 'primeicons/primeicons.css';
import 'primeflex/primeflex.scss';

import * as React from 'react';
import { useFetch } from '../hooks/use-fetch';
import { Incident } from './types';
import { IncidentRow } from './incident-row';
import { DataView, DataViewLayoutOptions } from 'primereact/dataview';
import { ProgressSpinner } from 'primereact/progressspinner';
import { useEffect, useState } from 'react';
import { DateRangeInput } from "../shared-components/date-range-input/component";
import { DateRange } from "../shared-components/date-range-input/types";
import { Panel } from 'primereact/panel';
import * as moment from 'moment';

function mapToIncidents(res: any): Incident[] {
  return res;
}

const incidentTemplate = (incident: Incident, layout: string) => (
  <>
    {
      layout === 'grid' ? (
        <div style={{ padding: '.5rem', width: '33.33%' }}>
          <Panel header={incident.id}>
            <IncidentRow incident={incident}/>
          </Panel>
        </div>
      ) : (
        <div>
          Happened at: {moment(incident.createdAt).format('lll')}
          Resolved at: {moment(incident.resolvedAt).format('lll')}
          First message: {incident.messages[0].text }
        </div>
      )
    }
  </>
);

function isResolved(incident: Incident): boolean {
  return incident.resolvedAt !== null;
}

export const Main = () => {
  const {
    data: incidents,
    isLoading,
    fetchMore: fetchMoreIncidents
  } = useFetch<Incident[]>('/incidents.json', mapToIncidents);

  const [layout, setLayout] = useState<string>('grid');
  const [dateRange, setDateRange] = useState<DateRange>({});

  useEffect(() => {
    fetchMoreIncidents(formattedDateParams(dateRange))
  }, [dateRange]);

  return (
    <div>
      <h1 style={{ textAlign: 'center', marginBottom: '5vh', marginTop: '5vh' }}>Resolved Incidents</h1>
      <DateRangeInput
        dateRange={dateRange}
        onSelectDate={dates => setDateRange(dates)}
        labels={{
          afterLabel: 'Happened after',
          beforeLabel: 'Happened before'
        }}
      />

      {
        isLoading ?
          <ProgressSpinner/> :
          (
            <>

              <DataView
                value={incidents.filter(isResolved)}
                header={<DataViewLayoutOptions onChange={(e) => setLayout(e.value)}/>}
                layout={layout}
                itemTemplate={incidentTemplate}
              />
            </>
          )
      }
    </div>
  )
};

function formattedDateParams(dateRange: DateRange) {
  return {
    created_after: dateRange.after ? dateRange.after.getTime() : '',
    created_before: dateRange.before ? dateRange.before.getTime() : ''
  };
}
