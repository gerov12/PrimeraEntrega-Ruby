module Polycon
    module Utils
        def self.posicionar_en_polycon
            Dir.chdir(ENV["HOME"])
            if Dir.exist?("polycon") #acordarse de poner el . a polycon
                Dir.chdir("polycon") 
            else
                Dir.mkdir("polycon")
                Dir.chdir("polycon")
            end
        end
    end
end