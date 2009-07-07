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
    @recipe = Recipe.find(params[:id])
    @recipe.attributes = params[:recipe]

    if params[:commit] == 'Add another ingredient'
      @amount = Amount.new
      @amount.ingredient = Ingredient.new
      @recipe.amounts << @amount
      render :action => :edit
      return
    end

    if params[:commit] == 'Remove ingredient'
      @recipe.amounts.delete_at(-1)
      render :action => :edit
      return
    end

    unless @recipe.save
      flash[:error] = 'Update failed.'
      render :action => :edit
      return
    end

    #loops through the hashes in params, fetching out amounts and the
    #ingredients they match to, and storing them in a nested array.
    params[:recipe][:amounts_attributes].each do |key, value|
      if value.kind_of?(Hash)
        value.each do |key2, value2|
          if key2 == 'ingredient_attributes'
            value2.each do |key3, value3|
              if key3 == 'name'
                @ingredients ||= Array.new
                @ingredients << value3
              end
            end
          end
        end
      end
    end

    params[:recipe][:amounts_attributes].each do |key, value|
      if value.kind_of?(Hash)
        value.each do |key2, value2|
          if key2 == 'amount'
            @param_amounts ||= Array.new
            @iterations ||= 0
            @param_amounts << [value2, @ingredients.fetch(@iterations).to_s]
            @iterations += 1
          end
        end
      end
    end
    #that's the end of the ugly looping.

    @recipe = Recipe.find(params[:id])
    @recipe.amounts.each do |a|
      a.destroy unless @param_amounts.include?([a.amount, a.ingredient.name])
    end

    unless @recipe.save
      flash[:error] = 'Update failed.'
      render :action => :edit
      return
    end

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
    @recipes = Recipe.paginate(:page => params[:page], :order => 'id ASC', :per_page => 10)
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:notice] = 'Recipe deleted.'
    redirect_to welcome_path
  end

end
