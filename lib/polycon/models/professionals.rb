require 'date'

module Polycon
  module Models
    class Professional
        def self.existe?(name)
          if Dir.exist?(name)
            true
          else
            false
          end 
        end

        def self.crear_profesional(name)
          if !self.existe?(name)
            Dir.mkdir(name)
            true
          else
            false
          end   
        end

        def self.listar
          if !Dir.empty?(".")
            Dir.each_child(".") 
          else
            nil
          end
        end

        def self.renombrar(old_name, new_name)
          if self.existe?(old_name)
            if !self.existe?(new_name)
              File.rename(old_name, new_name)
            else
              2 #ya existe el new_name
            end
          else
            1 #no existe old_name
          end
        end

        def self.tiene_citas(name)
          citas = 0
          Dir.each_child("./#{name}") do |file| #para cada turno del directorio ./profesional
            if file.to_s > Polycon::Models::Appointment.formatear_fecha(DateTime.now.strftime("%Y-%m-%d %H:%M"))
              citas +=1 
            end
          end
          if citas > 0
            true #tiene citas futuras
          else 
            false #no tiene citas futuras
          end
        end

        def self.borrar(name)
          if Dir.empty?(name) || !self.tiene_citas(name)
            FileUtils.remove_dir(name)
            true
          else
            false
          end 
        end
    end
  end
end
