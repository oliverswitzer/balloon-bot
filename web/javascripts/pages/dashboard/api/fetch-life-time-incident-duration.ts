import { fetchJson } from '../../../utils/fetch-json';

export const fetchLifeTimeIncidentDuration = async () => {
  return await fetchJson('/incidents/all_time_duration.json').then(res => res.allTimeDuration);
};