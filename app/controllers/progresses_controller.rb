class ProgressesController < ApplicationController

  def index
    @project = Project.find(params[:project])
  end

  def new
    @progress = Progress.new
    @project = Project.find(params[:project])
    @completeness = 0
    MacroActivity.where(project_id: @project.id).each do |ma|
      @completeness += ma.completeness.to_f
    end
    @completeness = @completeness / MacroActivity.where(project_id: @project.id).count
    @advance = @project.progresses.last.completeness.to_f - @completeness
  end

  def create
    @progress = Progress.new(progress_params)

    if @progress.save

      # if @progress.project.progresses.where('id < ?', @progress.id).present?
      #   @progress.advance = (@progress.completeness.to_f -
      #                        @progress.project.progresses
      #                        .where('id < ?', @progress.id).last
      #                        .completeness.to_f)
      #                       .round(2)
      #   @progress.save
      # else
      #   @progress.advance = @progress.completeness
      #   @progress.save
      # end

      redirect_to progresses_path(project: @progress.project),
                  notice: 'Nova completude adicionada com sucesso!'
    else
      render :new
    end

  end

  def edit
    @progress = Progress.find(params[:id])
  end

  def update
    @progress = Progress.find(params[:id])

    if @progress.update(progress_params)

      @progress.project.progresses.each do |progress|
        if progress.project.progresses.where('id < ?', progress.id).present?
          progress.advance = (progress.completeness.to_f -
                              progress.project.progresses
                              .where('id < ?', progress.id).last
                              .completeness.to_f)
                             .round(2)
          progress.save
        else
          progress.advance = progress.completeness.to_f
          progress.save
        end
      end

      redirect_to progresses_path(project: @progress.project),
                  notice: 'Completude atualizada com sucesso!'
    else
      render :edit
    end
  end

  def destroy
    @progress = Progress.find(params[:id])
    @project = @progress.project
    if @progress.destroy

      @project.progresses.each do |progress|
        if progress.project.progresses.where('id < ?', progress.id).present?
          progress.advance = (progress.completeness.to_f -
                              progress.project.progresses
                              .where('id < ?', progress.id).last
                              .completeness.to_f)
                             .round(2)
          progress.save
        else
          progress.advance = progress.completeness.to_f
          progress.save
        end
      end

      redirect_to progresses_path(project: @project), notice: 'Progresso excluído com sucesso!'
    else
      redirect_to progresses_path(project: @project), notice: 'Erro ao excluir progresso...'
    end
  end

  def graphic
    @project = Project.find(params[:project])
  end

  def report_pdf
    respond_to do |format|
      format.pdf do
        render pdf: "report #{params[:project_id]}",
               disposition: "inline",
               template: "reports/pdf.html.erb",
               layout: "report_pdf",
               locals: { :@project => Project.find(params[:project_id]) },
               page_size: 'A4',
               javascript_delay: 3000
      end
      format.html do
        render template: "reports/pdf",
               layout: "report_pdf",
               locals: { :@project => Project.find(params[:project_id]) }
       end
    end
  end

  private

  def progress_params
    params.require(:progress).permit(:completeness, :advance, :project_id, :sprint_id)
  end

  # def report_pdf_instance
  #   report = Project.find(params[:project_id])
  #   ReportPdf.new(report)
  # end

  # def send_report_pdf
  #   send_file report_pdf_instance.to_pdf,
  #     filename: report_pdf_instance.filename,
  #     type: "application/pdf",
  #     disposition: "inline"
  # end

end
