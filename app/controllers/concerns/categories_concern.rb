module CategoriesConcern
  extend ActiveSupport::Concern

  def index
    policy_scope(Category)
    @categories = current_user.categories
    authorize(@categories)
  end

  def new
    policy_scope(Category)
    @category = current_user.categories.build
    authorize @category
  end

  def edit
    authorize @category
  end

  private

  def category_params
    params.require(:category).permit(:name, :hex_color, :category_type)
  end

  def set_category
    policy_scope(Category)
    @category = current_user.categories.find(params[:id])
  end
end
