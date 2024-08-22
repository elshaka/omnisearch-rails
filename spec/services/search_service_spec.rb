# frozen_string_literal: true

require 'rails_helper'

ENGINE_URL = 'http://md5.jsontest.com/?text=example_text'

describe SearchService do
  let(:store) { Redis.new }

  describe '::map_data' do
    it 'must be implemented by a subclass' do
      expect { SearchService.map_data({}) }.to raise_error(NotImplementedError)
    end
  end

  describe '::provider_name' do
    it 'must be implemented by a subclass' do
      expect { SearchService.provider_name }.to raise_error(NotImplementedError)
    end
  end

  describe '::parse_response' do
    it 'must be implemented by a subclass' do
      expect { SearchService.parse_response('') }.to raise_error(NotImplementedError)
    end
  end

  describe '#perform_request' do
    before(:each) do
      allow(SearchService).to receive(:provider_name).and_return(:test)
      allow(SearchService).to receive(:parse_response).and_return({})
      allow(SearchService).to receive(:map_data).and_return([])
    end

    context 'when there is no cached response' do
      before(:each) { store.del(ENGINE_URL) }

      before do
        response = instance_double('Net::HTTPResponse', body: "{}", code: 200, method_missing: nil)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(response)
      end

      it 'performs an http get request' do
        expect_any_instance_of(Net::HTTP).to receive(:request)
        SearchService.call(ENGINE_URL)
      end

      it 'caches the request response' do
        SearchService.call(ENGINE_URL)
        expect(store.get(ENGINE_URL)).not_to be_nil
      end
    end

    context 'when there is a cached response' do
      before(:each) { store.set(ENGINE_URL, '{}')}

      it 'does not perform an http get request' do
        expect(Net::HTTP).not_to receive(:get_response)
        SearchService.call(ENGINE_URL)
      end
    end
  end
end
