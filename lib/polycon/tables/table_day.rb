require 'erb'

module Polycon
  module Tables
    class Day
      def self.schedule()
        aux = []
        (8..9).each do |h|
          aux << ["0#{h}:00"]
          aux << ["0#{h}:15"]
          aux << ["0#{h}:30"]
          aux << ["0#{h}:45"]
        end
        (10..16).each do |h|
          aux << ["#{h}:00"]
          aux << ["#{h}:15"]
          aux << ["#{h}:30"]
          aux << ["#{h}:45"]
        end
        aux
      end

      def self.initialize_rows(rows)
        rows.each do |r|
          r[1] = ""
        end
      end

      def self.insert_appointments(rows, appointments)
        rows.each do |r|
          appointments.each do |a|
            if a.date.split(" ")[1] == r[0]
              if r[1] == ""
                r[1] = "<p>#{a.surname} #{a.name} (#{a.professional.name})</p>"
              else
                r[1] = r[1] + "<p>#{a.surname} #{a.name} (#{a.professional.name})</p>"
              end
            end
          end
        end
      end

      def self.create(date, professional)
        if Polycon::Models::Appointment.fecha_correcta?(date, tipo = "Date") #circuito corto y solo chequeo fecha
          appointments = []
          if professional.nil?
            professionals = Polycon::Models::Professional.list()
            if !professionals.nil?
              professionals.each do |p|
                aux = p.appointments_on_date(date)
                if aux != false && !aux.empty? #si hay turnos para esa fecha
                  aux.each {|a| appointments << a}
                end
              end
            end
            title = "Turnos del día #{date.gsub("-","/")}"
            filename = "#{date}_day"
          else
            prof = Polycon::Models::Professional.find(professional)
            if prof != nil
              aux = prof.appointments_on_date(date)
              if aux != false && !aux.nil? #si hay turnos para esa fecha
                aux.each {|a| appointments << a}
              end
            else
              return 2 # el profesional no existe (sin el return este caso no funciona)
            end
            title = "Turnos del día #{date.gsub("-","/")} (profesional: #{professional})"
            filename = "#{professional}_#{date}_day"
          end
          headers = ['📜', date.gsub("-","/")]
          rows = self.schedule()

          #Inicializo los r[1] de cada row
          self.initialize_rows(rows)
          #Cargo los turnos en la tabla
          self.insert_appointments(rows, appointments)

          template = ERB.new <<~END, nil, '-'
          <!DOCTYPE html>
          <html lang="en">
            <head>
              <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
              <title>Grilla</title>
              <meta charset="UTF-8">
            </head>
            <body class="bg-dark">
              <div class="card text-white bg-dark w-auto">
                <div class="card-header"><%= title %></div>
                <div class="card-body">
                  <table class="table table-dark table-md table-bordered align-middle w-auto">
                    <tr>
                    <%- headers.each do |header| -%>
                      <th><%= header %></th>
                    <%- end -%>
                    </tr>
                    <%- rows.each do |row| -%>
                      <tr>
                      <%- row.each do |column| -%>
                        <td><%= column %></td>
                      <%- end -%>
                      </tr>
                    <%- end -%>
                  </table>
                </div>
              </div>  
            </body>
          </html>
          END

          #puts template.result binding
          Polycon::Store.save_table((template.result binding), filename)
        else
          1 #el formato del día está mal
        end
      end
    end
  end
end