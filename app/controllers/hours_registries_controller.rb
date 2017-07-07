class HoursRegistriesController < ApplicationController

  def login

    # Verificar se existe uma semana em andamento
    if Week.where('start_w <= ? AND end_w >= ?', Date.today, Date.today).present?

      # Se existe algum registro de horas já criada nessa semana em andamento,
      # do usuário corrente e desse projeto selecionado
      if HoursRegistry.where(project_id: params[:id], user_id: current_user.id,
                             week_id: params[:week]).present?

        hr = HoursRegistry.where(project_id: params[:id],
                                 user_id: current_user.id,
                                 week_id: params[:week]).first

        hr.update_attribute(:start_hr, Time.zone.now)

        redirect_to projects_path, notice: 'Logado com sucesso!'
      else

        HoursRegistry.create(
          start_hr: Time.now,
          week_id: params[:week],
          project_id: params[:id],
          user_id: current_user.id
          )
        redirect_to projects_path, notice: 'Logado com sucesso!'
      end
    end
  end

  def logout

    # Se existe algum registro de horas já criada nessa semana em andamento,
    # do usuário corrente e desse projeto selecionado, e se o campo de inicio
    # está em branco. Esperando valor falso.
    unless HoursRegistry.where(project_id: params[:id], user_id: current_user.id,
                               week_id: params[:week]).first.start_hr.blank?

      hr = HoursRegistry.where(project_id: params[:id],
                               user_id: current_user.id,
                               week_id: params[:week]).first

      hr.update_attribute(:end_hr, Time.zone.now)

      if hr.hours_performed.blank?
        hr.hours_performed = hr.end_hr - hr.start_hr
      else
        hr.hours_performed = hr.hours_performed + (hr.end_hr - hr.start_hr)
      end

      hr.start_hr = nil
      hr.end_hr = nil

      hr.save!

      redirect_to projects_path, notice: 'Deslogado com sucesso!'
    end
  end
end
