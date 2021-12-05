require 'erb'

class Day < Template
  def self.initialize_rows(rows)
    rows.each do |r|
      r[1] = ""
    end
  end

  def self.insert_appointments(rows, appointments)
    rows.each do |r|
      appointments.each do |a|
        if a.date.strftime("%H:%M") == r[0]
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
    appointments = []
    if professional.blank?
      Professional.all.each do |p|
        aux = p.appointments.filter_by_date(date)
        if !aux.empty? #si hay turnos para esa fecha
          aux.each {|a| appointments << a}
        end
      end
      title = "Date for #{date.gsub("-","/")}"
      filename = "#{date}_day"
    else
      prof = Professional.find(professional)

      aux = prof.appointments.filter_by_date(date)
      if !aux.nil? #si hay turnos para esa fecha
        aux.each {|a| appointments << a}
      end
      
      title = "Dates for #{date.gsub("-","/")} (profesional: #{professional})"
      filename = "#{professional}_#{date}_day"
    end
    headers = ['📜', date.gsub("-","/")]
    rows = schedule()
    #Inicializo los r[1] de cada row
    self.initialize_rows(rows)
    #Cargo los turnos en la tabla
    self.insert_appointments(rows, appointments)
    create_template(headers, rows, title, filename)
  end
end