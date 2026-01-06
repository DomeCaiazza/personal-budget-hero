class Webapp::CategoriesController < WebappController
  include CategoriesConcern
  before_action :set_category, only: [ :edit, :update ]

  def create
    policy_scope(Category)
    @category = @account.categories.new(category_params)
    authorize @category

    if @category.save
      flash[:success] = t("controllers.webapp.categories.create.success")
      redirect_to account_webapp_categories_path(@account), success: t("controllers.webapp.categories.create.success")
    else
      flash.now[:danger] = "#{t('controllers.webapp.categories.create.error')}: #{@category.errors.full_messages.join("<br>")}".html_safe
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize(@category)
    if @category.update(category_params)
      redirect_to account_webapp_categories_path(@account), notice: t("controllers.webapp.categories.update.success")
    else
      flash.now[:danger] = t("controllers.webapp.categories.update.error")
      render :edit
    end
  end
end
