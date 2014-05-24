#!/usr/bin/env ruby

class Rager
  
  def ibu(hop_grams, util_percentage, alpha_acid_percentage, batch_liters, adjustment)
    ((hop_grams * util_percentage * alpha_acid_percentage * 1000) /
            (batch_liters * (1 + adjustment)))
  end
end
