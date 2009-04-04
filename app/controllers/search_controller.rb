class SearchController < ApplicationController
  def new
  end

  def show

      case params[:type]
      when 'ingredient'
        @results = Ingredient.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"]).map(&:recipes).flatten

      when 'recipe'
        @results = Recipe.find(:all, :conditions => ["name like ?", "%#{params[:terms]}%"])

      when 'user'
        @results = User.find(:all, :conditions => ["username like ?", "%#{params[:terms]}%"]).map(&:recipes).flatten
        
      end

      @results.delete_if do |recipe|
        params[:course] != recipe.course
      end unless params[:course] == 'all'
 

  end

  def create

    unless %w(recipe ingredient user).include?(params[:type])
      flash[:error] = 'Invalid search.'
      redirect_to :back
      return
    end

    redirect_to search_path(:type => params[:type], :course => params[:course], :terms => params[:terms])
  end
end
