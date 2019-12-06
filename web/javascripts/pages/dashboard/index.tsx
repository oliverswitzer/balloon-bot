import React from 'react';
import { LifetimeIncidentDuration } from './lifetime-incident-duration';
import { IncidentDurationChart } from './incident-duration-chart';
import { LifetimeAverageIncidentDuration } from './lifetime-average-incident-duration';

export const DashboardPage = () => {

  return (
    <>
      <div style={{ display: 'flex' }}>
        <div className='p-grid p-dir-col p-col-4'>
          <div className='p-col-12'>
            <LifetimeIncidentDuration/>
          </div>
          <div className='p-col-12'>
            <LifetimeAverageIncidentDuration/>
          </div>
        </div>
        <div className='p-col-8'>
          <IncidentDurationChart />
        </div>
      </div>
    </>
  )
};

