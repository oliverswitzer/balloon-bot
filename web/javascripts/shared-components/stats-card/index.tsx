import { Card } from 'primereact/card';
import React from 'react';

type StatsCardProps = {
  title: string;
  children: React.ReactChild;
}

export const StatsCard = ({ title, children }: StatsCardProps) => (
  <Card style={{ textAlign: 'center' }} title={title}>
    <div style={{ fontFamily: 'monospace', fontSize: '2em' }}>
      {children}
    </div>
  </Card>
);
