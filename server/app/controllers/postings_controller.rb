class PostingsController < ApplicationController

  def index
    render json: Posting.unprocessed.last(20)
  end

  def applied
    render json: Posting.applied
  end

  def update
    posting = Posting.find(params[:id])
    if params["category"] == "applied"
      Posting.unprocessed.where(company: posting.company).update_all(category: "applied")
    else
      posting.update(strong_params)
    end
    render json: posting
  end

  def filter

  end

  private

  def strong_params
    params.require(:posting).permit(:category)
  end
end
