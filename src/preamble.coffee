P = window.pdfkit = {}
modules = P.modules = {}
require = P.require = (name) ->
  if ignored.indexOf(name) != -1
    {}
  else if modules[name]
    if modules[name].loader
      modules[name].loader()
    modules[name].exports
  else
    throw new Error("missing module " + name)
__dirname = "src/pdfkit/lib"
Buffer = {}
Buffer.isBuffer = -> false
