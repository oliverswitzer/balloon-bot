import 'primereact/resources/themes/nova-dark/theme.css';
import 'primereact/resources/primereact.min.css';
import 'primeicons/primeicons.css';
import 'primeflex/primeflex.scss';

import * as React from 'react';
import { useEffect, useState } from 'react';
import { useFetch } from '../hooks/use-fetch';
import { IncidentData } from './types';
import { IncidentRow } from './incident-row';
import { DataView, DataViewLayoutOptions } from 'primereact/dataview';
import { ProgressSpinner } from 'primereact/progressspinner';
import { DateRangeInput } from '../shared-components/date-range-input/component';
import { DateRange } from '../shared-components/date-range-input/types';
import { Panel } from 'primereact/panel';
import * as moment from 'moment';
import { Bold } from '../shared-components/bold';

function mapToIncidents(res: any): IncidentData[] {
  return res;
}

const incidentTemplate = (incidentData: IncidentData, layout: string) => (
  <>
    {
      layout === 'grid' ? (
        <div style={{ padding: '.5rem', width: '33.33%' }}>
          <Panel header={incidentData.incident.id}>
            <IncidentRow incidentData={incidentData}/>
          </Panel>
        </div>
      ) : (
        <div>
          🎈 <Bold>Happened at:</Bold> {moment(incidentData.incident.createdAt).format('lll')}
          &nbsp;&nbsp;🎈 <Bold>Resolved at:</Bold> {moment(incidentData.incident.resolvedAt).format('lll')}
          &nbsp;&nbsp;🎈 <Bold>First message:</Bold> {incidentData.incident.messages[0].text }
          { incidentData.terms.length > 0 && (
            <>&nbsp;&nbsp;🎈 <Bold>Terms:</Bold> {incidentData.terms.join(', ')}</>
          )}
        </div>
      )
    }
  </>
);

function isResolved(incidentData: IncidentData): boolean {
  return incidentData.incident.resolvedAt !== null;
}

export const Main = () => {
  const {
    data: incidents,
    isLoading,
    fetchMore: fetchMoreIncidents
  } = useFetch<IncidentData[]>('/incidents.json', mapToIncidents);

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
