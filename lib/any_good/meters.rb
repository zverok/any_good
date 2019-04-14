class AnyGood
  class Meter < Struct.new(:name, :thresholds, :block)
    def call(data)
      Metric.new(name, value(data), *thresholds)
    end

    private

    attr_reader :data

    def value(data)
      @data = data
      instance_eval(&block)
    rescue NoMethodError
      nil
    ensure
      @data = nil
    end
  end

  class Metric
    attr_reader :value, :name, :color

    def initialize(name, value, *thresholds)
      @name = name
      @value = value
      @color = deduce_color(*thresholds)
    end

    def format
      '%20s: %s' % [name, colorized_value]
    end

    private

    def colorized_value
      Pastel.new.send(color, formatted_value)
    end

    def formatted_value
      case value
      when nil
        '—'
      when String
        value
      when Numeric
        value.to_s.chars.reverse.each_slice(3).to_a.map(&:join).join(',').reverse
      when Date, Time
        diff = TimeMath.measure(value, Time.now)
        unit, num = diff.detect { |_, v| !v.zero? }
        "#{num} #{num == 1 ? unit.to_s.chomp('s') : unit} ago"
      else
        fail ArgumentError, "Unformattable #{value.inspect}"
      end
    end

    def deduce_color(red = nil, yellow = nil)
      return :dark if value.nil?
      return :white if !yellow # no thresholds given

      # special trick to tell "lower is better" from "higher is better" situations
      val = red.is_a?(Numeric) && red < 0 ? -value : value

      if val < red
        :red
      elsif val < yellow
        :yellow
      else
        :green
      end
    end
  end
end
