import * as moment from 'moment';
import { shallow, ShallowWrapper } from 'enzyme';
import * as React from 'react';
import { Incident, Message } from './types';
import { IncidentRow } from './incident-row';

function buildMessage(message: Partial<Message> = {}): Message {
  return {
    id: randomId(),
    text: message.text || 'some text',
    timestamp: message.timestamp || String(moment().unix()),
    channelId: message.channelId || String(randomId()),
    createdAt: message.createdAt || moment().format(),
  };
}

function randomId(): number {
  return Math.floor(Math.random() * 100);
}

function buildIncident(incident: Partial<Incident> = {}): Incident {
  return {
    id: randomId(),
    resolvedAt: incident.resolvedAt || moment().format(),
    createdAt: incident.createdAt || moment().format(),
    messages: incident.messages || [buildMessage()]
  };
}

describe('IncidentComponent', () => {
  let incident: Incident;
  let componentWrapper: ShallowWrapper<Incident>;

  beforeEach(() => {
    let resolvedAt = moment();
    let createdAt = moment().add(1, 'day');

    incident = buildIncident({
      resolvedAt: resolvedAt.format(),
      createdAt: createdAt.format()
    });

    componentWrapper = shallow(
      <IncidentRow incident={incident}/>
    )
  });

  describe('showing how long the incident was active', () => {
    it('takes the difference between when it was resolved and and created', () => {
      componentWrapper = shallow(
        <IncidentRow incident={incident}/>
      );

      expect(componentWrapper.text()).toContain('Duration: a day')
    });
  });
});
