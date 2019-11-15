import React from 'react';
import { LifetimeIncidentDuration } from './lifetime-incident-duration';
import { IncidentDurationChart } from './incident-duration-chart';

export const DashboardPage = () => {

  return (
    <>
      <div style={{ display: 'flex' }}>
        <div className='p-col-4'>
          <LifetimeIncidentDuration/>
        </div>
        <div className='p-col-8'>
          <IncidentDurationChart />
        </div>
      </div>
    </>
  )
};
