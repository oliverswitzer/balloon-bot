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

function mapToIncidents(res: any): Incident[] {
  return res;
}

const incidentTemplate = (incident: Incident, layout: string) => (
  <div className="p-grid">
    <div className="p-col-12">
      <IncidentRow incident={incident}/>
    </div>
  </div>
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
              <DataViewLayoutOptions onChange={() => {
              }}/>
              <DataView value={incidents.filter(isResolved)} layout="list" itemTemplate={incidentTemplate}/>
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
