class UserProfileController < ApplicationController

  load_and_authorize_resource

  def index
    @users = UserProfile.order(:name).page(params[:page]).per(15)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @user.build_user_profile
  end

  def create
    @user = User.new(user_params)
    @user_created = @user.user_profile.name

    if @user.save
      redirect_to user_profile_path(@user), notice: "Usuário [#{@user_created}] criado com sucesso!"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_profile_path(@user), notice: "Usuário [#{@user.user_profile.name}] atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user_deleted = @user.user_profile.name

    if @user.destroy
      redirect_to user_profile_index_path, notice: "Usuário [#{@user_deleted}] deletado com sucesso!"
    else
      redirect_to user_profile_index_path, notice: "Erro ao deletar o usuário [#{@user_deleted}]..."
    end
  end

  private
  def user_params
    params.require(:user).permit(:id, :email, :password, :password_confirmation,
                                 user_profile_attributes: [:id, :name, :student_number, :picture, :role])
  end
end
