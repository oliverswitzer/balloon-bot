import * as _ from 'lodash';
import * as queryString from "querystring";

type QueryParams = { [key: string]: string | number }
export async function fetchJson(url: string, queryParams: QueryParams) {
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
