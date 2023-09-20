module ApplicationHelper

  def get_select_options_for_organization_types(foundation)
    foundation.organization_types.sort_code_up.collect{
      |p| [ 
        "#{p.code} - #{truncate(p.description, 9)}", 
        p.id 
      ]
    }
  end

  def truncate(string, max)
    string.length > max ? "#{string[0...max]}..." : string
  end

  def get_id(model)
    model.id.nil? ? -1 : model.id
  end

end
