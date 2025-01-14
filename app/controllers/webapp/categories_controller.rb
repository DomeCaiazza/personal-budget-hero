class Mobile::CategoriesController < MobileController
  include CategoriesConcern
  before_action :set_category, only: [ :edit, :update ]

  def create
    policy_scope(Category)
    @category = current_user.categories.new(category_params)
    authorize @category

    if @category.save
      flash[:success] = t("labels.record_created")
      redirect_to mobile_categories_path, success: t("labels.record_created")
    else
      flash[:danger] = @category.errors.full_messages.join("<br>").html_safe
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize(@category)
    if @category.update(category_params)
      redirect_to mobile_categories_path, notice: t("labels.record_modified")
    else
      render :edit
    end
  end
end
