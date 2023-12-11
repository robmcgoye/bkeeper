class Fdn::Reporting::ReportsController < Fdn::BaseController

  def dashboard
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "dashboard")
    ]    
  end

  def organization_list
    set_organization_filter_params
    @organizations = OrganizationsFilter.new.process_request(@foundation.organizations, @query, @by, (@dir == 1 ? @dir = 2 : @dir = 1))
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(template: "fdn/reporting/reports/organization_list", formats: [:html], layout: "pdf"),
      # margin: { top: 10, bottom: 10, left: 10, right: 10 }, 
      header: { content: render_to_string(template: "shared/pdf/header", 
                  formats: [:html], 
                  layout: "pdf_section", 
                  locals: { title: "Organization List" })
              },
      footer: { content: render_to_string(template: "shared/pdf/footer", 
                  formats: [:html], 
                  layout: "pdf_section") 
                  # right: "[page] of [topage]" 
              }
    )
    send_data(pdf, filename: "organization_list", type: "application/pdf", disposition: :inline)  
  end

  def commitment
    # @organizations = @foundation.organizations
    commitment_report_form = CommitmentReportForm.new(commitment_params)
    # binding.break
    if commitment_report_form.state == "open" && commitment_report_form.sort == "alpha"
      @commitments = Commitment.organization_commitments(@foundation.organization_ids).not_completed.sort_organization_up
    elsif commitment_report_form.state == "open" && commitment_report_form.sort == "date"
      @commitments = Commitment.organization_commitments(@foundation.organization_ids).not_completed.sort_start_date_up
    elsif commitment_report_form.state == "closed" && commitment_report_form.sort == "date"
      @commitments = Commitment.organization_commitments(@foundation.organization_ids).completed.sort_start_date_up
    else
      @commitments = Commitment.organization_commitments(@foundation.organization_ids).completed.sort_organization_up
    end
    if commitment_report_form.format == "detailed"
      additional_header = nil
      template = "fdn/reporting/reports/commitment_detailed"
      orientation = "Portrait"
    else
      additional_header = "fdn/reporting/reports/commitment_summary_header"
      template = "fdn/reporting/reports/commitment_summary"
      orientation = "Landscape"
    end
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(template: template, formats: [:html], layout: "pdf" ),
      # margin: { top: 10, bottom: 10, left: 10, right: 10 }, 
      header: { content: render_to_string(template: "shared/pdf/header", 
                  formats: [:html], 
                  layout: "pdf_section", 
                  locals: { title: "Commitments", additional_header: additional_header })
              },
      footer: { content: render_to_string(template: "shared/pdf/footer", 
                  formats: [:html], 
                  layout: "pdf_section") 
                  # right: "[page] of [topage]" 
              },
              orientation: orientation
    )
    send_data(pdf, filename: "commitment_report", type: "application/pdf", disposition: :inline)  
  end

  private
  def commitment_params
    params.require(:commitment_report_form).permit(:format, :state, :sort)
  end
end