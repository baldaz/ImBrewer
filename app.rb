#!/usr/bin/env ruby

require "sinatra"
require "sinatra/activerecord"
require "sinatra/contrib"
require "sinatra/json"
require "json"
require "./environments"
require_relative "lib/calculations/bitterness"

class Hops < ActiveRecord::Base
end
class Styles < ActiveRecord::Base
end
class Recipe < ActiveRecord::Base
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

  def recipe_JSON
    @recipe = Recipe.order("IdRicetta ASC")
    json :@recipe
  end
end

get "/" do
  erb :"home/index"
end

get "/ingredients" do
  @hops = Hops.order("name ASC")
  erb :"ingredients/index"
end

get "/json/hops", :provides => :json do
  @hops_res = Hops.order("name ASC").to_json
  erb :"json/hops", :layout => false
end

get "/recipes" do
  @recipe = Recipe.order("IdRicetta ASC")
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
  hop_grams = params[:hop_grams].to_f
  alpha_acid_percentage = params[:alpha_acid].to_f
  boil_time = params[:boil_time].to_i
  batch_liters = params[:batch_size].to_f
  original_gravity = params[:og].to_f
  final_gravity = params[:fg].to_f

  btns = Bitterness.new(hop_grams, boil_time, alpha_acid_percentage, batch_liters, original_gravity)
  rg = Rager.new(btns)
  ts = Tinseth.new(btns)
  @output = ((rg.ibu.round(1).to_i / 100) + ts.ibu.round(1).to_i) / 2
  erb :"calculations/_ibu_result", :layout => false
end

get "/calculations/plato" do
  o_gravity = params[:og].to_f;
  @output = (((o_gravity - 1000) / o_gravity) * 261).to_i
  erb :"calculations/_ibu_result", :layout => false
end
