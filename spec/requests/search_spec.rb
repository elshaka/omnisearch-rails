require 'rails_helper'

RSpec.describe 'Search', type: :request do
  describe "GET /search" do
    context 'with invalid search parameters' do
      before(:all) do
        get search_path
        @json_response = JSON.parse(response.body, symbolize_names: true)
      end

      it 'responds with a 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'includes an errors key in the response' do
        expect(@json_response).to have_key(:errors)
      end
    end

    context 'with valid search parameters' do
      before :all do
        VCR.use_cassette("get_search") do
          get search_path(engine: 'both', text: 'test')
          @json_response = JSON.parse(response.body, symbolize_names: true)
        end
      end

      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the expected keys in the response' do
        expect(@json_response.keys).to match_array([:status, :status_by_provider, :results])
      end
    end
  end
end
