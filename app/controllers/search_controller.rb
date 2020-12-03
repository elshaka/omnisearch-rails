# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def index
    render json: { params: search_params }
  end

  def search_params
    params.permit(:engine, :text)
  end
end
