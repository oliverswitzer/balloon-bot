import { useEffect, useState } from 'react';
import * as queryString from 'querystring';
import * as _ from 'lodash';

type QueryParams = { [key: string]: string | number }
type UseFetchReturnValues<ComponentData> = {
  data: ComponentData,
  fetchMore: (queryParams?: QueryParams) => void
  isLoading: boolean,
};


export function useFetch<ComponentData>(
  url: string,
  mappingFunction: (json: any) => ComponentData
): UseFetchReturnValues<ComponentData> {
  const [data, setData] = useState<ComponentData>();
  const [isLoading, setIsLoading] = useState(true);

  async function fetchData(queryParams?: QueryParams) {
    setIsLoading(true);
    const response = await fetchJson(url, queryParams);
    setData(mappingFunction(response));
    setIsLoading(false);
  }

  useEffect(() => {
    fetchData();
  }, []);

  return {
    data,
    isLoading,
    fetchMore: fetchData
  };
}

async function fetchJson(url: string, queryParams: QueryParams) {
  const response = await fetch(
    url + formatQueryParams(queryParams),
    {
      headers: {
        'Key-Inflection': 'camel'
      }
    }
  );
  return await response.json();
}

function formatQueryParams(queryParams: QueryParams): string {
  if(_.isEmpty(queryParams))
    return '';

  return `?${queryString.stringify(queryParams as queryString.ParsedUrlQueryInput)}`;
}
