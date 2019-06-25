import * as React from 'react';
import { useFetch } from '../../hooks/use-fetch';
import { Incident } from './types';
import { IncidentComponent } from './incident-component';

function mapToIncidents(res: any): Incident[] {
  return res;
}

function isResolved(incident: Incident): boolean {
  return incident.resolvedAt !== null;
}

export const Main = () => {
  const [incidents, isLoading] = useFetch<Incident[]>(
    '/incidents.json',
    [],
    mapToIncidents
  );

  return (
    <div>
      <h1 style={{ textAlign: 'center', marginBottom: '5vh', marginTop: '5vh' }}>Resolved Incidents</h1>
      {isLoading && <h1>Loading incidents!</h1>}

      {
        incidents.filter(isResolved).map(incident => (
          <IncidentComponent incident={incident}/>
        ))
      }
    </div>
  )
};
