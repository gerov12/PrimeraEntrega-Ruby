module Polycon
    module Commands
      module Grillas
        class Create < Dry::CLI::Command
            desc 'Crea una grilla de turnos'

            argument :date, required: true, desc: 'Fecha a partir de la cual se mostrará la grilla'
            option :professional, required: false, desc: 'Nombre del profesional'
            option :tipo, required: false, desc: "Indica si la grilla es para un día o una semana"

            example [
                '"2021-09-16" # Muestra todos los turnos de la semana del 16/9/21',
                '"2021-09-16" --professional="Alma Estevez" # Muestra todos los turnos de Alma Estevez en la semana del 16/9/21',
                '"2021-09-16" --professional="Alma Estevez" --tipo="day" # Muestra todos los turnos de Alma Estevez en el día 16/9/21'
            ]

            def call(date:, professional: nil, tipo: "week")
              Polycon::Utils.posicionar_en_polycon()
              if tipo == "week"
                resul = Polycon::Week.create(date, professional)
                if resul == 1
                  warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16"
                elsif resul == 2
                  warn "El profesional #{professional} no existe"
                else
                  warn "Grilla creada con éxito"
                end
              elsif tipo == "day"
                resul = Polycon::Day.create(date, professional)
                if resul == 1
                  warn "El formato de la fecha ingresada es incorrecto\nEjemplo correcto: 2021-09-16"
                elsif resul == 2
                  warn "El profesional #{professional} no existe"
                else
                  warn "Grilla creada con éxito"
                end
              else
                warn "El tipo de grilla #{tipo} no existe. Utilizar 'day' o 'week'"
              end
            end
        end
      end
    end
end