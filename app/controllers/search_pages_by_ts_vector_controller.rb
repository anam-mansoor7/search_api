class SearchPagesByTsVectorController < ApplicationController
  def index
    Command::SearchPagesByTsVector.new.call(query: params[:query]) do |result|
      result.success do |success|
        render json: success[:pages], each_serializer: PageSerializer
      end

      result.failure do |failure|
        render json: { error: failure } , status: 400
      end
    end
  end
end
