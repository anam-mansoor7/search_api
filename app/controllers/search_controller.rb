class SearchController < ApplicationController
  def pages
    Command::SearchPages.new.call(query: params[:query]) do |result|
      result.success do |success|
        render json: success[:pages]
      end

      result.failure do |failure|
        render json: { error: failure } , status: 400
      end
    end
  end
end
