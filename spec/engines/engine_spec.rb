# frozen_string_literal: true

require 'rails_helper'

ENGINE_URL = 'http://md5.jsontest.com/?text=example_text'

describe Engine do
  let(:engine) { Engine.new(ENGINE_URL) }
  let(:store) { Redis.new }

  describe '::map_data' do
    it 'must be implemented by a subclass' do
      expect { Engine.map_data({}) }.to raise_error(NotImplementedError)
    end
  end

  describe '::provider_name' do
    it 'must be implemented by a subclass' do
      expect { Engine.provider_name }.to raise_error(NotImplementedError)
    end
  end

  describe '#perform_request', :vcr do
    context 'when there is no cached response' do
      before(:each) { store.del(ENGINE_URL) }

      it 'performs an http get request' do
        expect_any_instance_of(Net::HTTP).to receive(:request)
        engine.perform_request
      end

      it 'caches the request response' do
        engine.perform_request
        expect(store.get(ENGINE_URL)).not_to be_nil
      end
    end

    context 'when there is a cached response' do
      before(:each) { store.set(ENGINE_URL, '{}')}

      it 'does not perform an http get request' do
        expect(Net::HTTP).not_to receive(:get_response)
        engine.perform_request
      end
    end
  end

  describe '#results' do
    it 'must return a proper results object' do
      allow(engine).to receive(:perform_request).and_return({})
      allow(Engine).to receive(:provider_name).and_return(:test_provider)
      allow(Engine).to receive(:map_data).and_return([])

      r = engine.results

      expect(r.keys).to match_array([:provider, :status, :error_message, :data])
    end
  end
end
