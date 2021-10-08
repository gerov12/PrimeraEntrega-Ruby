require 'date'

module Polycon
    module Models
        class Appointment
            attr_accessor :surname , :name, :phone, :notes 

            def self.fecha_correcta?(date, tipo = "DateTime")
                if tipo == "DateTime"
                    date =~ /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])\s(0[0-9]|1[0-9]|2[0-3]):(0[0-9]|[1-5][0-9])$/
                else 
                    date =~ /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/ #el string no debe contener la hora
                end
            end

            def self.fecha_posterior?(date)
                date > DateTime.now.strftime("%Y-%m-%d %H:%M")
            end

            def self.from_date(date)
                appointment = new #self new, osea una instancia de Appointment
                if File.exist?(formatear_fecha(date))
                    File.open(formatear_fecha(date), 'r') do |f|
                        appointment.surname = f.gets.chomp
                        appointment.name = f.gets.chomp
                        appointment.phone = f.gets.chomp
                        appointment.notes = f.gets.chomp unless f.eof?
                    end
                    appointment
                else
                    false
                end
            end

            def self.formatear_fecha(date)
                "#{date.gsub(" ", "_").gsub(":", "-")}.paf"
            end

            def self.posicionarme(professional)
                if Polycon::Models::Professional.existe?(professional)
                    Dir.chdir(professional)
                    true
                else
                    false
                end
            end

            def self.crear(date, name, surname, phone, notes = nil)
                if !File.exist?(formatear_fecha(date))
                    File.open(formatear_fecha(date), "a+") do |turno|
                        turno.write("#{surname}\n#{name}\n#{phone}\n#{notes}")
                    end
                    true
                else
                    false
                end
            end

            def self.mostrar(date)
                if File.exist?(formatear_fecha(date))
                    File.read(formatear_fecha(date))
                else
                    false
                end
            end

            def self.borrar(date)
                if File.exist?(formatear_fecha(date))
                     File.delete(formatear_fecha(date))
                    true
                else
                    false
                end
            end

            def self.cancelar_todo()
                if !Dir.empty?(".")
                    borrados = 0
                    Dir.each_child(".") do |file| 
                        if file.to_s > formatear_fecha(DateTime.now.strftime("%Y-%m-%d %H:%M"))
                            File.delete(file)
                            borrados +=1 
                        end
                    end
                    if borrados > 0
                        borrados #se cancelaron todos los proximos turnos
                    else 
                        0 #no se canceló ningun turno (no había proximos)
                    end   
                else
                    -1 #el profesional no tiene ningun turno cargado
                end
            end

            def self.listar(date)
                if !Dir.empty?(".")
                    if date == nil
                        Dir.each_child(".") #retorno los archivos
                    else
                        arreglo = []
                        Dir.each_child(".") do |file| 
                            if file.to_s.split("_")[0] == date
                                arreglo << file
                            end
                        end
                        if arreglo.length > 0
                            arreglo #retorno los archivos
                        else
                            2 #no hay archivos para esa fecha
                        end
                    end
                else
                    1 #no hay archivos
                end
            end

            def self.reprogramar(old_date,new_date)
                if File.exist?(formatear_fecha(old_date))
                    if !File.exist?(formatear_fecha(new_date))
                        File.rename(formatear_fecha(old_date), formatear_fecha(new_date))
                        0
                    else
                        2
                    end
               else
                   1
               end
            end

            def editar(options)
                options.each do |key,value|
                    self.send(:"#{key}=", value) #uso los setters para cargar los datos nuevos
                end
            end

            def actualizar(date)
                path = "#{date.gsub(" ", "_").gsub(":", "-")}.paf"
                File.open(path, 'w') do |f|
                    f << "#{surname}\n" #uso los getters
                    f << "#{name}\n"
                    f << "#{phone}\n"
                    f << "#{notes}"
                end
            end

        end
    end
end