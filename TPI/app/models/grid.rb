require 'fileutils'

class Grid
  include ActiveModel::Model 
  include ActiveModel::Validations

  attr_accessor :date, :type, :professional

  validates :date, presence: true
  validates :type, presence: true, inclusion: { in: ['day', 'week'] } 

  def generate()
    puts("holaaaa")
    if type == 'week'
      aux = Week.create(date, professional)
    else
      aux = Day.create(date, professional)
    end
    filename = aux[1]
    template = aux[0]
    File.open(Rails.root.join("tmp/#{filename}.html"), "w+") { |file| file.write("#{template}")}
    Rails.root.join("tmp/#{filename}.html")
  end
end
