# frozen_string_literal: true

require 'rails_helper'

describe BingSearch do
  let(:results) { BingSearch.call('test') }

  describe '::provider_name' do
    it 'must return search provider name as a symbol' do
      expect(BingSearch.provider_name.class).to be Symbol
    end
  end

  describe '::map_data', :vcr do
    it 'must map bing results to the expected format' do
      data = results[:data]
      data.each do |d|
        expect(d.keys).to match_array([:title, :link])
      end
    end
  end
end
