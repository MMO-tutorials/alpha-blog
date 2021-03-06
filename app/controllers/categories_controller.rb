class CategoriesController < ApplicationController
  before_action :require_admin, only: [:new, :create]
  before_action :set_category, only: [:show, :edit, :update]

  def index
    @categories = Category.paginate(page: params[:page], per_page: 4)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "New category was created"
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def show
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 4)
  end

  def edit

  end

  def update
    if @category.update(category_params)
      flash[:success] = "Category was updated"
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? && !current_user.admin?)
      flash[:danger] = "Only an admin may perform that action"
      redirect_to categories_path
    end
  end

  def set_category
    @category = Category.find(params[:id])
  end

end