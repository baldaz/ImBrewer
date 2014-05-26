#!/usr/bin/env ruby

require "sinatra"
require "sinatra/activerecord"
require "sinatra/contrib"
require "./environments"
require_relative "lib/calculations/bitterness"

class Hops < ActiveRecord::Base
end

class Styles < ActiveRecord::Base
end

helpers do
  def title
    if @title
      "#{@title} -- Brewby"
    else
      "Brewby"
    end
  end

  def ibu_result
    erb :"calculations/_ibu_result"
  end
end

get "/" do
  erb :"home/index"
end

get "/ingredients" do
  @hops = Hops.order("name ASC")
  erb :"ingredients/index"
end

get "/recipes" do
  erb :"recipes/index"
end

get "/styles" do
  @styles = Styles.order("name ASC")
  erb :"styles/index"
end

get "/calculations" do
  @styles = Styles.order("name ASC")
  @hops = Hops.order("name ASC")
  erb :"calculations/index"
end

get "/calculations/ibu" do
  hop_grams = params[:hop_grams]
  alpha_acid_percentage = params[:alpha_acid]
  boil_time = params[:boil_time]
  batch_liters = params[:batch_size]

  rg = Rager.new
  util_percentage = rg.util_percentage(boil_time.to_i)
#  @output = rg.ibu(hop_grams.to_i, util_percentage, alpha_acid_percentage.to_i, batch_liters.to_i, 0)
  ts = Tinseth.new
  b_t_factor = ts.boil_time_factor(boil_time.to_i)
  b_factor = ts.bigness_factor(1050)
  aa_util = ts.alpha_acid_utilization(b_factor, b_t_factor)
  mg_aa = ts.mg_alpha_acids(alpha_acid_percentage.to_i, hop_grams.to_i, batch_liters.to_i)
#  @output = ts.ibu(aa_util, mg_aa)
  @output = b_factor
  erb :"calculations/_ibu_result", :layout => false
end
