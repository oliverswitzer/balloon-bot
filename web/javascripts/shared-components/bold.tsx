import * as React from 'react';

export const Bold = ({ children }: { children: React.ReactChild }) => (
  <span style={{ fontWeight: 'bold' }}>{children}</span>
);
