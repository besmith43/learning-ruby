class Admin::CategoriesController < Admin::ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    @categories = Category.all
  end

  def show
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end
