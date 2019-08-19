import init from 'jooks'
import { useFetch } from "./use-fetch";

describe('useFetch', function () {
  let mappingFunctionSpy: jest.Mock<any> = jest.fn();
  let useFetchWrapper = init(() => useFetch('/foo', mappingFunctionSpy));
  let mockFetchResponse: any;

  beforeEach(() => {
    mockFetchResponse = { foo: 'bar' };
    window.fetch = successfulMockFetch(mockFetchResponse)
  });

  it('isLoading should be true before request completes and false after it completes', async () => {
    let { data, isLoading, fetchMore } = useFetchWrapper.run();

    expect(isLoading).toBe(true);

    await useFetchWrapper.mount();

    ({ data, isLoading, fetchMore } = useFetchWrapper.run());

    expect(isLoading).toBe(false);
  });

  describe('mappingFunction behavior', function () {
    beforeEach(() => {
      mappingFunctionSpy.mockReturnValue({ some: 'mapped data' })
    });

    it('should call the mappingFunction with the API response from fetch', async () => {
      await useFetchWrapper.mount();

      expect(mappingFunctionSpy).toHaveBeenCalledWith(mockFetchResponse);
    });

    it('return data that has been fetched and mapped with the passed in mappingFunction', async () => {
      await useFetchWrapper.mount();

      let { data, isLoading, fetchMore } = useFetchWrapper.run();

      expect(data).toEqual({ some: 'mapped data' })
    })
  });

  describe('fetchMore behavior', () => {
    beforeEach(() => {
      mappingFunctionSpy
        .mockReturnValueOnce({ some: 'mapped data' })
        .mockReturnValueOnce({ some: 'additional mapped data' })
    });

    it('calling "fetchMore" should make an additional network request', async () => {
      await useFetchWrapper.mount();

      let { data, isLoading, fetchMore } = useFetchWrapper.run();

      expect(data).toEqual({ some: 'mapped data' });

      await fetchMore('/url');

      expect(window.fetch).toHaveBeenCalled();
    });

    it('calling "fetchMore" should update the objects held in the hooks state', async () => {
      await useFetchWrapper.mount();

      let { data: objects, isLoading, fetchMore } = useFetchWrapper.run();

      expect(objects).toEqual({ some: 'mapped data' });

      await fetchMore('/url');

      ({ data: objects, isLoading, fetchMore } = useFetchWrapper.run());

      expect(objects).toEqual({ some: 'additional mapped data' })
    });
  })
});


function successfulMockFetch(mockResponse: any) {
  return jest.fn().mockImplementation(() => {
    return Promise.resolve({
      ok: true,
      json: () => Promise.resolve(mockResponse)
    });
  });
}
