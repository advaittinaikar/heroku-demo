require "sinatra"
require 'active_support/all'
require "active_support/core_ext"
require 'json'
require 'sinatra/activerecord'
require 'haml'
require 'builder'
# require models 
require_relative './models/list'
require_relative './models/task'

require 'twilio-ruby'
# ----------------------------------------------------------------------

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end


# require any models 
# you add to the folder
# using the following syntax:
# require_relative './models/<model_name>'


# enable sessions for this project
enable :sessions

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get '/' do
  "My Great Application".to_s
end


get '/tasks', :provides => [:html, :json, :xml] do
  
  #Task.all.to_json
  @tasks = Task.all
  #
  # respond_to do |f|
  #   f.xml { @tasks.to_xml }
  #   f.on( 'text/json' ) { @tasks.to_json }
  #   f.on( 'text/html' ) { "wooops" }
  #   f.on( 'application/json' ) { @tasks.to_json }
  #   #f.on('*/*') {  Task.all.map{ |t| t.to_s }.to_s }
  #   f.on('*/*') { haml :'tasks/index' }
  # end

  # respond_to do |f|
  #     f.xml { @tasks.to_xml }
  #     f.on( 'text/json' ) { @tasks.to_json }
  #     #f.on( 'text/html' ) { "wooops" }
  #     f.on( 'application/json' ) { @tasks.to_json }
  #     #f.on('*/*') {  Task.all.map{ |t| t.to_s }.to_s }
  #     f.on('*/*') { haml :'tasks/index' }
  #
  # end
 
  @tasks.to_json
end
 
get '/tasks/:id' do
  Task.where(id: params['id']).first.to_json
end
 
# curl -X POST -F 'name=test' -F 'list_id=1' http://localhost:9393/tasks
 
post '/tasks' do
  task = Task.new(params)
 
  if task.save
    task.to_json
  else
    halt 422, task.errors.full_messages.to_json
  end
end
 
# curl -X PUT -F 'name=updates' -F 'list_id=1' http://localhost:9393/tasks/1
 
put '/tasks/:id' do
  task = Task.where(id: params['id']).first
 
  if task
    task.name = params['name'] if params.has_key?('name')
    task.is_completed = params['is_completed'] if params.has_key?('is_completed')
    
    if task.save
      task.to_json
    else
      halt 422, task.errors.full_messages.to_json
    end
  end
end
 
delete '/tasks/:id' do
  task = Task.where(id: params['id'])
 
  if task.destroy_all
    {success: "ok"}.to_json
  else
    halt 500
  end
end




get '/lists' do
  List.all.to_json(include: :tasks)
end
 
get '/lists/:id' do
  List.where(id: params['id']).first.to_json(include: :tasks)
  
  # my_list = List.where(id: params['id']).first
  # my_list.tasks
  #
  # my_task = Task.where(id: params['id']).first
  # my_task.list
  
  
end
 
post '/lists' do
  list = List.new(params)
 
  if list.save
    list.to_json(include: :tasks)
  else
    halt 422, list.errors.full_messages.to_json
  end
end
 
put '/lists/:id' do
  list = List.where(id: params['id']).first
 
  if list
    list.name = params['name'] if params.has_key?('name')
 
    if list.save
      list.to_json
    else
      halt 422, list.errors.full_messages.to_json
    end
  end
end
 
delete '/lists/:id' do
  list = List.where(id: params['id'])
 
  if list.destroy_all
    {success: "ok"}.to_json
  else
    halt 500
  end
end
# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------


error 401 do 
  "Why is this happening!!!"
end


# ----------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# ----------------------------------------------------------------------

private

# for example 
def square_of int
  int * int
end