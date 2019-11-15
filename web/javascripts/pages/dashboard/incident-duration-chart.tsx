import { Chart } from 'primereact/chart';
import React from 'react';
import { StatsCard } from '../../shared-components/stats-card';
import { useFetch } from '../../hooks/use-fetch';
import { ProgressSpinner } from 'primereact/progressspinner';

function millisecondsToMinutes(milliseconds: number): number {
  return Math.floor(milliseconds / 1000 / 60);
}

const mapResponseToChartData = response => {
  const { durationOverTime: { months, totalDurationPerMonth } } = response;

  return ({
    labels: months,
    datasets: [
      {
        label: 'Total Incident Duration (in minutes)',
        data: totalDurationPerMonth.map(durations => millisecondsToMinutes(durations)),
        fill: false,
        borderColor: 'green'
      }
    ]
  })
};

export const IncidentDurationChart = () => {
  const {
    data,
    isLoading
  } = useFetch<object>('/incidents/duration_over_time.json', mapResponseToChartData);

  return (
    <StatsCard title="Held deployments over time">
      { isLoading ? <ProgressSpinner/> : <Chart type="line" data={data}/> }
    </StatsCard>
  );
};
