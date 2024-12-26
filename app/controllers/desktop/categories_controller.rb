class Desktop::CategoriesController < DesktopController
  before_action :set_category, only: [ :edit, :update, :destroy ]

  def index
    @categories = current_user.categories
  end

  def new
    @category = current_user.categories.build
    authorize @category
  end

  def create
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
      redirect_to desktop_categories_path(@category), notice: t("labels.record_modified")
    else
      render :edit
    end
  end

  def destroy
    authorize @category
    if @category.destroy
      redirect_to desktop_categories_path, success: t("labels.record_destroyed")
    else
      flash[:danger] = "<b>#{t('labels.error_record_destroyed')}</b>: #{@category.errors.full_messages.join(". ")}"
      redirect_to desktop_categories_path
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :hex_color)
  end
end
