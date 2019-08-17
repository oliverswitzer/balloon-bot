import * as React from 'react';
import { getJson, useFetch } from '../hooks/use-fetch';
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
  happenedAfter?: string;
  happenedBefore?: string;
}

export const Main = () => {
  const [incidents, isLoading, fetchMore] = useFetch<Incident[]>(
    '/incidents.json',
    [],
    mapToIncidents
  );
  const [data, setData] = useState<Incident[]>([]);
  const [loading, setLoading] = useState(true);
  const [dateRange, setDateRange] = useState<DateRangeState>({});
  const [url, setUrl] = useState('/incidents.json');

  async function fetchUrl(url: string) {
    const response = await getJson(url);
    setData(mapToIncidents(response));
    setLoading(false);
  }

  useEffect(() => {
    console.log('yo');
    fetchUrl('/incidents')
  }, [dateRange]);

  return (
    <div>
      <label>
        Happened after:
        <input
          type="date"
          value={dateRange.happenedAfter || ''}
          onChange={e => { console.log(e.target.value); setDateRange({
            happenedAfter: e.target.value,
            happenedBefore: dateRange.happenedBefore
          })}}
        />
      </label>
      <label>
        Happened before:
        <input
          type="date"
          value={dateRange.happenedBefore || ''}
          onChange={e => setDateRange({
            happenedAfter: dateRange.happenedAfter,
            happenedBefore: e.target.value
          })}
        />
      </label>

      <h1 style={{ textAlign: 'center', marginBottom: '5vh', marginTop: '5vh' }}>Resolved Incidents</h1>
      {isLoading && <h1>Loading incidents!</h1>}

      {
        incidents.filter(isResolved).map(incident => (
          <IncidentRow incident={incident}/>
        ))
      }
    </div>
  )
};
