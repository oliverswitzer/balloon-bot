import { fetchJson } from '../../../utils/fetch-json';

export const fetchIncidentDurationChartData = async () => {
  const response = await fetchJson('/incidents/stats_over_time.json');

  const { statsOverTime: { months, totalDurationPerMonth, totalCountPerMonth } } = response;

  return ({
    labels: months,
    datasets: [
      {
        label: 'Total Incident Duration (in hours)',
        data: totalDurationPerMonth.map(durations => millisecondsToHours(durations)),
        fill: false,
        borderColor: 'green'
      },
      {
        label: 'Total Incident Count',
        data: totalCountPerMonth,
        fill: false,
        borderColor: 'red'
      }
    ]
  })
};

function millisecondsToHours(milliseconds: number): number {
  return parseFloat((milliseconds / 1000 / 60 / 60).toFixed(2));
}