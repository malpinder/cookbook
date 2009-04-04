class RecipesController < ApplicationController
  def new
    @recipe = Recipe.new
    @amount = Amount.new
    @amount.ingredient = Ingredient.new
    @recipe.amounts << @amount
  end
  
  def create
    @recipe = Recipe.new(params[:recipe])

    if params[:commit] == 'Add another ingredient'
      @amount = Amount.new
      @amount.ingredient = Ingredient.new
      @recipe.amounts << @amount
      render :action => :new
      return
    end

    if params[:commit] == 'Remove ingredient'
      @recipe.ingredients.delete_at(-1)
      @recipe.amounts.delete_at(-1)
      render :action => :new
      return
    end

    @recipe.user_id = current_user.id    
    unless @recipe.valid?
      render :action => :new
      return
    end
    @recipe.save
    redirect_to recipe_path(@recipe)
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.new(params[:recipe])

    if params[:commit] == 'Add another ingredient'
      @amount = Amount.new
      @amount.ingredient = Ingredient.new
      @recipe.amounts << @amount
      render :action => :edit
      return
    end

    if params[:commit] == 'Remove ingredient'
      #@recipe.ingredients.delete_at(-1)
      #@recipe.amounts.delete_at(-1)
      render :action => :edit
      return
    end

    unless @recipe.update_attributes(params[:recipe])
      flash[:error] = 'Update failed.'
      render :action => :edit
      return
    end

    #@recipe.amounts.each do |a|
    #  a.delete unless params[:recipe].include?(a)
    #end

    flash[:notice] = 'Updated recipe succesfully.'
    redirect_to recipe_path
  end

  def show
    @recipe = Recipe.find(params[:id])   
  end

  def recipe_viewed_by_recipe_owner?
    return true if session[:user_id].to_i == @recipe.user_id.to_i
    false
  end

  def index
    @pager = ::Paginator.new(Recipe.count, 10) do |offset, per_page|
      Recipe.find(:all, :limit => per_page, :offset => offset)
    end
    @page = @pager.page(params[:page])
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:notice] = 'Recipe deleted.'
    redirect_to welcome_path
  end

end
