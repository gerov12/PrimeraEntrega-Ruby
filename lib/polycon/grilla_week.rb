require 'erb'

module Polycon
  class Week
    def self.create(date, professional)
      headers = %w[blerg blarg]
      rows = [%w[hi ho], %w[hi hum]]
      title = 'Table'

      template = ERB.new <<~END, nil, '-'
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <title><%= title %></title>
          <meta charset="UTF-8">
        </head>
        <body>
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

      puts template.result binding
      File.write('test.html', (template.result binding))
    end
  end
end
