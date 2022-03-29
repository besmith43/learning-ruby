class AuthorsController < ApplicationController
  def new
    @page_title = 'Add New Author'
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save  
      flash[:notice] = "Author Created"

      redirect_to authors_path
    else
      render 'new'
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
  end

  private
    def author_params
      params.require(:author).permit(:first_name, :last_name)
    end
end
