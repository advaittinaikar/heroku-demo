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

personal_details = PersonalDetail.all
entire_schedule = Schedule.all
# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get '/' do
  "This application has been made by #{user["first_name"]} #{user["last_name"]}!"
end

get '/incoming_sms' do

  sender = params[:From]
  body = params[:Body]
  body = body.downcase
  message=""
  media=nil

  if body == "where is advait"

    message = "He's in #{user["city"]}, #{user["state"]}."

  elsif body == "what is the weather like there"

    message = "It's damn cold there!"

  elsif body.include? "studied"
    
    message = where_studied personal_details

  elsif body.include? "worked"

    message = where_worked personal_details

  elsif body == "how many classes does he have this week"

    message = classes_this_week entire_schedule

  elsif body == "how many classes did he have last week"

    message = classes_last_week entire_schedule

  elsif body == "how many assignments does he have this week"

    message = assignments_this_week entire_schedule

  elsif body == "how many assignments did he have last week"

    message = assignments_last_week entire_schedule

  elsif body.include? "portfolio"

    link = behance_profile user
    message = "It is available on behance at the following link: " + link
    media = user["images"]["138"]

  else

    message = "Hi there. I'm Advait's chatbot. You're asking something I don't know. However I do know where he is. I also know where he's studied and worked as well as his schedule."

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
  
  PersonalDetail.all.to_json
 
end
 
get '/personal-details/:id' do

  PersonalDetail.where(id: params['id']).first.to_json

end

get '/schedule', :provides => [:html, :json, :xml] do
  
  Schedule.all.to_json
 
end
 
get '/schedule/:id' do

  Schedule.where(id: params['id']).first.to_json

end

def behance_profile user

  link = user["url"]
  message="Here's a link to his behance profile: #{link}"
  return message

end

def where_studied details
  message="He has done his "

    details.each do |t|

      if t["category"] == "Education"
        message += "#{t.qualification} at #{t.institution},"
      end
      
    end

  return message
end

def where_worked details
  message="He has worked "

    details.each do |t|

      if t["category"] == "Job"
        message += "as a #{t.qualification} at #{t.institution}"
      end
      
    end

  return message
end

def classes_this_week schedule
  message="He has "

  e=schedule[0]
  message += "#{e.number_of_classes} this week. They are #{e.lectures}."
  
  end
end

def classes_last_week schedule
  message="He had "

  e=schedule[1]
  message += "#{e.number_of_classes} this week. They are #{e.lectures}."
  
end

def assignments_this_week schedule

  message="He has "

  e=schedule[0]
  message += "#{e.number_of_assignments} this week. They are #{e.assignments}."
  return message

end

def assignments_last_week

  message="He had "

  e=schedule[1]
  message += "#{e.number_of_assignments} last week. They were #{e.assignments}."
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

