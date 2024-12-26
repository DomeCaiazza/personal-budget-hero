class Mobile::CostsController < MobileController
  before_action :set_cost, only: [ :edit, :update ]
  before_action :set_categories, only: [ :edit, :new ]
  def index
    @costs = current_user.costs.order(id: :desc)
  end

  def new
    @cost = policy_scope(Cost).new
    authorize @cost
  end

  def edit
    authorize @cost
  end

  def create
    @cost = current_user.costs.new(cost_params)
    authorize @cost
    if @cost.save
      flash[:success] = t("labels.record_created")
      redirect_to new_mobile_cost_path, success: t("labels.record_created")
    else
      flash[:danger] = @cost.errors.full_messages.join("<br>").html_safe
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @cost
    if @cost.update(cost_params)
      redirect_to mobile_costs_path, notice: t("labels.record_modified")
    else
      render :edit
    end
  end

  private

  def cost_params
    params.require(:cost).permit(:description, :date, :amount, :category_id)
  end

  def set_cost
    @cost = policy_scope(Cost).find(params[:id])
  end

  def set_categories
    @categories = current_user.categories
  end
end
