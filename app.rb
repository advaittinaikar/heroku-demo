require "sinatra"
require 'rake'
require 'active_support/all'
require "active_support/core_ext"
require 'json'
require 'sinatra/activerecord'
require 'haml'
require 'twilio-ruby'
require 'httparty'
require 'builder'

# require models 
require_relative './models/PersonalDetail'
require_relative './models/Schedule'


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

behance_profile = HTTParty.get("https://api.behance.net/v2/users/advait-tinaikar?client_id=3ck8ZeGDIorykMa8qj4Jo17L89E93zua")
behance_projects = HTTParty.get("https://api.behance.net/v2/users/advait-tinaikar/projects?client_id=3ck8ZeGDIorykMa8qj4Jo17L89E93zua")

user=behance_profile["user"]

@all_personal_details=PersonalDetail.all
@entire_schedule=Schedule.all
# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get '/' do
  "My Great Application".to_s
  profile_name="#{user["first_name"]}"
end

get '/incoming_sms' do

  sender = params[:From]
  body = params[:Body]
  body = body.downcase
  media=nil

  if body == "where is advait"

    message = "He's in #{user["city"]}, #{user["state"]}"

  elsif body == "what is the weather like there"

    message = "It's damn cold there!"

  elsif body == "where has he studied"

    message = where_studied

  elsif body == "how many classes does he have this week"

    message = classes_this_week

  elsif body == "how many classes did he have last week"

    message = classes_last_week

  elsif body == "how many assignments does he have this week"

    message = assignments_this_week

  elsif body == "how many assignments did he have this week"

    message = assignments_last_week  

  elsif body == "show me advait's portfolio"

    message = "It is available on behance. His username is #{user["username"]}."

  elsif body == "show me his behance profile details"

    message = behance_profile

  else

    message = "Hi there. You can know these things about Advait: his location, the weather there, his work and education details!"

  end

  twiml=Twilio::TwiML::Response.new do |resp|
    resp.Message do |r|
      r.Body message
      unless media.nil?
        r.Media media
      end
    end
  end
  # content_type 'text/xml'

  twiml.text
end


get '/personal-details', :provides => [:html, :json, :xml] do
  
  #Task.all.to_json
  @personal = PersonalDetail.all
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
 
  @personal.to_json
end
 
get '/personal-details/:id' do
  PersonalDetail.where(id: params['id']).first.to_json
end

def behance_profile
  link = user["url"]
  media = user["images"]["138"]
  message="Here's a link to his behance profile: #{link}"
  return message
end

def where_studied
  message="He has done his "

  all_personal_details do |p|

    if p.category == "education"
      message += "#{p.qualification} at #{p.institution} and"
    end

  end

  return message
end

def classes_this_week
  message="He has "

  entire_schedule do |e|
    message += "#{e.number_of_classes} this week. They are #{lectures}."
    return message
  end
end

def classes_last_week
  message="He had "

  entire_schedule do |e|
    message += "#{e.number_of_classes} this week. They are #{lectures}."
  end
end

def assignments_this_week

  message="He has "

  e=entire_schedule[0]
  message += "#{e.number_of_assignments} this week. They are #{assignments}."
  return message

end

def assignments_last_week

  message="He had "

  e=entire_schedule[1]
  message += "#{e.number_of_assignments} last week. They were #{assignments}."
  return message
  
end
 
# # curl -X POST -F 'name=test' -F 'list_id=1' http://localhost:9393/personal-details
 
# post '/personal-details' do
#   personal-details = PersonalDetail.new(params)
 
#   if task.save
#     task.to_json
#   else
#     halt 422, task.errors.full_messages.to_json
#   end
# end
 
# # curl -X PUT -F 'name=updates' -F 'list_id=1' http://localhost:9393/personal-details/1
 
# put '/personal-details/:id' do
#   task = PersonalDetail.where(id: params['id']).first
 
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
 
# delete '/personal-details/:id' do
#   task = PersonalDetail.where(id: params['id'])
 
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

