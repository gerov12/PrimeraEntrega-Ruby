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

        def self.borrar(name)
          if Dir.empty?(name)
            Dir.rmdir(name)
            true
          else
            false
          end 
        end
    end
  end
end
