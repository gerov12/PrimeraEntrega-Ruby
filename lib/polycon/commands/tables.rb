module Polycon
    module Commands
      module Tables
        class Create < Dry::CLI::Command
            desc 'Creates a table which represents an appointments grid'

            argument :date, required: true, desc: 'Date from which the table will be created'
            option :professional, required: false, desc: 'Professional to whom the displayed appointments will belong'
            option :type, required: true, desc: 'Indicates if the table correspond to a day or a week'

            example [
                '"2021-09-16" --type="week" # Shows all the appointments for the week of 16/9/21',
                '"2021-09-16" --professional="Alma Estevez" --type="week" # Shows all the appointments corresponding to the professional Alma Estevez in the week of 16/9/21',
                '"2021-09-16" --type="day" # Shows all the appointments from 16/9/21',
                '"2021-09-16" --professional="Alma Estevez" --type="day" # Shows all the appointments of 16/9/21 corresponding to the professional Alma Estevez'
            ]

            def call(date:, professional: nil, type:)
              if type == "week"
                resul = Polycon::Tables::Week.create(date, professional)
                if resul == 1
                  warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16"
                elsif resul == 2
                  warn "El profesional #{professional} no existe"
                else
                  warn "Grilla creada con éxito en el directorio 'tables' de su directorio raíz"
                end
              elsif type == "day"
                resul = Polycon::Tables::Day.create(date, professional)
                if resul == 1
                  warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16"
                elsif resul == 2
                  warn "El profesional #{professional} no existe"
                else
                  warn "Grilla creada con éxito en el directorio 'tables' de su directorio raíz"
                end
              else
                warn "El tipo de grilla #{type} no existe. Utilizar 'day' o 'week'"
              end
            end
        end
      end
    end
end
