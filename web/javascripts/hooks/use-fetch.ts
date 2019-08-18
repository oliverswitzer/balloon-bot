import {useEffect, useState} from 'react';

type UseFetchReturnValues<ComponentData> = [
  ComponentData,
  boolean,
  (url: string) => void
];

export function useFetch<ComponentData>(
  url: string,
  mappingFunction: (json: any) => ComponentData
): UseFetchReturnValues<ComponentData> {
  const [data, setData] = useState<ComponentData>();
  const [loading, setLoading] = useState(true);

  async function fetchUrl(url: string) {
    setLoading(true);
    const response = await getJson(url);
    setData(mappingFunction(response));
    setLoading(false);
  }

  useEffect(() => {
    fetchUrl(url);
  }, []);

  return [data, loading, fetchUrl];
}

async function getJson(url: string) {
  const response = await fetch(url, {
    headers: {
      'X-Key-Inflection': 'camel'
    }
  });
  return await response.json();
}
