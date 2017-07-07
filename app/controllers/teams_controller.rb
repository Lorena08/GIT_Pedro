class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # Erro da gem Cancan (ActiveModel::ForbiddenAttributesError)
  before_action do
   resource = controller_name.singularize.to_sym
   method = "#{resource}_params"
   params[resource] &&= send(method) if respond_to?(method, true)
  end

  load_and_authorize_resource

  # GET /teams
  # GET /teams.json
  def index
    if current_user_total?
      @teams = Team.order(:description).page(params[:page]).per(5)
    else
      ids = []
      tus = TeamUser.where(user_id: current_user.id)
      tus.each do |tu| # user_id | team_id
        ids << tu.team_id # [1, 6, 7]
      end

      return @teams = Team.where(id: ids).order(:description).page(params[:page]).per(5)
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to team_path(@team), notice: I18n.t('messages.created')
    else
      render :new
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if @team.update(team_params)
      redirect_to team_path, notice: I18n.t('messages.updated')
    else
      render :edit
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy

    if @team.destroy
      redirect_to teams_path, notice: I18n.t('messages.destroyed')
    else
      redirect_to teams_path, notice: "Erro ao excluir..."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:id, :description)
    end
end
