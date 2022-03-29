class BooksController < ApplicationController
  def new
    @page_title = 'Add New Book'
    @book = Book.new
    @category = Category.new
    @author = Author.new
    @publisher = Publisher.new
  end

  def create
    @book = Book.new(book_params)
    @book.save

    flash[:notice] = 'Book Added'

    redirect_to books_path
  end

  def update
    @book = Book.find(params[:id])

    @book.update(book_params)

    flash[:notice] = 'Book Updated'

    redirect_to books_path
  end

  def edit
    @book = Book.find(params[:id])
  end

  def destroy
    @book = Book.find(params[:id])

    @book.destroy

    flash[:notice] = 'Book Removed'

    redirect_to books_path
  end

  def index
    @books = Book.all
    @categories = Category.all
  end

  def show
    @book = Book.find(params[:id])
    @categories = Category.all
  end

  private
    def book_params
    params.require(:book).permit(:title, :category_id, :author_id, :publisher_id, :isbn, :price, :buy, :format, :excerpt, :pages, :year, :coverpath)
  end
end
