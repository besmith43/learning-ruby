class Admin::UsersController < Admin::ApplicationController
  def new
    @page_title = 'Add User'
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User Created'
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = 'User Updated'

      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:notice] = 'User Removed'

      redirect_to admin_users_path
  end

  def index
    if params[:search]
      @users = User.search(params[:search]).all.order('created_at DESC').paginate(:per_page => 10, :page => params[:page])
    else
      @users = User.all.order('created_at DESC').paginate(:per_page => 10, :page => params[:page])
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
