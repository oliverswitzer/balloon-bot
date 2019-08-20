import * as React from 'react';
import { useFetch } from '../hooks/use-fetch';
import { Incident } from './types';
import { IncidentRow } from './incident-row';
import { useEffect, useState } from 'react';

function mapToIncidents(res: any): Incident[] {
  return res;
}

function isResolved(incident: Incident): boolean {
  return incident.resolvedAt !== null;
}

interface DateRangeState {
  createdAfter?: string;
  createdBefore?: string;
}

export const Main = () => {
  const {
    data: incidents,
    isLoading,
    fetchMore: fetchMoreIncidents
  } = useFetch<Incident[]>('/incidents.json', mapToIncidents);

  const [dateRange, setDateRange] = useState<DateRangeState>({});

  useEffect(() => {
    fetchMoreIncidents(formattedDateParams(dateRange))
  }, [dateRange]);

  return (
    <div>
      <label>
        Happened after:
        <input
          type="date"
          value={dateRange.createdAfter || ''}
          onChange={e => { console.log(e.target.value); setDateRange({
            createdAfter: e.target.value,
            createdBefore: dateRange.createdBefore
          })}}
        />
      </label>
      <label>
        Happened before:
        <input
          type="date"
          value={dateRange.createdBefore || ''}
          onChange={e => setDateRange({
            createdAfter: dateRange.createdAfter,
            createdBefore: e.target.value
          })}
        />
      </label>

      <h1 style={{ textAlign: 'center', marginBottom: '5vh', marginTop: '5vh' }}>Resolved Incidents</h1>
      {
        isLoading ?
          <h1>Loading incidents!</h1> :
          (
            incidents.filter(isResolved).map(incident => (
              <IncidentRow incident={incident}/>
            ))
          )
      }
    </div>
  )
};

function formattedDateParams(dateRange: DateRangeState) {
  return {
    created_after: new Date(dateRange.createdAfter).getTime(),
    created_before: new Date(dateRange.createdBefore).getTime(),
  };
}
