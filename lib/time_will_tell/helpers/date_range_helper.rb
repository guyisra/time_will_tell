module TimeWillTell
  module Helpers
    module DateRangeHelper

      def date_range(from_date, to_date, options = {})
        format    = options.fetch(:format, :short)
        scope     = options.fetch(:scope, 'time_will_tell.date_range')
        separator = options.fetch(:separator, '—')
        no_year = options.fetch(:no_year, false)

        month_names = format.to_sym == :short ? I18n.t("date.abbr_month_names") : I18n.t("date.month_names")

        from_date, to_date = to_date, from_date if from_date > to_date
        from_day   = from_date.day
        from_month = month_names[from_date.month]
        from_year  = from_date.year
        to_day     = to_date.day

        dates = { from_day: from_day, sep: separator }

        if from_date == to_date
          if no_year
            template = :same_date_no_year
            dates.merge!(month: from_month)
          else
            template = :same_date
            dates.merge!(month: from_month, year: from_year)
          end
        elsif from_date.month == to_date.month && from_date.year == to_date.year
          if no_year
            template = :same_month_no_year
            dates.merge!(to_day: to_day, month: from_month)
          else
            template = :same_month
            dates.merge!(to_day: to_day, month: from_month, year: from_year)
          end
        else
          to_month = month_names[to_date.month]

          dates.merge!(from_month: from_month, to_month: to_month, to_day: to_day)

          if from_date.year == to_date.year
            if no_year
              template = :no_year_wanted
            else
              template = :different_months_same_year
              dates.merge!(year: from_year)
            end
          else
            to_year = to_date.year

            template = :different_years
            dates.merge!(from_year: from_year, to_year: to_year)
          end
        end

        I18n.t("#{scope}.#{template}", dates)
      end

    end
  end
end
