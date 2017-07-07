class ActivitiesController < ApplicationController

  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  # Erro da gem Cancan (ActiveModel::ForbiddenAttributesError)
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  load_and_authorize_resource

  def show
    #
  end

  def new
    @activity = Activity.new
    @project = Project.find(params[:project])
    @sprint = Sprint.find(params[:sprint]) if params[:sprint].present?
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to activity_path(@activity), notice: "Atividade criada com sucesso!"
    else
      render :new, locals: {:@project => Project.find(activity_params[:project_id]),
                            :@sprint => Sprint.find(activity_params[:sprint_id])}
    end
  end

  def edit
  end

  def update

    if activity_params[:status_id].to_i == Status.where(description: 'Validado').first.id
      @activity.pontos_atualizados = @activity.pontos_cadastrados
    else
      @activity.pontos_atualizados = 0
    end

    if @activity.update(activity_params)
      redirect_to activity_path(@activity), notice: "Atividade atualizada com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @sprint = @activity.sprint
    @project = @activity.project
    if @activity.destroy
      # respond_to do |format|
      #   format.json {success: true, notice: "Atividade excluída com sucesso!"}
      # end
      redirect_to sprint_path(@sprint, project: @project),
      notice: "Atividade excluída com sucesso!"
    else
      # respond_to do |format|
      #   format.json {success: false, notice: "Erro ao excluir atividade..."}
      # end
      redirect_to sprint_path(@sprint, project: @project),
      notice: "Erro ao excluir atividade..."
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:id, :description, :pontos_cadastrados,
                                     :status_id, :label_id,
                                     :project_id, :sprint_id, :user_id)
  end

end
