require 'erb'

class Week < Template
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

  def self.headers(week)
    aux = ['📜']
    week.each do |d|
        aux << "#{d.strftime("%Y/%m/%d")} (#{d.strftime("%a")})"      
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
  
  def self.insert_appointments(rows, appointments, headers)
    rows.each do |r|
      appointments.each do |a|
        (1..7).each do |col|
          if a.date.strftime("%H:%M") == r[0] && a.date.strftime("%Y-%m-%d") == headers[col].split(" ")[0].gsub("/","-")
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

  def self.collect_week_appointments(week, prof)
    appo = []
    week.each do |day|
      appo = appo + collect_day_appointments(day, prof)
    end
    appo
  end

  def self.create(date, professional)
      appointments = []
      week = self.get_week(date)
      if professional.blank?
          Professional.all.each do |p|
            appointments = appointments + self.collect_week_appointments(week, p)
          end
          title = "#{date.gsub("-","/")} week dates"
          filename = "#{date}_week"
      else
          prof = Professional.find(professional)
          appointments = appointments + self.collect_week_appointments(week, prof)
          title = "#{date.gsub("-","/")} week dates (professional: #{Professional.find(professional).name})"
          filename = "#{professional}_#{date}_week"
      end

      headers = headers(week)
      rows = schedule()
      self.initialize_rows(rows)
      self.insert_appointments(rows, appointments, headers)
      create_template(headers,rows, title, filename)
  end
end