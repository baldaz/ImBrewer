#!/usr/bin/env ruby

class Bitterness

  attr_reader :hop_grams, :time, :aa_percentage, :batch_size, :og, :util, :adjustment

  def initialize(grams, minutes, aa, batch, gravity)
    @hop_grams = grams
    @time = minutes
    @aa_percentage = aa
    @batch_size =  batch
    @og = gravity
    @util = 18.11 + 13.86 * Math.tanh((@time - 31.32) / 18.27)
    @adjustment = (@og - 1050) / 2 unless @og <= 1050 else @adjustment = 0
  end

  def ibu
    if @hop_grams.kind_of?(Array)
      @hop_grams.each_with_index do |grams, index|
        avgibu = (grams * (18.11 + 13.86 * Math.tanh((@time[index] - 31.32) / 18.27)) * @aa_percentage[index] * 10) /
                  (@batch_size * (1 + @adjustment))
        return (avgibu / index) 
    end
    else
      (@hop_grams * @util * @aa_percentage * 10) / (@batch_size * (1 + @adjustment))
    end
  end

end

class Rager < Bitterness

  def initialize(grams, minutes, aa, batch, gravity)
    super
  end

  def ibu
    super
  end

end

class Tinseth < Bitterness

   alias_method :bitterness_ibu, :ibu

  def initialize(grams, minutes, aa, batch, gravity)
    super
    @util = 1
    @adjustment = 0
    @mg_alpha_acid = bitterness_ibu
    @b_factor = 1.65 * (Math.exp(((@og * 0.001) - 1.0) / 0.111))
    @bt_factor = (1 - Math.exp(-0.04 * @time)) / 4.15
  end

  def ibu
    @b_factor * @bt_factor * @mg_alpha_acid
  end

end
