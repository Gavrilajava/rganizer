class PostingsController < ApplicationController

  def index
    render json: Posting.unprocessed.first(20)
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

  def search
    Posting.get_all_glassdoor
    render json: {status: "success"}
  end

  def delete
    Posting.unprocessed.delete_all
    render json: {status: "success"}
  end

  def stats
    render json: Posting.stats
  end



  private

  def strong_params
    params.require(:posting).permit(:category)
  end
end
