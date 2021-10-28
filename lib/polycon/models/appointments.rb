require 'date'

module Polycon
    module Models
        class Appointment
            attr_accessor :professional, :date, :surname , :name, :phone, :notes 

            def initialize(professional: nil, date: nil, name: nil, surname: nil, phone: nil, notes: nil)
                @professional = professional
                @date = date
                @surname = surname
                @name = name
                @phone = phone
                @notes = notes
            end

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

            def self.date_to_filename(date)
                "#{date.gsub(" ", "_").gsub(":", "-")}.paf"
            end

            def self.filename_to_date(filename)
                aux = filename.to_s.split(".")[0].gsub("_", " ")
                "#{aux.split(" ")[0]} #{aux.split(" ")[1].gsub("-",":")}"
            end

            def self.from_file(file, professional)
                appointment = new #self new, osea una instancia de Appointment
                appointment.professional = professional #profesional actual
                appointment.date = self.filename_to_date(file) #la fecha sacada del nombre del archivo
                Polycon::Store.load_appointment_from_file(file, appointment) #cargo el resto de los datos desde el archivo
                appointment
            end

            def self.create(professional, date, name, surname, phone, notes)
                if !Polycon::Store.exist_appointment?(professional, date)
                    Polycon::Store.save_appointment(new(professional: professional, date: date, name: name, surname: surname, phone: phone, notes: notes))
                else
                    false
                end
            end

            def self.find(professional, date)
                if professional.appointments() != false
                    professional.appointments().detect{|a| a.date == date}
                else
                    nil
                end
            end

            def delete
                Polycon::Store.delete_appointment(professional, date)
            end

            def self.cancel_all(professional)
                if professional.appointments != false
                    deleted = Polycon::Store.empty_professional(professional)
                    if deleted > 0
                        deleted #se cancelaron todos los proximos turnos
                    else 
                        0 #no se canceló ningun turno (no había proximos)
                    end   
                else
                    -1 #el profesional no tiene ningun turno cargado
                end
            end

            def reschedule(new_date)
                if professional.appointment_on_datetime(new_date).nil?
                    Polycon::Store.reschedule_appointment(professional, date, new_date)
                    date = new_date
                else
                   false
                end
            end

            def edit(options) #actualizo los atributos
                options.each do |key,value|
                    self.send(:"#{key}=", value) #uso los setters para cargar los datos nuevos
                end
                Polycon::Store.update_appointment_file(self)
            end
        end
    end
end