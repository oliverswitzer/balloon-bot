import { useQuery } from 'react-query';
import { fetchLifetimeStats } from './api/fetch-lifetime-stats';
import { StatsCard } from '../../shared-components/stats-card';
import { ProgressSpinner } from 'primereact/progressspinner';
import * as moment from 'moment';
import React from 'react';

export const LifetimeAverageIncidentDuration = () => {
  const {
    data,
    isLoading
  } = useQuery<any, {}>('/incidents/lifetime_stats.json', fetchLifetimeStats);

  return (
    <StatsCard title="Average incident duration">
      {
        (isLoading || !data) ?
          (
            <ProgressSpinner/>
          ) : (
            <h3 style={{ fontSize: '2em' }}>
              {moment.duration(data.averageDuration).format('h [hour], m [minute]')}
            </h3>
          )
      }
    </StatsCard>
  )
};