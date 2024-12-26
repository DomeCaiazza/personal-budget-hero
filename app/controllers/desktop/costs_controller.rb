class Desktop::CostsController < DesktopController
  before_action :set_cost, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:edit, :new, :update, :index, :create]

  def index
    params[:q] ||= {}
    @q = current_user.costs.ransack(params[:q])
    @costs = @q.result
  end

  def new
    @cost = current_user.costs.build
    authorize @cost
  end

  def create
    @cost = current_user.costs.build(cost_params)
    authorize @cost
    if @cost.save
      redirect_to desktop_costs_path, notice: t('labels.record_created')
    else
      render :new
    end
  end

  def edit
    authorize @cost
  end

  def update
    authorize @cost
    if @cost.update(cost_params)
      redirect_to desktop_costs_path, notice: t('labels.record_modified')
    else
      render :edit
    end
  end

  def destroy
    authorize @cost
    if @cost.destroy
      redirect_to desktop_costs_path, success: t('labels.record_destroyed')
    else
      flash[:danger] = "<b>#{t('labels.error_record_destroyed')}</b>: #{@cost.errors.full_messages.join(". ")}"
      redirect_to desktop_costs_path
    end
  end

  private

  def set_cost
    @cost = current_user.costs.find(params[:id])
  end

  def cost_params
    params.require(:cost).permit(:description, :date, :amount, :category_id)
  end

  def set_categories
    @categories = current_user.categories
  end
end