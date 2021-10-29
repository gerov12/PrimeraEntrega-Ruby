require 'erb'

module Polycon
  module Tables
    class Week
      def self.get_week(date)
        w = []
        initial_day = Date.strptime(date,"%Y-%m-%d")
        w << initial_day
        if initial_day.strftime("%u") != 1
          self.prev_days(w, initial_day)
        end
        if initial_day.strftime("%u") != 7
          self.next_days(w, initial_day)
        end
        w.sort
      end

      #strftime("%u") devuelve el numero del día de la semana (1=lunes ... 7=domingo)
      def self.prev_days(w, initial_day)
        (1..(initial_day.strftime("%u").to_i-1)).each do |dif|
          w << initial_day - dif
        end
      end

      def self.next_days(w, initial_day)
        (1..(7-initial_day.strftime("%u").to_i)).each do |dif|
          w << initial_day + dif
        end
      end

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
          (1..7).each do |col|
            r[col] = ""
          end
        end
      end

      def self.headers(week)
        aux = ['📜']
        week.each do |d|
          aux << "#{d.to_s.gsub("-","/")} (#{{"Mon" => "Lun", "Tue" => "Mar", "Wed" => "Mie", "Thu" => "Jue", "Fri" => "Vie", "Sat" => "Sab", "Sun" => "Dom"}.fetch(d.strftime("%a"))})"
        end
        aux
      end

      def self.insert_appointments(rows, appointments, headers)
        rows.each do |r|
          appointments.each do |a|
            (1..7).each do |col|
              if a.date.split(" ")[1] == r[0] && a.date.split(" ")[0] == headers[col].split(" ")[0].gsub("/","-")
                if r[col] == ""
                  r[col] = "<p>#{a.surname} #{a.name} (#{a.professional.name})</p>"
                else
                  r[col] = r[col] + "<p>#{a.surname} #{a.name} (#{a.professional.name})</p>"
                end
              end
            end
          end
        end
      end

      def self.create(date, professional)
        if Polycon::Models::Appointment.fecha_correcta?(date, tipo = "Date") #circuito corto y solo chequeo fecha
          appointments = []
          week = self.get_week(date)
          if professional.nil?
            professionals = Polycon::Models::Professional.list()
            if !professionals.nil?
              professionals.each do |p|
                week.each do |day|
                  aux = p.appointments_on_date(day.to_s)
                  if aux != false && !aux.empty? #si hay turnos para esa fecha
                    aux.each {|a| appointments << a}
                  end
                end
              end
            end
            title = "Turnos de la semana del #{date.gsub("-","/")}"
            filename = "#{date}_week"
          else
            prof = Polycon::Models::Professional.find(professional)
            if !prof.nil?
              week.each do |day|
                aux = prof.appointments_on_date(day.to_s)
                if aux != false && !aux.empty? #si hay turnos para esa fecha
                  aux.each {|a| appointments << a}
                end
              end
            else
              return 2 # el profesional no existe (sin el return este caso no funciona)
            end
            title = "Turnos de la semana del #{date.gsub("-","/")} (profesional: #{professional})"
            filename = "#{professional}_#{date}_week"
          end

          headers = self.headers(week)
          rows = self.schedule()

          #Inicializo los r[1] de cada row
          self.initialize_rows(rows)
          #Cargo los turnos en la tabla
          self.insert_appointments(rows, appointments, headers)

          template = ERB.new <<~END, nil, '-'
          <!DOCTYPE html>
          <html lang="en">
            <head>
              <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
              <title>Grilla</title>
              <meta charset="UTF-8">
            </head>
            <body class="bg-dark">
              <div class="card text-white bg-dark mb-3 text-center">
                <div class="card-header"><%= title %></div>
                <div class="card-body">
                  <table class="table table-dark table-md table-bordered align-middle">
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
