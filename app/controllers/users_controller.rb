# users controller
class UsersController < ApplicationController
  include ActionView::Rendering  # Include rendering support

  def index
    @users = User.order('id').page(params[:page]).per(1000) # Paginate with 1000 records per page
    if params[:search_query].present?
      @users = @users.where("name ->> 'first' ILIKE ? OR name ->> 'last' ILIKE ? OR name ->> 'title' ILIKE ?", "%#{params[:search_query]}%", "%#{params[:search_query]}%", "%#{params[:search_query]}%")
    end
    liquid_template = Liquid::Template.parse(File.read('app/views/users/index.liquid'))
    rendered_template = liquid_template.render('users' => @users.map(&:attributes), )
    render html: rendered_template.html_safe
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User was successfully deleted.'
  end
end
