fennel = require("fennel")

fennel.dofile = function(filename)
   local source = assert(love.filesystem.read(filename))
   return fennel.eval(source, {filename=filename, accurate=true})
end

fennel.dofile("main.fnl")
