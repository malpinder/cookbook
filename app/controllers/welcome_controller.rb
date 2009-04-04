class WelcomeController < ApplicationController
  def index
    @random_recipe = Recipe.find(:first, :order => 'RANDOM()')
  end

end
