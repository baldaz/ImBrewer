#!/usr/bin/env ruby

class Bitterness

  attr_reader :hop_grams, :time, :aa_percentage, :batch_size, :og

  def initialize(grams, minutes, aa, batch, gravity)
    @hop_grams = grams
    @time = minutes
    @aa_percentage = aa
    @batch_size =  batch
    @og = gravity
  end

end

class Rager

  attr_reader :btns
  attr_writer :util, :adjustment

  def initialize(bitnss)
    @btns = bitnss
    @util = 18.11 + 13.86 * Math.tanh((@btns.time - 31.32) / 18.27)
    @adjustment = (@btns.og - 1050) / 2 unless @btns.og <= 1050 else @adjustment = 0
  end

  def ibu
    ((@btns.hop_grams * @util * @btns.aa_percentage * 10) /
            (@btns.batch_size * (1 + @adjustment)))
  end

end

class Tinseth < Rager

  alias_method :rager_ibu, :ibu

  def initialize(bitnss)
    super(bitnss)
    @util = 1
    @adjustment = 0
    @mg_alpha_acid = rager_ibu
    @b_factor = 1.65 * (Math.exp(((@btns.og * 0.001) - 1.0) / 0.111))
    @bt_factor = (1 - Math.exp(-0.04 * @btns.time)) / 4.15
  end

  def ibu
    @b_factor * @bt_factor * @mg_alpha_acid
  end

end
