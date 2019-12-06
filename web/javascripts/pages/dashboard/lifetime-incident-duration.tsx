import React from 'react';
import * as moment from 'moment';
import { ProgressSpinner } from 'primereact/progressspinner';
import { StatsCard } from '../../shared-components/stats-card';
import momentDurationFormatSetup from 'moment-duration-format';
import { useQuery } from 'react-query';
import { fetchLifetimeStats } from './api/fetch-lifetime-stats';

momentDurationFormatSetup(moment);

export const LifetimeIncidentDuration = () => {
  const {
    data,
    isLoading
  } = useQuery<any, {}>('/incidents/all_time_duration.json', fetchLifetimeStats);

  return (
    <StatsCard title="Lifetime incident duration">
      {
        (isLoading || !data) ?
          (
            <ProgressSpinner/>
          ) : (
            <h3 style={{ fontSize: '2em' }}>
              {moment.duration(data.totalDuration).format('h [hour], m [minute]')}
            </h3>
          )

      }
    </StatsCard>
  )
};
