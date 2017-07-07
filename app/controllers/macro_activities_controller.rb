class MacroActivitiesController < ApplicationController

  before_action :set_macro_activity, only: [:edit, :update, :destroy]

  # def index
  #   if current_user_total?
  #     @projects = Project.all.order(:description).page(params[:page]).per(5)
  #   else
  #     ids = []
  #     tus = TeamUser.where(user_id: current_user.id)
  #     tus.each do |tu|
  #       ids << tu.team_id
  #     end

  #     @projects = Project.where(team_id: ids).order(created_at: :desc)
  #                 .page(params[:page]).per(5)
  #   end
  # end

  # def show
  # end

  def new
    @macro_activity = MacroActivity.new
    @project = Project.find(params[:project])
  end

  def create
    @macro_activity = MacroActivity.new(macro_activity_params)

    if @macro_activity.save
      redirect_to project_path(@macro_activity.project),
      notice: 'Macro Atividade criada com sucesso!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @macro_activity.update(macro_activity_params)
      redirect_to project_path(@macro_activity.project),
                  notice: "Macro Atividade atualizada com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    if @macro_activity.destroy
      redirect_to project_path(@macro_activity.project),
      notice: 'Macro Atividade excluída com sucesso!'
    else
      redirect_to project_path(@macro_activity.project),
      notice: 'Erro ao tentar excluir Macro Atividade...'
    end
  end

  private

  def set_macro_activity
    @macro_activity = MacroActivity.find(params[:id])
  end

  def macro_activity_params
    params.require(:macro_activity).permit(:id, :description, :completeness,
                                           :project_id)
  end
end
