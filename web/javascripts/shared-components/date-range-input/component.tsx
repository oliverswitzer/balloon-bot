import { Calendar } from "primereact/calendar";
import * as React from "react";
import { DateRange } from "./types";

export type DateRangeFilterProps = {
  onSelectDate(dates: DateRange): void;
  dateRange: DateRange;
  labels: {
    beforeLabel: string;
    afterLabel: string;
  };
}

export const DateRangeInput = ({ onSelectDate, dateRange, labels }: DateRangeFilterProps) => (
  <div className="p-grid p-fluid">
    <div className="p-col-3 p-md-4">
      <h3>
        {labels.afterLabel}
      </h3>

      <Calendar
        value={dateRange.after}
        onChange={e => onSelectDate({
          before: dateRange.before,
          after: e.value as Date
        })}
        showTime={true}
      />
    </div>

    <div className="p-col-3 p-md-4">
      <h3>
        {labels.beforeLabel}
      </h3>

      <Calendar
        value={dateRange.before}
        onChange={e => onSelectDate({
          after: dateRange.after,
          before: e.value as Date
        })}
        showTime={true}
      />
    </div>
  </div>
);