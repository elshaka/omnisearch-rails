# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def index
    search = Search.new(search_params)
    if (results = search.results)
      render json: results, status: results[:status]
    else
      render json: { errors: search.errors }, status: :unprocessable_entity
    end
  end

  def search_params
    params.permit(:engine, :text)
  end
end
