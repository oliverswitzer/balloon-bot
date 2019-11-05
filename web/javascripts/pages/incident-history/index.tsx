import * as React from 'react';
import { useEffect, useState } from 'react';
import { DataView, DataViewLayoutOptions } from 'primereact/dataview';
import { ProgressSpinner } from 'primereact/progressspinner';

import { useFetch } from '../../hooks/use-fetch';
import { IncidentData } from './types';
import { DateRangeInput } from '../../shared-components/date-range-input/component';
import { DateRange } from '../../shared-components/date-range-input/types';
import { GridViewTemplate, ListViewTemplate } from './table-templates';

export const IncidentHistoryPage = () => {
  const {
    data: incidents,
    isLoading,
    fetchMore: fetchMoreIncidents
  } = useFetch<IncidentData[]>('/incidents.json', mapToIncidents);

  const [layout, setLayout] = useState<string>('grid');
  const [dateRange, setDateRange] = useState<DateRange>({});

  useEffect(() => {
    fetchMoreIncidents(formattedDateParams(dateRange))
  }, [dateRange]);

  return (
    <div>
      <h1 style={{ textAlign: 'center', marginBottom: '5vh', marginTop: '5vh' }}>Resolved Incidents</h1>
      <DateRangeInput
        dateRange={dateRange}
        onSelectDate={dates => setDateRange(dates)}
        labels={{
          afterLabel: 'Happened after',
          beforeLabel: 'Happened before'
        }}
      />

      {
        isLoading ?
          <ProgressSpinner/> :
          (
            <>

              <DataView
                value={incidents.filter(isResolved)}
                header={<DataViewLayoutOptions onChange={(e) => setLayout(e.value)}/>}
                layout={layout}
                itemTemplate={incidentTemplate}
              />
            </>
          )
      }
    </div>
  )
};

function formattedDateParams(dateRange: DateRange) {
  return {
    created_after: dateRange.after ? dateRange.after.getTime() : '',
    created_before: dateRange.before ? dateRange.before.getTime() : ''
  };
}

function mapToIncidents(res: any): IncidentData[] {
  return res;
}


const incidentTemplate = (incidentData: IncidentData, layout: string) => (
  <>
    {
      layout === 'grid' ? (
        <GridViewTemplate incidentData={incidentData}/>
      ) : (
        <ListViewTemplate incidentData={incidentData}/>
      )
    }
  </>
);

function isResolved(incidentData: IncidentData): boolean {
  return incidentData.incident.resolvedAt !== null;
}
