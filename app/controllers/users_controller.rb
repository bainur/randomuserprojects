# users controller
class UsersController < ApplicationController
  include ActionView::Rendering  # Include rendering support

  def index
    @users = User.order('id').page(params[:page]).per(100) # Paginate with 10 records per page
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
