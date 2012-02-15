class module.exports.EventEmitter
  handlersFor: (event) ->
    (@handlers ?= {})[event] ?= []

  on: (event, handler) ->
    @handlersFor(event).push handler

  once: (event, handler) ->
    outerHandler = (args...) =>
      @removeListener(event, outerHandler)
      handler(args...)
    @on(event, outerHandler)

  removeListener: (event, handler) ->
    list = @handlersFor(event)
    i = list.indexOf(handler)
    if i != -1
      delete list[i]

  emit: (event, args...) ->
    for handler in @handlersFor(event)
      handler(args...)

