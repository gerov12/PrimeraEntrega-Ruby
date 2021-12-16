class Template
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

    def self.collect_day_appointments(date, prof)
        appo = []
        aux = prof.appointments.filter_by_date(date)
        if !aux.empty? #si hay turnos para esa fecha
            aux.each {|a| appo << a}
        end
        appo
    end

    def self.create_template(headers, rows, title, filename)
    template = ERB.new(File.read(Rails.root.join("app/templates/grid_template.html.erb")))
    
    [(template.result binding), filename]
    end
end