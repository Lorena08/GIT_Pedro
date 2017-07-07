class ReportPdf

  def initialize(report)
    @report = report
  end

  def to_pdf
    kit = WickedPdf.new(as_html, page_size: 'A4')
    kit.to_file("#{Rails.root}/public/report.pdf")
  end

  def filename
    "report #{report.id}.pdf"
  end

  private

    attr_reader :report

    def as_html
      render template: "reports/pdf", layout: "report_pdf",
             locals: { :@project => report }
    end
end