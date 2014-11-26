class Api::BusinessesController < ApplicationController
  def create
    @business = Business.new(business_params)
    if @business.save
      render json: @business
    else
      render json: @business.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def update
  end
  
  def destroy
  end
  
  def show
    #@business = Business.includes(:articles).find(params[:id])
    render json: Business.find(params[:id]), include: :latest_articles
  end
  
  def index
  end

  private 
  def business_params
    params.require(:business).permit(:title, :rss_feed_url, :description, :category_id)
  end
end
