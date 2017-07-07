class LabelsController < ApplicationController

  before_action :set_label, only: [:edit, :update, :destroy]
  # Erro da gem Cancan (ActiveModel::ForbiddenAttributesError)
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  load_and_authorize_resource

  def index
    @labels = Label.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to labels_path, notice: "Rótulo criada com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: "Rótulo atualizada com sucesso!"
    else
      render :new
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_path, notice: "Rótulo excluída com sucesso!"
    end
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:id, :description, :color_id)
  end

end
