import { IncidentData } from '../types';
import { fetchJson } from '../../../utils/fetch-json';
import { DateRange } from '../../../shared-components/date-range-input/types';


export const fetchIncidentData = async (params: DateParams): Promise<IncidentData[]> => {
  return await fetchJson('/incidents.json', params)
    .then(response => response as IncidentData[]);
};

export type DateParams = {
  created_after?: number;
  created_before?: number;
}
export function formattedDateParams(dateRange: DateRange): DateParams {
  const dateParams: DateParams = {};
  if(dateRange.after)
    dateParams.created_after = dateRange.after.getTime();
  if(dateRange.before)
    dateParams.created_before = dateRange.before.getTime();

  return dateParams;
}