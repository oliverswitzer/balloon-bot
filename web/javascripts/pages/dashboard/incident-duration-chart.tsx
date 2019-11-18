import { Chart } from 'primereact/chart';
import React from 'react';
import { StatsCard } from '../../shared-components/stats-card';
import { useFetch } from '../../hooks/use-fetch';
import { ProgressSpinner } from 'primereact/progressspinner';

function millisecondsToHours(milliseconds: number): number {
  return parseFloat((milliseconds / 1000 / 60 / 60).toFixed(2));
}

const mapResponseToChartData = response => {
  const { durationOverTime: { months, totalDurationPerMonth } } = response;

  return ({
    labels: months,
    datasets: [
      {
        label: 'Total Incident Duration (in hours)',
        data: totalDurationPerMonth.map(durations => millisecondsToHours(durations)),
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
