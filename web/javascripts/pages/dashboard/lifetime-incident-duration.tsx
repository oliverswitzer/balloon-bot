import React from 'react';
import { useFetch } from '../../hooks/use-fetch';
import * as moment from 'moment';
import { ProgressSpinner } from 'primereact/progressspinner';
import { StatsCard } from '../../shared-components/stats-card';

export const LifetimeIncidentDuration = () => {
  const {
    data: durationInMilliseconds,
    isLoading
  } = useFetch<number>('/incidents/all_time_duration.json', (response) => response.allTimeDuration);

  return (
    <StatsCard title="Lifetime incident duration">
      {
        isLoading ?
          (
            <ProgressSpinner />
          ):
          <h3 style={{fontSize: '2em'}}>
            {moment.duration(durationInMilliseconds).humanize()}
          </h3>
      }
    </StatsCard>
  )
};