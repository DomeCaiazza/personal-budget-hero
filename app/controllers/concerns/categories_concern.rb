module CategoriesConcern
  extend ActiveSupport::Concern

  included do
    include AccountConcern
    before_action :set_category, only: [ :edit, :update, :destroy ]
  end

  def index
    policy_scope(Category)
    @categories = @account.categories
    authorize(@categories)
  end

  def new
    policy_scope(Category)
    @category = @account.categories.build
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
    @category = @account.categories.find(params[:id])
  end
end
