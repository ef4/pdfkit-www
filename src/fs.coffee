fs = module.exports

fs.preloaded = {}

fs.readFileSync = (filename, encoding) ->
  if fs.preloaded[filename]
    return fs.preloaded[filename]
  throw new Error("file not available: #{filename}")

