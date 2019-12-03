import React from 'react';
import * as moment from 'moment';
import { ProgressSpinner } from 'primereact/progressspinner';
import { StatsCard } from '../../shared-components/stats-card';
import momentDurationFormatSetup from 'moment-duration-format';
import { useQuery } from 'react-query';
import { fetchLifeTimeIncidentDuration } from './api/fetch-life-time-incident-duration';

momentDurationFormatSetup(moment);

export const LifetimeIncidentDuration = () => {
  const {
    data: durationInMilliseconds,
    isLoading
  } = useQuery<number, {}>('/incidents/all_time_duration.json', fetchLifeTimeIncidentDuration);

  return (
    <StatsCard title="Lifetime incident duration">
      {
        isLoading ?
          (
            <ProgressSpinner />
          ):
          <h3 style={{fontSize: '2em'}}>
            {moment.duration(durationInMilliseconds).format("h [hour], m [minute]")}
          </h3>
      }
    </StatsCard>
  )
};
