require "sinatra"
require 'active_support/all'
require "active_support/core_ext"
require 'json'
require 'sinatra/activerecord'
require 'haml'
require 'twilio-ruby'
require 'builder'
require 'twilio-ruby'
require 'httparty'
# require models 
require_relative './models/list'
require_relative './models/task'


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

twilio_client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
behance_client = Behance::Client.new(access_token = ENV['BEHANCE_TOKEN'])

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get '/' do
  "My Great Application".to_s
end

get '/incoming_sms' do

  sender = params[:From]
  body = params[:Body]
  body = body.downcase

  if body == "where is advait"
    message = "He's in Pittsburgh"
  elsif body == "what is the weather like"
    message = "It's sunny outside"
  elsif body == "show me advait's portfolio"
    message = "It is available on behance. His username is advait.tinaikar."
  elsif body == "where is he studying"
    message = "He currently studies at Carnegie Mellon's III."
  elsif body == "show me his behance profile details"
    profile = HTTParty.get("http://www.behance.net/v2/users/advait-tinaikar/projects?client_id=3ck8ZeGDIorykMa8qj4Jo17L89E93zua")
    message = "Find here the link to his profile: <a href=#{profile.user.url}></a>"
  else
    message =  "You can know these things: his location, the weather there, his portfoilio details, college, work"
  end

  twiml=Twilio::TwiML::Response.new do |resp|
    resp.Message message
  end

  content_type 'text/xml'

  twiml.text
end


# get '/tasks', :provides => [:html, :json, :xml] do
  
#   #Task.all.to_json
#   @tasks = Task.all
#   #
#   # respond_to do |f|
#   #   f.xml { @tasks.to_xml }
#   #   f.on( 'text/json' ) { @tasks.to_json }
#   #   f.on( 'text/html' ) { "wooops" }
#   #   f.on( 'application/json' ) { @tasks.to_json }
#   #   #f.on('*/*') {  Task.all.map{ |t| t.to_s }.to_s }
#   #   f.on('*/*') { haml :'tasks/index' }
#   # end

#   # respond_to do |f|
#   #     f.xml { @tasks.to_xml }
#   #     f.on( 'text/json' ) { @tasks.to_json }
#   #     #f.on( 'text/html' ) { "wooops" }
#   #     f.on( 'application/json' ) { @tasks.to_json }
#   #     #f.on('*/*') {  Task.all.map{ |t| t.to_s }.to_s }
#   #     f.on('*/*') { haml :'tasks/index' }
#   #
#   # end
 
#   @tasks.to_json
# end
 
# get '/tasks/:id' do
#   Task.where(id: params['id']).first.to_json
# end
 
# # curl -X POST -F 'name=test' -F 'list_id=1' http://localhost:9393/tasks
 
# post '/tasks' do
#   task = Task.new(params)
 
#   if task.save
#     task.to_json
#   else
#     halt 422, task.errors.full_messages.to_json
#   end
# end
 
# # curl -X PUT -F 'name=updates' -F 'list_id=1' http://localhost:9393/tasks/1
 
# put '/tasks/:id' do
#   task = Task.where(id: params['id']).first
 
#   if task
#     task.name = params['name'] if params.has_key?('name')
#     task.is_completed = params['is_completed'] if params.has_key?('is_completed')
    
#     if task.save
#       task.to_json
#     else
#       halt 422, task.errors.full_messages.to_json
#     end
#   end
# end
 
# delete '/tasks/:id' do
#   task = Task.where(id: params['id'])
 
#   if task.destroy_all
#     {success: "ok"}.to_json
#   else
#     halt 500
#   end
# end

# get '/lists' do
#   List.all.to_json(include: :tasks)
# end
 
# get '/lists/:id' do
#   List.where(id: params['id']).first.to_json(include: :tasks)
  
#   # my_list = List.where(id: params['id']).first
#   # my_list.tasks
#   #
#   # my_task = Task.where(id: params['id']).first
#   # my_task.list
  
  
# end
 
# post '/lists' do
#   list = List.new(params)
 
#   if list.save
#     list.to_json(include: :tasks)
#   else
#     halt 422, list.errors.full_messages.to_json
#   end
# end
 
# put '/lists/:id' do
#   list = List.where(id: params['id']).first
 
#   if list
#     list.name = params['name'] if params.has_key?('name')
 
#     if list.save
#       list.to_json
#     else
#       halt 422, list.errors.full_messages.to_json
#     end
#   end
# end
 
# delete '/lists/:id' do
#   list = List.where(id: params['id'])
 
#   if list.destroy_all
#     {success: "ok"}.to_json
#   else
#     halt 500
#   end
# end
# # ----------------------------------------------------------------------
# #     ERRORS
# # ----------------------------------------------------------------------


# error 401 do 
#   "Why is this happening!!!"
# end


# # ----------------------------------------------------------------------
# #   METHODS
# #   Add any custom methods below
# # ----------------------------------------------------------------------

# private

# # for example 
# def square_of int
#   int * int
# end