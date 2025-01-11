
  class Mobile::CategoriesController < MobileController
    before_action :set_category, only: [ :edit, :update ]


    def index
      policy_scope(Category)
      @categories = current_user.categories
      authorize(@categories)
    end

    def new
      @category = policy_scope(Category).new
      authorize @category
    end

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

    def edit
      authorize @category
    end

    def update
      authorize(@category)
      if @category.update(category_params)
        redirect_to mobile_categories_path, notice: t("labels.record_modified")
      else
        render :edit
      end
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
