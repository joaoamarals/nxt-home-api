# frozen_string_literal: true

class SearchesController < ApplicationController
  def create
    search = user.searches.new(search_params)

    if search.save
      render status: :created, json: search
    else
      render status: :unprocessable_entity, json: search.errors
    end
  end

  private

  def user
    User.find_or_create_by(email: params[:email])
  end

  def search_params
    params.require(:search).permit(:location, :min_price, :max_price, :no_rooms)
  end
end
