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
    let [objects, isLoading, fetchMore] = useFetchWrapper.run();

    expect(isLoading).toBe(true);

    await useFetchWrapper.mount();

    [objects, isLoading, fetchMore] = useFetchWrapper.run();

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

    it('should set objects state to the result of the mappingFunction call', async () => {
      await useFetchWrapper.mount();

      let [objects, isLoading, fetchMore] = useFetchWrapper.run();

      expect(objects).toEqual({ some: 'mapped data' })
    })
  });

  describe('fetchMore behavior', () => {
    beforeEach(() => {
      mappingFunctionSpy
        .mockReturnValueOnce({ some: 'mapped data' })
        .mockReturnValueOnce({ some: 'additional mapped data' })
    });

    it('should allow me to make further requests to the same endpoint', async () => {
      await useFetchWrapper.mount();

      let [objects, isLoading, fetchMore] = useFetchWrapper.run();

      expect(objects).toEqual({ some: 'mapped data' });

      await fetchMore('/url');

      expect(window.fetch).toHaveBeenCalled();
    });

    it('should update the objects held in the hooks state with the newly fetched data', async () => {
      await useFetchWrapper.mount();

      let [objects, isLoading, fetchMore] = useFetchWrapper.run();

      expect(objects).toEqual({ some: 'mapped data' });

      await fetchMore('/url');

      [objects, isLoading, fetchMore] = useFetchWrapper.run();

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
