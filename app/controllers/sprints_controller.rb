class SprintsController < ApplicationController

  include SprintsHelper

  # Erro da gem Cancan (ActiveModel::ForbiddenAttributesError)
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  load_and_authorize_resource

  def show
    @sprint = Sprint.find(params[:id]) #pega a variavel Sprint e o id especifico para mostrar os dados dela
    @project = Project.find(params[:project])
    @activities = Activity.all
                  .joins({user: :user_profile})
                  .where(project_id: @project.id, sprint_id: @sprint.id)
                  .order("user_profiles.name").page(params[:page]).per(10)
  end

  def new
    @sprint = Sprint.new
    @project = Project.find(params[:project]).id
  end

  def create

    @sprint = Sprint.new(sprint_params)

    verify_dates # Function - Verifica se não existe uma sprint nesse período

    unless @sprint.errors.any?

      if @sprint.save

        @project_sprint = ProjectSprint.new(project_id: params[:project],
                                            sprint_id: @sprint.id)

        if @project_sprint.save

          create_weeks_dynamically # Function - Cria as semanas dinamicamente

          redirect_to sprint_path(@sprint, project: params[:project]),
          notice: "Sprint criado com sucesso!"
        end

      end

    else
      render :new, locals: {:@project => params[:project].to_i}
    end

  end

  def edit
    @sprint = Sprint.find(params[:id]) #pega a variavel Sprint e o id especifico para editar os dados dela
    @project = Project.find(params[:project]).id
  end

  def update
    @sprint = Sprint.find(params[:id])
    @last_end = @sprint.fim

    verify_dates # Function - Verifica se não existe uma sprint nesse período

    unless @sprint.errors.any?

      if @sprint.update(sprint_params)

        update_weeks_dynamically(@last_end) # Function - Cria as semanas dinamicamente

        redirect_to sprint_path(@sprint, project: params[:project]),
        notice: "Sprint atualizado com sucesso!"
      end
    else
      render :edit, locals: {:@project => params[:project].to_i}
    end
  end

  def destroy
    @sprint = Sprint.find(params[:id])
    if @sprint.destroy
      redirect_to project_path(params[:project]), notice: "Sprint deletado com sucesso!"
    else
      redirect_to project_path(params[:project]), notice: "Erro ao deletar o Sprint..."
    end
  end


  private

  def sprint_params # Coloca os parametros que vao ser utilizados. Evita parametros indesejados
    params.require(:sprint).permit(:id, :description, :semester, :inicio, :fim,
                                  :pontos_cadastrados, :pontos_atualizados)
  end

  def verify_dates
    inicio_params = params[:sprint][:inicio]
    fim_params = params[:sprint][:fim]

    # Verification if exist any registry with same datas
    unless inicio_params.blank?
      if Sprint.where("(inicio <= ? AND fim >= ?)",
                      Date.parse(inicio_params),
                      Date.parse(inicio_params)).exists?
        @sprint.errors.add(:inicio, "é inválido. Já existe uma Sprint em andamento
                                     entre esse período de tempo (#{inicio_params}).")
      end

      if Sprint.where("(inicio >= ? AND fim >= ?) AND
                       (inicio <= ? AND fim <= ?)",
                      Date.parse(inicio_params),
                      Date.parse(inicio_params),
                      Date.parse(fim_params),
                      Date.parse(fim_params)).exists?
        @sprint.errors.add(:inicio, "é inválido. Já existe uma Sprint em andamento
                                     entre esse período de tempo (#{inicio_params}).")
        @sprint.errors.add(:fim, "é inválido. Já existe uma Sprint em andamento
                                  entre esse período de tempo (#{fim_params}).")
      end
    end

    if Sprint.where("(inicio <= ? AND fim >= ?)",
                    Date.parse(fim_params),
                    Date.parse(fim_params)).exists?
      @sprint.errors.add(:fim, "é inválido. Já existe uma Sprint em andamento
                                entre esse período de tempo (#{fim_params}).")
    end

  end

  def create_weeks_dynamically
    # Generate the Weeks dynamically
    start_s = @sprint.inicio
    end_s = @sprint.fim

    while(start_s < end_s)
      difference = start_s.wday == 1 ? 4 : 1.week - 1.day
      Week.create(
        description: Week.last.present? ?
                     "Semana #{Week.where(sprint_id: @sprint.id).count + 1}" :
                     "Semana 1",
        start_w: start_s,
        end_w: start_s + difference,
        expected_hours: 15,
        sprint_id: @sprint.id
        )
      start_s += 1.week
    end
  end

  def update_weeks_dynamically(last_end)
    # Generate the Weeks dynamically
    last_end_s = last_end
    new_end_s = @sprint.fim

    while(last_end_s < new_end_s)
      difference = last_end_s.wday == 1 ? 4 : 1.week - 1.day
      Week.create(
        description: "Semana #{Week.where(sprint_id: @sprint.id).count + 1}",
        start_w: last_end_s,
        end_w: last_end_s + difference,
        expected_hours: 15,
        sprint_id: @sprint.id
        )
      last_end_s += 1.week
    end
  end

end
