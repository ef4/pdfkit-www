modules = {}
require = (name) ->
  if modules[name]
    if modules[name].loader
      modules[name].loader()
    modules[name].exports
  else
    throw new Error("missing module " + name)
__dirname = "src/pdfkit/lib"
Buffer = {}
Buffer.isBuffer = -> false
