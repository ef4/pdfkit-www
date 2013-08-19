fs = module.exports

fs.preloaded = {}

fs.readFileSync = (filename, encoding) ->
  if fs.preloaded[filename]
    fs.preloaded[filename]
  else if m = /^data:.*;base64,(.*)/.exec(filename)
    str = atob(m[1])
  else
    throw new Error("file not available: #{filename}")
