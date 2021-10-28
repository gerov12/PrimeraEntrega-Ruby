require 'erb'

module Polycon
  class Day
    def self.create(date, professional)
      if Polycon::Models::Appointment.fecha_correcta?(date, tipo = "Date") #circuito corto y solo chequeo fecha
        turnos = []
        if professional == nil
          profesionales = Polycon::Models::Professional.listar
          puts "profesionales"
          puts profesionales
          if profesionales != nil
            puts "Estoy por entrar al each"
            profesionales.each do |p|
              Polycon::Models::Appointment.posicionarme(p)
              aux = Polycon::Models::Appointment.listar(date)
              if aux != 1 && aux != 2 #si hay turnos para esa fecha
                aux.each {|turno| turnos << turno}
              end
            end
          end
          title = "Turnos del día #{date.gsub("-","/")}"
        else
          if Polycon::Models::Appointment.posicionarme(professional)
            aux = Polycon::Models::Appointment.listar(date)
            aux.each {|turno| turnos << turno} 
          else
            2 # el profesional no existe
          end
          title = "Turnos del día #{date.gsub("-","/")} para el profesional #{professional}"
        end
        puts "turnos:"
        puts turnos

        headers = ['', date.gsub("-","/")]
        rows = []
        (8..16).each do |h|
          rows << ["#{h}:00"]
          rows << ["#{h}:15"]
          rows << ["#{h}:30"]
          rows << ["#{h}:45"]
        end

        rows.each do |r|
          turnos.each do |t|
            fecha_t = t.split("_")[1].split(".")[0].gsub("-", ":")
            if fecha_t == r[0]
              r[1] = t
            end
          end
        end

        template = ERB.new <<~END, nil, '-'
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
            <title>Grilla</title>
            <meta charset="UTF-8">
          </head>
          <body>
            <h3> <%= title %> </h3>
            <table>
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
          </body>
        </html>
        END

        #puts template.result binding
        Polycon::Utils.posicionar_en_polycon()
        File.write('test.html', (template.result binding))
      else
        1 #el formato del día está mal
      end
    end
  end
end
