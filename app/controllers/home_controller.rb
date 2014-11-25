class HomeController < ApplicationController

  def show
    @games = Game.all
  end
end
