#!/usr/bin/env ruby

# require 'rubygems'
# require 'bundler/setup'
# require "sinatra"
require "sinatra/base"
require "sinatra/assetpack"
require "sinatra/activerecord"
require "sinatra/contrib"
# require "sinatra/json"
# require "json"
# require "less"
require 'slim'
require "./environments"
require_relative "lib/calculations/bitterness"

class Hops < ActiveRecord::Base
end
class Styles < ActiveRecord::Base
end
class Recipe < ActiveRecord::Base
end

class App < Sinatra::Base
  set :root, File.dirname(__FILE__) # You must set app root
  register Sinatra::AssetPack
  assets do
    css_dir = 'public/css'
    js_dir = 'public/js'

    serve '/js',  :from => js_dir        # Default
    serve '/css', :from => css_dir       # Default

    css :application, [
      # '/css/bootstrap.min.css',
      '/css/styles.css'
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :less   # :simple | :sass | :yui | :sqwish
  end

  helpers do
    def tab(value)
      @page = value
    end

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

  after { ActiveRecord::Base.connection.close } # close db connection after every request, solve 5000 ms issue connection

  get "/" do
    tab('home')
    @crcp = Recipe.count
    @chps = Hops.count
    # erb :"home/index"
    slim :"home/index"
  end

  get "/ingredients" do
    tab('ingredients')
    @hops = Hops.order("name ASC")
    slim :"ingredients/index"
  end

  post "/json/hops", :provides => :json do
    Hops.order("name ASC").to_json
  end

  get "/recipes" do
    tab('recipes')
    @recipe = Recipe.order("id ASC")
    slim :"recipes/index"
  end

  post "/recipes" do
  end

  post "/recipes/:id", :provides => :json do
    id = params[:id]
    Recipe.find(id).to_json
  end

  get "/styles" do
    tab('styles')
    @styles = Styles.order("name ASC")
    slim :"styles/index"
  end

  get "/calculations" do
    tab('calculations')
    @styles = Styles.order("name ASC")
    @hops = Hops.order("name ASC")
    @recipe = Recipe.order("id ASC")
    slim :"calculations/index"
  end

  post "/calculations/ibu", :provides => :json do
    hop_grams = params[:hop_grams].to_f
    alpha_acid_percentage = params[:alpha_acid].to_f
    boil_time = params[:boil_time].to_i
    batch_liters = params[:batch_size].to_f
    original_gravity = params[:og].to_f
    final_gravity = params[:fg].to_f

    btns = Bitterness.new(hop_grams, boil_time, alpha_acid_percentage, batch_liters, original_gravity)
    rg = Rager.new(btns)
    ts = Tinseth.new(btns)
    output = ((rg.ibu.round(1).to_i / 100) + ts.ibu.round(1).to_i) / 2
    output.to_json # rack error status > 100 as integer
  end

end
