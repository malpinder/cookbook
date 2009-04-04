# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    not session[:user_id].nil?
  end

  def current_user
    User.find(session[:user_id])
  end

  def ids_match?
    return true if session[:user_id].to_i == params[:id].to_i
    return false
  end

  def recipe_viewed_by_recipe_owner?
    return true if session[:user_id].to_i == @recipe.user_id.to_i
    false
  end

end
