class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_rank_method
    rank_method = 'global_rank'
    rank_method = 'country_rank' if params[:country]
    rank_method = 'state_rank' if params[:state]
    rank_method = 'sub_state_rank' if params[:sub_state]
    rank_method = 'city_rank' if params[:city]
    rank_method
  end
end
