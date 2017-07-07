module ApplicationHelper

  def aside_bar_active(controller)
    if params[:controller] == controller
      "active"
    else
      ""
    end
  end

  def aside_bar_content_active?()
    if ['sprints', 'colors', 'labels', 'statuses', 'activities'].include? params[:controller]
      "asidebar-content-active"
    else
      "asidebar-content"
    end
  end

  def aside_bar_dropdown_active()
    if ['sprints', 'colors', 'labels', 'statuses', 'activities'].include? params[:controller]
      "active"
    else
      ""
    end
  end

  def current_user_total?
    current_user.user_profile.role == 'Total' ? true : false
  end

  def time_diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    return "#{hours.to_s.rjust(2, '0')}h
            #{minutes.to_s.rjust(2, '0')}m
            #{seconds.to_s.rjust(2, '0')}s"
  end
end
