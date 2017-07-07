class ProjectsController < ApplicationController

  # Erro da gem Cancan (ActiveModel::ForbiddenAttributesError)
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  load_and_authorize_resource

  def index
    if current_user_total?
      @projects = Project.all.order(:description).page(params[:page]).per(10)
    else
      ids = []
      tus = TeamUser.where(user_id: current_user.id)
      tus.each do |tu|
        ids << tu.team_id
      end

      @projects = Project.where(team_id: ids).order(:description)
                  .page(params[:page]).per(10)
    end
  end

  def show
    @project = Project.find(params[:id])
    @sprints = @project.sprints
  end

   def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save

      @sprints = Sprint.where(id: params[:sprint_ids])

      if @sprints.present?
        @sprints.each do |sprint|
          project_sprint = ProjectSprint.new
          project_sprint.project_id = @project.id
          project_sprint.sprint_id = sprint.id
          project_sprint.save
        end
      end

      redirect_to project_path(@project), notice: "Projeto criado com sucesso!"

    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @sprints = Sprint.where(id: params[:sprint_ids]).ids

    # Atualização das sprints do projeto [ProjectSprint]
    @project.project_sprints.each do |project_sprint|
      @id = @sprints.sample

      if @id.blank?
        project_sprint.destroy
      else
        project_sprint.update_attribute('sprint_id', @id)
      end
      @sprints.delete(@id)
    end

    unless @sprints.blank?
      @sprints.each do |sprint|
        ProjectSprint.create!(
          project_id: @project.id,
          sprint_id: sprint
          )
      end
    end

    # Atualização dos progressos do projeto
    @project.progresses.each do |p|
      p.advance = @project.progresses.where('id < ?', p.id).present? ?
                  p.completeness.to_i - @project.progresses
                                        .where('id < ?', p.id).last
                                        .completeness.to_i :
                  p.completeness
      p.save!
    end

    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Projeto atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      redirect_to projects_path, notice: "Projeto deletado com sucesso!"
    else
      redirect_to projects_path, notice: "Erro ao deletar o Project..."
    end
  end

  private

  def project_params
    params.require(:project).permit(:id, :description, :team_id,
                                    progresses_attributes:
                                    [:id, :completeness, :advance,
                                     :_destroy])
  end
end