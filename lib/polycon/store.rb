require 'fileutils'

module Polycon
    class Store
        def self.root_path
            root_path = Dir.home + "/.polycon"
            FileUtils.mkdir_p root_path
            root_path
        end

        #PROFESSIONALS

        def self.professionals
            return Dir[self.root_path+"/*"].select { |e| File.directory? e }.map{|f| File.basename f}
        end

        def self.exist_professional?(name)
            Dir.exist?(self.root_path + "/#{name}")
        end

        def self.save_professional(professional)
            FileUtils.mkdir_p self.root_path + "/#{professional.name}"
        end

        def self.rename_professional(old_name, new_name)
            File.rename(self.root_path + "/#{old_name}", self.root_path + "/#{new_name}")
        end

        def self.delete_professional(name)
            FileUtils.remove_dir(self.root_path + "/#{name}")
        end

        def self.empty_professional(professional)
            deleted = 0
            Dir.each_child(self.root_path + "/#{professional.name}") do |file| 
                if Polycon::Models::Appointment.filename_to_date(file) > DateTime.now.strftime("%Y-%m-%d %H:%M")
                    File.delete(root_path + "/#{professional.name}/#{file}")
                    deleted +=1 
                end
            end
            deleted
        end

        #APPOINTMENTS

        def self.save_appointment(appointment)
            filename = Polycon::Models::Appointment.date_to_filename(appointment.date)
            File.open(self.root_path + "/#{appointment.professional.name}/#{filename}", "a+") do |turno|
                turno.write("#{appointment.surname}\n#{appointment.name}\n#{appointment.phone}\n#{appointment.notes}")
            end
        end

        def self.exist_appointment?(professional, date)
            filename = Polycon::Models::Appointment.date_to_filename(date)
            File.exist?(self.root_path + "/#{professional.name}/#{filename}")
        end

        def self.appointments(professional)
            Dir.each_child(self.root_path + "/#{professional}")
        end

        def self.update_appointment_file(appointment)
            filename = Polycon::Models::Appointment.date_to_filename(appointment.date)
            File.open(self.root_path + "/#{appointment.professional.name}/#{filename}", 'w') do |f|
                f << "#{appointment.surname}\n" #uso los getters
                f << "#{appointment.name}\n"
                f << "#{appointment.phone}\n"
                f << "#{appointment.notes}"
            end
        end

        def self.load_appointment_from_file(file, appointment) #cargo los atributos del appointment desde el archivo
            File.open(self.root_path + "/#{appointment.professional.name}/#{file}", 'r') do |f| 
                appointment.surname = f.gets.chomp
                appointment.name = f.gets.chomp
                appointment.phone = f.gets.chomp
                appointment.notes = f.gets.chomp unless f.eof?
            end
        end

        def self.reschedule_appointment(professional, old_date, new_date)
            old_filename = Polycon::Models::Appointment.date_to_filename(old_date)
            new_filename = Polycon::Models::Appointment.date_to_filename(new_date)
            File.rename(self.root_path + "/#{professional.name}/#{old_filename}", self.root_path + "/#{professional.name}/#{new_filename}")
        end

        def self.delete_appointment(professional, date)
            filename = Polycon::Models::Appointment.date_to_filename(date)
            FileUtils.remove_dir(self.root_path + "/#{professional.name}/#{filename}")
        end
    end
end