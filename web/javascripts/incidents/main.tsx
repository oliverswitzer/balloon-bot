import * as React from 'react';
import { useFetch } from '../hooks/use-fetch';
import { Incident } from './types';
import { IncidentRow } from './incident-row';
import { useEffect, useState } from 'react';
import * as queryString from 'querystring';

function mapToIncidents(res: any): Incident[] {
  return res;
}

function isResolved(incident: Incident): boolean {
  return incident.resolvedAt !== null;
}

interface DateRangeState {
  created_after?: string;
  created_before?: string;
}

export const Main = () => {
  const {
    data: incidents,
    isLoading,
    fetchMore: fetchMoreIncidents
  } = useFetch<Incident[]>('/incidents.json', mapToIncidents);

  const [dateRange, setDateRange] = useState<DateRangeState>({});

  useEffect(() => {
    fetchMoreIncidents(`/incidents?${formattedDateParams(dateRange)}`)
  }, [dateRange]);

  return (
    <div>
      <label>
        Happened after:
        <input
          type="date"
          value={dateRange.created_after || ''}
          onChange={e => { console.log(e.target.value); setDateRange({
            created_after: e.target.value,
            created_before: dateRange.created_before
          })}}
        />
      </label>
      <label>
        Happened before:
        <input
          type="date"
          value={dateRange.created_before || ''}
          onChange={e => setDateRange({
            created_after: dateRange.created_after,
            created_before: e.target.value
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
  const paramsInEpoch = {
    created_after: new Date(dateRange.created_after).getTime(),
    created_before: new Date(dateRange.created_before).getTime(),
  };

  return queryString.stringify(paramsInEpoch as queryString.ParsedUrlQueryInput);
}
