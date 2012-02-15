fs = require 'fs'
AFMFont = require './pdfkit/lib/font/afm'

module.exports.metrics = (filename) ->
  font = AFMFont.open filename
  m = {}
  for field in ['ascender','decender','bbox','lineGap','charWidths']
    m[field] = font[field]
  m