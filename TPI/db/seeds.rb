# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'consultant@gmail.com', password: '123456')
User.create(email: 'assistant@gmail.com', password: '123456', role: 'assistant')
User.create(email: 'administrator@gmail.com', password: '123456', role: 'admin')

Professional.create(name: 'Jose')
Professional.create(name: 'Maria')
Professional.create(name: 'Alfredo')

Appointment.create(professional_id: 1, name: 'Hernan', surname: 'Lopez', phone: 12345567, date: DateTime.strptime("12/21/2021 14:15", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 1, name: 'Carla', surname: 'Simoni', phone: 12343367, date: DateTime.strptime("12/21/2021 10:15", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 1, name: 'Tomas', surname: 'Ramirez', phone: 12312567, date: DateTime.strptime("12/22/2021 15:00", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 2, name: 'Cristian', surname: 'Sanchez', phone: 12895567, date: DateTime.strptime("12/22/2021 14:45", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 2, name: 'Lucia', surname: 'Pietro', phone: 12345556, date: DateTime.strptime("12/27/2021 11:30", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 3, name: 'Ana', surname: 'Ortega', phone: 12387967, date: DateTime.strptime("12/27/2021 14:15", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 3, name: 'Ulises', surname: 'Gonzalez', phone: 12445567, date: DateTime.strptime("12/28/2021 09:00", "%m/%d/%Y %H:%M"))
Appointment.create(professional_id: 3, name: 'Fernando', surname: 'Rossi', phone: 89655567, date: DateTime.strptime("12/29/2021 13:30", "%m/%d/%Y %H:%M"))