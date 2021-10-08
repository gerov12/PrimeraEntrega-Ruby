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
          Polycon::Utils.posicionar_en_polycon()
          if Polycon::Models::Appointment.fecha_correcta?(date)
            if Polycon::Models::Appointment.fecha_posterior?(date)
              if Polycon::Models::Appointment.posicionarme(professional)
                if Polycon::Models::Appointment.crear(date, name, surname, phone, notes)
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
          Polycon::Utils.posicionar_en_polycon()
          if Polycon::Models::Appointment.fecha_correcta?(date)
            if Polycon::Models::Appointment.posicionarme(professional)
              archivo = Polycon::Models::Appointment.mostrar(date)
              if archivo != false
                puts archivo
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
          Polycon::Utils.posicionar_en_polycon()
          if Polycon::Models::Appointment.fecha_correcta?(date)
            if Polycon::Models::Appointment.fecha_posterior?(date)
              if Polycon::Models::Appointment.posicionarme(professional)
                if Polycon::Models::Appointment.borrar(date)
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
          Polycon::Utils.posicionar_en_polycon()
          if Polycon::Models::Appointment.posicionarme(professional)
            result = Polycon::Models::Appointment.cancelar_todo
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
          Polycon::Utils.posicionar_en_polycon()
          if date == nil || Polycon::Models::Appointment.fecha_correcta?(date, tipo = "Date") #circuito corto y solo chequeo fecha
            if Polycon::Models::Appointment.posicionarme(professional)
              result = Polycon::Models::Appointment.listar(date)
              if result == 1
                warn "El profesional #{professional} no tiene citas registradas"
              elsif result == 2
                warn "El profesional #{professional} no tiene citas registradas para la fecha #{date}"
              else
                result.each {|file| puts file.split(".")[0]} 
              end
            else
              warn "El profesional #{professional} no existe"  
            end
          else
            warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16"
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
          Polycon::Utils.posicionar_en_polycon()
          if Polycon::Models::Appointment.fecha_correcta?(new_date) && Polycon::Models::Appointment.fecha_correcta?(old_date)
            if Polycon::Models::Appointment.fecha_posterior?(new_date)
              if Polycon::Models::Appointment.posicionarme(professional)
                resul = Polycon::Models::Appointment.reprogramar(old_date,new_date)
                if resul == 1
                  #duda: hay que decir si el profesional no tiene citas?
                  #o con aclarar que no hay cita para old_date está bien?
                  warn "El profesional #{professional} no tiene citas registradas para la fecha #{old_date}"
                elsif resul == 2
                  warn "Ya hay una cita registrada con el profesional #{professional} para la fecha #{new_date}"
                else
                  warn "Se ha reprogramado la cita con fecha #{old_date} con el profesional #{professional} para la nueva fecha #{new_date}"
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
          Polycon::Utils.posicionar_en_polycon()
          if Polycon::Models::Appointment.fecha_correcta?(date)
            if Polycon::Models::Appointment.posicionarme(professional)
              archivo = Polycon::Models::Appointment.from_date(date)
              if archivo != false
                archivo.editar(options)
                archivo.actualizar(date)
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
