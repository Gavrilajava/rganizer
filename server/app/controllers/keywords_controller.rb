class KeywordsController < ApplicationController

  before_action :get_keyword, only: [:update, :destroy]

  def index
    render json: Keyword.all
  end

  def create
    render json: Keyword.create(strong_params)
  end

  def destroy
    @keyword.delete
  end

  def update
    @keyword.update(strong_params)
  end

  private

  def strong_params
    params.require(:keyword).permit(:title, :isActive, :isEntryLevel)
  end

  def get_keyword
    @keyword = Keyword.find(params[:id])
  end
end
