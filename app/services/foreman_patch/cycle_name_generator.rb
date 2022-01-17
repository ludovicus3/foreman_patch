module ForemanPatch
  class CycleNameGenerator
    REGEX = /%([-_0^#:]*)(\d*)([q])/.freeze

    def self.generate(plan)
      return plan.name if plan.cycle_name.blank?

      generator = new(plan.cycle_name, plan.start_date)
      generator.render
    end

    def self.rename(cycle)
      return if cycle.plan.blank?
      return if cycle.plan.cycle_name.blank?

      generator = new(cycle.plan.cycle_name, cycle.start_date)
      cycle.update(name: generator.render)
    end

    attr_accessor :format, :date

    def initialize(format, date)
      @format = format
      @date = date
    end

    def render
      date.strftime(format.gsub(REGEX, quarter(date)))
    end

    private

    def quarter(date)
      (date.month / 3.0).ceil.to_s
    end

  end
end
