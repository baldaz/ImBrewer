#!/usr/bin/env ruby

class Rager
  
  def initialize
  end

  def ibu(hop_grams, util_percentage, alpha_acid_percentage, batch_liters, adjustment)
    ((hop_grams * util_percentage * alpha_acid_percentage * 1000) /
            (batch_liters * (1 + adjustment)))
  end

  def util_percentage(minutes)
    18.11 + 13.86 * Math.tanh((minutes - 31.32) / 18.27)
  end
  
  def adjustment_factor(boil_gravity)
    if boil_gravity > 1050
      (boil_gravity - 1050) / 0.2
    else
      0
    end
  end
  
end

class Tinseth

  def initialize
  end

  def ibu(alpha_acid_utilization, mg_alpha_acids)
    alpha_acid_utilization * mg_alpha_acids
  end

  def mg_alpha_acids(alpha_acid, hop_grams, batch_liters)
    alpha_acid * hop_grams * 1000 / batch_liters
  end

  def alpha_acid_utilization(bigness_factor, boil_time_factor)
    bigness_factor * boil_time_factor
  end

  def bigness_factor(wort_gravity)
    1.65 * 0.000125 ** (wort_gravity.to_f - 1.0)
  end

  def boil_time_factor(time)
    1 - Math.exp((-0.04 * time.to_f) / 4.15)
  end
end

