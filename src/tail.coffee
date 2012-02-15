Doc = require('pdfkit')
class window.PDFDocument extends Doc
  constructor: (options) ->
    super(options)
    @compress = false

  b64encode: (string) ->
    if window.btoa
      btoa(string)
    else if window.Base64
      Base64.encode(str)
    else
      throw new Error("You must provide a base64 implementation on IE")

  dataURI: ->
    'data:application/pdf;base64,' + @b64encode(@output())

