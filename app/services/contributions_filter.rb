class ContributionsFilter
  
  def initialize
    @sort_by = { date: APP_CONSTANTS.contribution.sort.date, 
                  check_num: APP_CONSTANTS.contribution.sort.check_num, 
                  amount: APP_CONSTANTS.contribution.sort.amount, 
                  organization: APP_CONSTANTS.contribution.sort.organization 
                }
    @sort_direction = { up: APP_CONSTANTS.contribution.sort_direction.up, 
                        down: APP_CONSTANTS.contribution.sort_direction.down 
                      }
  end

  def process_request(contributions, sort, dir)
    if sort == @sort_by[:check_num]
      if dir == @sort_direction[:down]
        results = contributions.sort_check_num_down
      else
        results = contributions.sort_check_num_up
      end 
    elsif sort == @sort_by[:amount]
      if dir == @sort_direction[:down]
        results = contributions.sort_amt_down
      else
        results = contributions.sort_amt_up
      end 
    elsif sort == @sort_by[:organization]
      if dir == @sort_direction[:down]
        results = contributions.sort_organization_down
      else
        results = contributions.sort_organization_up
      end 
    else 
      # default sort is by name
      if dir == @sort_direction[:down]
        results = contributions.sort_date_down
      else
        results = contributions.sort_date_up
      end
    end  
    return results
  end

end