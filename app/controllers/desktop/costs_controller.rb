class Desktop::CostsController < DesktopController
  before_action :set_cost, only: [ :edit, :update, :destroy ]
  before_action :set_categories, only: [ :edit, :new, :update, :index, :create ]

  def index
    policy_scope(Cost)
    params[:q] ||= { date_gteq: Date.today.beginning_of_month, date_lteq: Date.today.end_of_month }
    @q = current_user.costs.ransack(params[:q])
    @costs = @q.result
    # @costs_report = CostReportService.new(@costs, params[:q][:date_gteq].to_s, params[:q][:date_lteq].to_s).generate
    authorize(@costs)
  end

  def new
    policy_scope(Cost)
    @cost = current_user.costs.build
    authorize @cost
  end

  def create
    policy_scope(Cost)
    @cost = current_user.costs.build(cost_params)
    authorize @cost
    if @cost.save
      redirect_to desktop_costs_path, notice: t("labels.record_created")
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
      redirect_to desktop_costs_path, notice: t("labels.record_modified")
    else
      render :edit
    end
  end

  def destroy
    policy_scope(@cost)
    authorize @cost
    if @cost.destroy
      flash[:success] = t("labels.record_destroyed")
    else
      flash[:danger] = "<b>#{t('labels.error_record_destroyed')}</b>: #{@cost.errors.full_messages.join(". ")}"
    end
    redirect_to desktop_costs_path
  end

  private

  def set_cost
    policy_scope(Cost)
    @cost = current_user.costs.find(params[:id])
  end

  def cost_params
    params.require(:cost).permit(:description, :date, :amount, :category_id)
  end

  def set_categories
    policy_scope(Category)
    @categories = current_user.categories
  end
end
