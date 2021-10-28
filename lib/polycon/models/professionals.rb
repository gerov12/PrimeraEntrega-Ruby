require 'date'

module Polycon
  module Models
    class Professional  
      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def self.find(name)
        professional = new(name)
        return professional if professional.exists?
      end

      def exists?
        Polycon::Store.exist_professional?(name)
      end

      def self.create_directory_professional(name)
        Polycon::Store.save_professional(new(name))
      end

      def appointments #metodo de instancia, name es el name de la instancia
        appts = Polycon::Store.appointments(name)
        if appts.any?
          appts.map do |a|
            Polycon::Models::Appointment.from_file(a, self) #retorna las instancias de Appointment
          end
        else
          false
        end
      end

      def has_appointments_post?
        !appointments.select do |appointment|
          appointment.date > Time.now.strftime("%Y-%m-%d %H:%M")
        end.empty?
        #devuelve si la lista de appointments para este profesional con fecha posterior a la actual
        #no es vacía
      end

      def has_appointments?
        appointments != false
        #devuelve si la lista de appointments para este profesional no es vacía
      end

      def appointments_on_date(date)
        if self.has_appointments?
          appointments.select do |appointment|
            appointment.date.to_s.split(" ")[0] == date #tomo solo la fecha de la fecha-hora del appointment para comparar
          end
        else
          false # indica que el profesional no tiene ninguna cita
        end
      end

      def appointment_on_datetime(date)
        if self.has_appointments?
          appointments.detect do |appointment| #detect toma solo un elemento
            appointment.date == date 
          end
        else
          false # indica que el profesional no tiene ninguna cita
        end
      end

      def self.list
        profs = Polycon::Store.professionals()
        if profs != nil
          profs.map do |prof|
            self.find(prof) #retorno las instancias de Professional
          end
        else
          nil
        end
      end

      def rename(new_name)
        Polycon::Store.rename_professional(name, new_name)
        name = new_name
      end

      def delete
        if !has_appointments_post?
          Polycon::Store.delete_professional(name)
          true
        else
          false
        end 
      end
    end
  end
end
