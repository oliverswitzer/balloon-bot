import { Incident, Message } from './types';
import React from 'react';
import { useQuery } from 'react-query';
import { fetchJson } from '../../utils/fetch-json';
import { DataTable } from 'primereact/datatable';
import { Column } from 'primereact/column';
import * as moment from 'moment';

type MessageFeedProps = {
  incident: Incident;
}

async function fetchMessagesForIncident({ incidentId }: { incidentId: number }): Promise<Message[]> {
  const messages = await fetchJson(`/incidents/${incidentId}/messages.json`);
  return messages.map(message => {
    return {
      ...message, createdAt: moment(message.createdAt).format('llll')
    }
  });
}

export const MessageFeed = ({ incident }: MessageFeedProps) => {
  const { data: messages, isLoading } = useQuery(['/incidents/:id/messages', { incidentId: incident.id }], fetchMessagesForIncident);

  return (
    <>
      <DataTable value={messages} style={{ maxHeight: '80vh', overflowY: 'scroll'}}>
        <Column field="channelName" header="Channel" />
        <Column field="createdAt" header="Time" />
        <Column field="text" header="Text" />
      </DataTable>
    </>
  )
};