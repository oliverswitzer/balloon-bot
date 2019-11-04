import * as moment from 'moment';

export function computeDuration(startDate: string, endDate: string): moment.Duration {
  return moment.duration(
      moment(endDate).diff(moment(startDate))
  );
}