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

    def self.create_template(headers, rows, title, filename)
    template = ERB.new <<~END, nil, '-'
    <!DOCTYPE html>
    <html lang="en">
        <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <title>Grid</title>
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
    
    [(template.result binding), filename]
    end
end