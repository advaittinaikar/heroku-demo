require 'active_support/all'

PersonalDetail.delete_all
Schedule.delete_all

PersonalDetail.create!([{qualification:"Bachelors",category:"Education",institution:"BITS Pilani Goa",time_period:"2009-2013"}])
PersonalDetail.create!([{qualification:"Masters",category:"Education",institution:"Carnegie Mellon University",time_period:"2016-2017"}])
PersonalDetail.create!([{qualification:"Assistant Manager",category:"Job",institution:"Skoda Auto India",time_period:"2013-2015"}])
PersonalDetail.create!([{qualification:"Product Design Intern",category:"Job",institution:"Upgrad",time_period:"2016"}])

this_week = Time.new(2016,11,14,00,00)

Schedule.create!([{week:this_week,number_of_classes:7,lectures:"Design for Environment,Programming,Visual Processes,User research",number_of_assignments:5,assignments:"Programming, Visual Processes"}])
Schedule.create!([{week:this_week-7.days,number_of_classes:8,lectures:"Design for Environment,Programming,Visual Processes,User research,Career Planning",number_of_assignments:6,assignments:"Design for Environment, Programming, Visual Processes"}])
Schedule.create!([{week:this_week-14.days,number_of_classes:6,lectures:"Design for Environment,Programming,Visual Processes,User research",number_of_assignments:3,assignments:"Programming, Visual Processes"}])
Schedule.create!([{week:this_week-21.days,number_of_classes:7,lectures:"Design for Environment,Programming,Visual Processes,User research,Career Planning",number_of_assignments:4,assignments:"Design for Environment, Programming, Visual Processes"}])
Schedule.create!([{week:this_week-28.days,number_of_classes:5,lectures:"Design for Environment,Programming,Visual Processes,User research,Career Planning",number_of_assignments:4,assignments:"Programming, Visual Processes, User Research"}])