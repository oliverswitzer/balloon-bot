import { Card } from 'primereact/card';
import { Chart } from 'primereact/chart';
import React from 'react';

const data = {
  labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
  datasets: [
    {
      label: 'Total Incident Duration',
      data: [65, 59, 80, 81, 56, 55, 40],
      fill: false,
      borderColor: '#4bc0c0'
    }
  ]
};

export const DashboardPage = () => (
  <>
    <div style={{ display: 'flex' }}>
      <div className='p-col-4'>
        <Card title="Total time holding deployments">
          <h1 style={{ fontSize: '3em' }}>
            340 minutes
          </h1>
        </Card>
      </div>
      <div className='p-col-8'>
        <Card title="Held deployments over time">
          <h1 style={{ fontSize: '3em' }}>
            <Chart type="line" data={data} />
          </h1>
        </Card>
      </div>
    </div>
  </>
);
