module SprintsHelper

  def weeks_of_sprint(sprint)

    start_s = sprint.inicio
    end_s = sprint.fim
    weeks = []
    date = start_s

    while date <= end_s

      if weeks.blank? && date.beginning_of_week <= date &&
         date.end_of_week <= end_s
        weeks.push([date, date.end_of_week - 2])
        date = date.next_week
        next
      end

      if weeks.blank? && date.beginning_of_week < date &&
         date.end_of_week > end_s
        weeks.push([date, end_s])
        date = date.next_week
        next
      end

      if !weeks.blank? && date.end_of_week <= end_s
        weeks.push([date.beginning_of_week, date.end_of_week - 2])
        date = date.next_week
        next
      end

      if !weeks.blank? && date.end_of_week > end_s
        weeks.push([date.beginning_of_week, end_s])
        date = date.next_week
        next
      end
    end

    return weeks
  end
end
