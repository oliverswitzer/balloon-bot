import * as moment from 'moment';
import { computeDuration } from './time-helpers';

describe('computeDuration', () => {
  it('should return duration between two dates', () => {
    let startDate = moment();
    let endDate = moment().add(1, 'day');

    let result = computeDuration(
      startDate.format(),
      endDate.format()
    );
    expect(result.asHours()).toEqual(24)
  });
});