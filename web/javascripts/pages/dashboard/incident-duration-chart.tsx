import { Chart } from 'primereact/chart';
import React from 'react';
import { StatsCard } from '../../shared-components/stats-card';
import { ProgressSpinner } from 'primereact/progressspinner';
import { useQuery } from 'react-query';
import { fetchIncidentDurationChartData } from './api/fetch-incident-duration-chart-data';


export const IncidentDurationChart = () => {
  const {
    data,
    isLoading
  } = useQuery<object, {}>('/incidents/stats_over_time.json', fetchIncidentDurationChartData);

  return (
    <StatsCard title="Held deployments over time">
      { isLoading ? <ProgressSpinner/> : <Chart type="line" data={data}/> }
    </StatsCard>
  );
};
