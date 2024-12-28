class Desktop::CategoriesController < DesktopController
  before_action :set_category, only: [ :edit, :update, :destroy ]

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

  def create
    policy_scope(Category)
    @category = current_user.categories.build(category_params)
    authorize @category
    if @category.save
      redirect_to desktop_categories_path, notice: t("labels.record_created")
    else
      render :new
    end
  end

  def edit
    authorize @category
  end

  def update
    authorize @category
    if @category.update(category_params)
      redirect_to desktop_categories_path, notice: t("labels.record_modified")
    else
      render :edit
    end
  end

  def destroy
    policy_scope(@category)
    authorize @category
    if @category.destroy
      flash[:success] = t("labels.record_destroyed")
      redirect_to desktop_categories_path
    else
      flash[:danger] = "<b>#{t('labels.error_record_destroyed')}</b>: #{@category.errors.full_messages.join(". ")}"
      redirect_to desktop_categories_path
    end
  end

  private

  def set_category
    policy_scope(Category)
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :hex_color)
  end
end
