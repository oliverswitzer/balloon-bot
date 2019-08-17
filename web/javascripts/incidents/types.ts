export type Message = {
  id: number,
  text: string,
  timestamp: string,
  channelId: string,
  createdAt: string,
}

export type Incident = {
  id: number;
  resolvedAt: string;
  createdAt: string;
  messages: Message[]
}
