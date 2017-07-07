class StatusesController < ApplicationController

  before_action :set_status, only: [:show, :edit, :update, :destroy]

  # Erro da gem Cancan (ActiveModel::ForbiddenAttributesError)
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  load_and_authorize_resource

  def index
    @statuses = Status.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @status = Status.new
  end

  def create
    @status = Status.new(status_params)
    if @status.save
      redirect_to statuses_path, notice: "Status criado com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @status.update(status_params)
      redirect_to statuses_path, notice: "Status atualizado com sucesso!"
    else
      render :new
    end
  end

  def destroy
    if @status.destroy
      redirect_to statuses_path, notice: "Status excluído com sucesso!"
    end
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:id, :description, :color_id)
  end
end
