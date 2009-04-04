class CommentsController < ApplicationController
  def new
    @recipe = Recipe.find(params[:recipe_id])

    @comment = Comment.new
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = session[:user_id]
    @comment.recipe_id = params[:recipe_id]

    unless @comment.valid?
      render :action => :new
      return
    end

    @comment.save
    redirect_to recipe_path(params[:recipe_id])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    unless @comment.update_attributes(params[:comment])
      flash[:warning] = 'Invalid comment.'
      render :action => :edit
      return
    end

    flash[:notice] = "Comment edited."
    redirect_to recipe_path(params[:recipe_id])
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = 'Comment deleted.'
    redirect_to recipe_path(params[:recipe_id])
  end

end
