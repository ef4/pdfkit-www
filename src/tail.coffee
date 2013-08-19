Doc = pdfkit.require('pdfkit')
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

  dataURI: (fn) ->
    @output (data) =>
      fn('data:application/pdf;base64,' + @b64encode(data))

Font = pdfkit.require('../font')
Font.prototype.embedStandard = ->
  @isAFM = true
  font = pdfkit.require "font_metrics/#{@filename}"
  {@ascender,@decender,@bbox,@lineGap,@charWidths} = font
  @ref = @document.ref
      Type: 'Font'
      BaseFont: @filename
      Subtype: 'Type1'

Data = pdfkit.modules['./data'].exports
Data.prototype.readByte = ->
  @data.charCodeAt(@pos++)
Data.prototype.writeByte = (byte) ->
  @data[@pos++] = String.fromCharCode(byte)
Data.prototype.byteAt = (index) ->
  @data.charCodeAt(index)
