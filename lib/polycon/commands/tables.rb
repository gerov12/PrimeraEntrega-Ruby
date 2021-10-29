module Polycon
    module Commands
      module Tables
        class Create < Dry::CLI::Command
            desc 'Crea una grilla de turnos'

            argument :date, required: true, desc: 'Fecha a partir de la cual se mostrará la grilla'
            option :professional, required: false, desc: 'Nombre del profesional'
            option :type, required: true, desc: "Indica si la grilla es para un día o una semana"

            example [
                '"2021-09-16" # Muestra todos los turnos de la semana del 16/9/21',
                '"2021-09-16" --professional="Alma Estevez" # Muestra todos los turnos de Alma Estevez en la semana del 16/9/21',
                '"2021-09-16" --professional="Alma Estevez" --tipo="day" # Muestra todos los turnos de Alma Estevez en el día 16/9/21'
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