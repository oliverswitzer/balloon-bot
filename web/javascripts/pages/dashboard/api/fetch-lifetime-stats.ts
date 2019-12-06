import { fetchJson } from '../../../utils/fetch-json';

export const fetchLifetimeStats = async () => {
  return await fetchJson('/incidents/lifetime_stats.json').then(res => res.lifetimeStats);
};