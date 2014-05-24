#!/usr/bin/env ruby

require "sinatra"
require "sinatra/activerecord"
require "sinatra/contrib"
require "./environments"

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
