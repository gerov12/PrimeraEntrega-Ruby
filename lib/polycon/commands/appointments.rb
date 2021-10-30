module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          if Polycon::Models::Appointment.correct_date?(date)
            if Polycon::Models::Appointment.later_date?(date)
              prof = Polycon::Models::Professional.find(professional)
              if !prof.nil?
                if Polycon::Models::Appointment.create(prof, date, name, surname, phone, notes)
                  warn "Turno registrado con éxito"
                else
                  warn "Ya hay una cita registrada con el profesional #{professional} para ese turno"
                end
              else
                warn "El profesional #{professional} no existe"
              end
            else
              warn "La fecha ingresada debe ser posterior a la fecha actual"
            end
          else
            warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16 13:00"
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)  
          if Polycon::Models::Appointment.correct_date?(date)
            prof = Polycon::Models::Professional.find(professional)
            if !prof.nil?
              appt = Polycon::Models::Appointment.find(prof, date)
              if !appt.nil?
                puts "Apellido: #{appt.surname}"
                puts "Nombre: #{appt.name}"
                puts "Teléfono: #{appt.phone}"
                puts "Notas: #{appt.notes}" unless appt.notes.nil?
              else
                warn "El profesional #{professional} no tiene una cita registrada para la fecha #{date}"
              end
            else
              warn "El profesional #{professional} no existe"  
            end
          else
            warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16 13:00"
          end
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          if Polycon::Models::Appointment.correct_date?(date)
            if Polycon::Models::Appointment.later_date?(date)
              prof = Polycon::Models::Professional.find(professional)
              if !prof.nil?
                appt = Polycon::Models::Appointment.find(prof, date)
                if !appt.nil?
                  appt.delete()
                  warn "Se borro la cita para el profesional #{professional} con fecha #{date}"
                else 
                  warn "El profesional #{professional} no tiene una cita registrada para la fecha #{date}"
                end
              else
                warn "El profesional #{professional} no existe"  
              end
            else
              warn "La fecha ingresada debe ser posterior a la fecha actual"
            end
          else
            warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16 13:00"
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          prof = Polycon::Models::Professional.find(professional)
          if !prof.nil?
            result = Polycon::Models::Appointment.cancel_all(prof)
            if result > 0
              warn "Se han cancelado todas las futuras citas con el profesional #{professional} (#{result})"
            elsif result == 0
              warn "El profesional #{professional} no tiene futuras citas registradas"
            else
              warn "El profesional #{professional} no tiene ninguna cita registrada"
            end
          else
            warn "El profesional #{professional} no existe"  
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, date: nil)
          prof = Polycon::Models::Professional.find(professional)
          if !prof.nil?
            if date == nil
              resul = prof.appointments()
            else
              if Polycon::Models::Appointment.correct_date?(date, tipo = "Date") #circuito corto y solo chequeo fecha
                resul = prof.appointments_on_date(date)
              else
                warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16"
                resul = -1 #indico que no se ejecutó ningun metodo de prof
              end
            end
            
            if resul != -1 #si se ejecutó algún metodo de prof
              if resul != false
                if resul.length > 0
                  resul.each {|a| puts "#{a.date} (#{a.surname} #{a.name})"} 
                else
                  warn "El profesional #{professional} no tiene citas registradas para la fecha #{date}"
                end  
              else
                warn "El profesional #{professional} no tiene citas registradas"
              end
            end
        
          else
            warn "El profesional #{professional} no existe"  
          end
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          if Polycon::Models::Appointment.correct_date?(new_date) && Polycon::Models::Appointment.correct_date?(old_date)
            if Polycon::Models::Appointment.later_date?(new_date)
              prof = Polycon::Models::Professional.find(professional)
              if !prof.nil?
                old_appt = prof.appointment_on_datetime(old_date)
                if old_appt == nil
                  warn "El profesional #{professional} no tiene citas registradas para la fecha #{old_date}"
                elsif old_appt == false
                  warn "El profesional #{professional} no tiene citas programadas"
                else
                  resul = old_appt.reschedule(new_date)
                  if resul == false
                    warn "Ya hay una cita registrada con el profesional #{professional} para la fecha #{new_date}"
                  else
                    warn "Se ha reprogramado la cita con fecha #{old_date} con el profesional #{professional} para la nueva fecha #{new_date}"
                  end
                end
              else
                warn "El profesional #{professional} no existe"  
              end
            else
              warn "La nueva fecha debe ser posterior a la fecha actual (Es decir la fecha del día actual. No se refiere a la fecha original de la cita)"
            end
          else
            warn "El formato de alguna de las fechas ingresadas es incorrecto\nEjemplo correcto: 2021-09-16 13:00"
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          if Polycon::Models::Appointment.correct_date?(date)
            prof = Polycon::Models::Professional.find(professional)
            if !prof.nil?
              appt = Polycon::Models::Appointment.find(prof, date)
              if !appt.nil?
                appt.edit(options)
                warn "Archivo editado con exito"
              else
                warn "El profesional #{professional} no tiene citas registradas para la fecha #{date}"
              end
            else 
              warn "El profesional #{professional} no existe"  
            end
          else
            warn "El formato de una de las fechas ingresadas es incorrecto\nEjemplo correcto: 2021-09-16 13:00"
          end
        end
      end
    end
  end
end
