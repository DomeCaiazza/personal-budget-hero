class Console::CategoriesController < ConsoleController
  include CategoriesConcern

  def create
    policy_scope(Category)
    @category = @account.categories.build(category_params)
    authorize @category
    if @category.save
      redirect_to account_console_categories_path(@account), notice: t("controllers.console.categories.create.success")
    else
      flash.now[:danger] = t("controllers.console.categories.create.error")
      render :new
    end
  end

  def update
    authorize @category
    if @category.update(category_params)
      redirect_to account_console_categories_path, notice: t("controllers.console.categories.update.success")
    else
      flash.now[:danger] = t("controllers.console.categories.update.error")
      render :edit
    end
  end

  def destroy
    policy_scope(@category)
    authorize @category
    if @category.destroy
      flash[:success] = t("controllers.console.categories.destroy.success")
      redirect_to account_console_categories_path
    else
      flash[:danger] = "#{t('controllers.console.categories.destroy.error')}: #{@category.errors.full_messages.join(". ")}"
      redirect_to account_console_categories_path
    end
  end
end
