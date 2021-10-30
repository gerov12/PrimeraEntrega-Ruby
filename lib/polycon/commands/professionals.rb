module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          if !Polycon::Store.exist_professional?(name)
            Polycon::Models::Professional.create_directory_professional(name)
            warn "Directorio #{name} creado con exito"
          else
            warn "Ya existe el diretorio #{name}"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          prof = Polycon::Models::Professional.find(name)
          if !prof.nil?
            if prof.delete
              warn "Se ha borrado al profesional #{name}"
            else
              warn "No se ha borrado al profesional ya que tiene turnos pendientes"
            end
          else
            warn "El profesional #{name} no existe"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          aux = Polycon::Models::Professional.list()
          if aux != nil
            aux.each {|prof| puts prof.name}
          else
            warn "No hay profesionales cargados"
          end
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          prof = Polycon::Models::Professional.find(old_name)
          if !prof.nil?
            if prof.name != new_name
              if Polycon::Models::Professional.find(new_name) == nil
                prof.rename(new_name)
                warn "Cambió el nombre del profesional #{old_name} a #{new_name}"
              else
                warn "Ya existe un profesional llamado #{new_name}"
              end
            else
              warn "El nuevo nombre debe ser distinto del actual"
            end
          else
            warn "El profesional #{old_name} no existe"
          end
        end
      end
    end
  end
end
