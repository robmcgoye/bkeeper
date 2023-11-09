class Fdn::Reporting::ReportsController < Fdn::BaseController

  def dashboard
    render turbo_stream: [
      turbo_stream.replace("main_content", partial: "dashboard")
    ]    
  end

  def organization_list
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
                  layout: "pdf_section"), 
                  right: "[page] of [topage]" 
              }
    )
    send_data(pdf, filename: "organization_list", type: "application/pdf", disposition: :inline)  
  end

end