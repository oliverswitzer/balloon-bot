import * as moment from 'moment';
import { mount, ReactWrapper, shallow, ShallowWrapper } from 'enzyme';
import * as React from 'react';
import { Incident, IncidentData, Message } from './types';
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

function buildIncidentData(incidentData: Partial<IncidentData> = {}): IncidentData {
  return {
    incident: incidentData.incident || buildIncident(),
    terms: incidentData.terms || ['some', 'terms']
  }
}

describe('IncidentComponent', () => {
  let incidentData: IncidentData;
  let componentWrapper: ReactWrapper<any>;

  beforeEach(() => {
    let resolvedAt = moment();
    let createdAt = moment().add(1, 'day');

    incidentData = buildIncidentData({
      incident: buildIncident({
        resolvedAt: resolvedAt.format(),
        createdAt: createdAt.format()
      })
    });

    componentWrapper = mount(
      <IncidentRow incidentData={incidentData}/>
    )
  });

  describe('showing how long the incident was active', () => {
    it('takes the difference between when it was resolved and and created', () => {
      expect(componentWrapper.text()).toContain('Duration: a day')
    });
  });

  describe('when the incident has terms', () => {
    beforeEach(() => {
      incidentData = {
        ...incidentData,
        terms: ['these', 'are', 'terms']
      };
    });

    it('shows the terms associated with that incident', () => {
      componentWrapper = mount(
        <IncidentRow incidentData={incidentData}/>
      );

      expect(componentWrapper.text()).toContain('Top terms for incident');
      expect(componentWrapper.text()).toContain('these');
      expect(componentWrapper.text()).toContain('are');
      expect(componentWrapper.text()).toContain('terms');
    });
  });


  describe('when the incident does not have terms', () => {
    beforeEach(() => {
      incidentData = {
        ...incidentData,
        terms: []
      };
    });

    it('does not show the terms section', () => {
      componentWrapper = mount(
        <IncidentRow incidentData={incidentData}/>
      );

      expect(componentWrapper.text()).not.toContain('Top terms for incident');
    });
  });
});
