class ColorsController < ApplicationController

  before_action :set_color, only: [:show, :edit, :update, :destroy]
  # Erro da gem Cancan (ActiveModel::ForbiddenAttributesError)
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  load_and_authorize_resource

  def index
    @colors = Color.all.order(created_at: :desc).page(params[:page]).per(15)
  end

  def show
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)
    if @color.save
      redirect_to colors_path, notice: "Cor criada com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @color.update(color_params)
      redirect_to colors_path, notice: "Cor atualizada com sucesso!"
    else
      render :new
    end
  end

  def destroy
    if @color.destroy
      redirect_to colors_path, notice: "Cor excluída com sucesso!"
    end
  end

  private

  def set_color
    @color = Color.find(params[:id])
  end

  def color_params
    params.require(:color).permit(:id, :description)
  end

end
