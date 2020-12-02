# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    render json: { params: search_params }
  end

  def search_params
    params.permit(:engine, :text)
  end
end
