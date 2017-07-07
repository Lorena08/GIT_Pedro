class TeamUsersController < ApplicationController

  load_and_authorize_resource

  def edit_multiple
    @team = Team.find(params[:team_id])
  end

  def update_multiple
    @users = User.where(id: params[:users_id]).ids
    @team = Team.find(params[:team_id])

    # Atualiza as relações entre o Team e o User
    @team.team_users.each do |team_user|
      @id = @users.sample
      if @id.blank?
        team_user.destroy
      else
        team_user.update_attribute("user_id", @id)
      end
      @users.delete(@id)
    end

    # Verifica se sobrou Users. Se sobrou, cadastra-os fazendo relação
    # com a equipe
    unless @users.blank?
      @users.each do |user|
        TeamUser.create!(
          team_id: @team.id,
          user_id: user
          )
      end
    end

    redirect_to team_path(@team), notice: 'Registro atualizado com sucesso'
  end
end
