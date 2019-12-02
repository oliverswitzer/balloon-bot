import * as React from 'react';
import { useState } from 'react';
import { DataView, DataViewLayoutOptions } from 'primereact/dataview';
import { ProgressSpinner } from 'primereact/progressspinner';

import { IncidentData } from './types';
import { DateRangeInput } from '../../shared-components/date-range-input/component';
import { DateRange } from '../../shared-components/date-range-input/types';
import { GridViewTemplate, ListViewTemplate } from './table-templates';
import { useQuery } from 'react-query';
import { DateParams, fetchIncidentData, formattedDateParams } from './api/fetch-incidents';

export const IncidentHistoryPage = () => {
  const [layout, setLayout] = useState<string>('grid');
  const [dateRange, setDateRange] = useState<DateRange>({});

  const {
    data: incidents,
    isLoading
  } = useQuery<IncidentData[], DateParams>(
    ['/incidents.json', formattedDateParams(dateRange)],
    fetchIncidentData
  );

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
        isLoading || !incidents ?
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
