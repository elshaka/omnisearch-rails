# frozen_string_literal: true

require 'rails_helper'

ENGINE_URL = 'http://md5.jsontest.com/?text=example_text'

describe Engine do
  let(:engine) { Engine.new(ENGINE_URL) }
  let(:store) { Redis.new }

  describe '#perform_request' do
    VCR.use_cassette('engine') do
      context 'when there is no cached response' do
        before(:each) { store.del(ENGINE_URL) }

        it 'performs an http get request' do
          expect(Net::HTTP).to receive(:get_response)
          engine.perform_request
        end
      end
    end
  end
end
