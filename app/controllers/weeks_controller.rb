class WeeksController < ApplicationController
  def edit
    @week = Week.find(params[:id])
    @project = params[:project]
    @hours_registry = HoursRegistry.find(params[:hours_registry])
  end

  def update
    @week = Week.find(params[:id])

    if @week.update(week_params)
        hr = HoursRegistry.find(params[:hours_registry][:id])
        hr.hours_performed = params[:hours_registry][:hours_performed].to_f
        hr.save!
        redirect_to sprint_path(@week.sprint, project: params[:project]),
                    notice: 'Semana atualizada com sucesso'
    else
      render :edit
    end
  end

  protected

  def week_params
      params.require(:week).permit(:id, :expected_hours)
  end
end
