import { useState, useEffect } from 'react';

export function useFetch<ComponentData>(
  url: string,
  initialData: any,
  mappingFunction: (json: any) => ComponentData
): [ComponentData, boolean] {
  const [data, setData] = useState<ComponentData>(initialData);
  const [loading, setLoading] = useState(true);

  async function fetchUrl() {
    const response = await fetch(url, {
      headers: {
        'X-Key-Inflection': 'camel'
      }
    });
    const json = await response.json();
    setData(mappingFunction(json));
    setLoading(false);
  }

  useEffect(() => {
    fetchUrl();
  }, []);
  return [data, loading];
}
