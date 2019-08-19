import {useEffect, useState} from 'react';

type UseFetchReturnValues<ComponentData> = {
  data: ComponentData,
  fetchMore: (url: string) => void
  isLoading: boolean,
};

export function useFetch<ComponentData>(
  url: string,
  mappingFunction: (json: any) => ComponentData
): UseFetchReturnValues<ComponentData> {
  const [data, setData] = useState<ComponentData>();
  const [isLoading, setIsLoading] = useState(true);

  async function fetchData(url: string) {
    setIsLoading(true);
    const response = await fetchJson(url);
    setData(mappingFunction(response));
    setIsLoading(false);
  }

  useEffect(() => {
    fetchData(url);
  }, []);

  return {
    data,
    isLoading,
    fetchMore: fetchData
  };
}

async function fetchJson(url: string) {
  const response = await fetch(url, {
    headers: {
      'X-Key-Inflection': 'camel'
    }
  });
  return await response.json();
}
