module ForemanPatch
  module CalendarHelper

    def calendar(range, &block)
      stylesheet 'foreman_patch/calendar'

      content_tag :div, class: 'calendar' do
        content_tag :table, class: 'table table-bordered table-fixed' do
          concat calendar_header
          concat calendar_body(range, &block)
        end
      end
    end

    def calendar_header
      content_tag :thead do
        content_tag :tr do
          Date::DAYNAMES.map { |day| content_tag :th, _(day) }.join(' ').html_safe
        end
      end
    end

    def calendar_body(range, &block)
      content_tag :tbody do
        concat each_weekday(range, &block)
      end
    end

    def each_weekday(range, &block)
      each_week(range) do |week|
        week.map do |day|
          content_tag :td, id: day.strftime('%Y%m%d'), class: day_css_classes(day, range.include?(day)) do
            concat content_tag(:h6, (day.day == 1) ? day.strftime('%b %-d') : day.strftime('%-d'))
            concat content_tag(:div, capture(day, &block), class: 'day')
          end
        end.join(' ').html_safe
      end
    end

    def each_week(range, &block)
      start = range.first.beginning_of_week(:sunday)
      stop = range.last.end_of_week(:sunday)

      (start..stop).each_slice(7).map do |week|
        content_tag :tr, capture(week, &block), class: week_css_classes(week)
      end.join(' ').html_safe
    end

    def week_css_classes(week)
      classes = ['week']
      classes << 'current-week' if week.include? Date.current

      classes
    end

    def day_css_classes(day, enabled = true)
      today = Date.current

      classes = ['day']
      classes << "wday-#{day.wday}"
      classes << 'today' if today == day
      classes << 'past' if today > day
      classes << 'future' if today < day

      if enabled
        classes << 'enabled'
      else
        classes << 'disabled'
      end

      classes
    end

    def calendar_object()
      first = startDate.beginningOfWeek(:sunday)
    end

  end
end
