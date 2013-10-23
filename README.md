Generate Beautiful PDFs in the Browser
======================================

* Generate beautiful, printable documents directly in your browser-side
Javascript application.

* Built on top of [pdfkit](https://github.com/devongovett/pdfkit), a
  nice CoffeeScript library that does pdf generation under Node.js. We
  repackage and extend it for use in the browser.

* Relies on data URIs, sorry IE.

* Supports the built-in Adobe PDF fonts.

* Supports almost everything that pdfkit does, including vector
  graphics, line wrapping, text alignment, bulleted lists, etc. Does
  not (yet) support TTF font embedding or image embedding.

Demo
----

[Launch the demo](http://ef4.github.com/pdfkit-www/demo.html)

Synposis
--------

```html
<script type="text/javascript" src="pdfkit.min.js"></script>
<script type="text/javascript">
    function go(){
      var doc = new PDFDocument;
      doc.text "Hello World";
      window.open(doc.dataURI());
    }
</script>
<button onclick="go()">Go!</button>
```

Building
--------

To build:

    git clone git://github.com/ef4/pdfkit-www.git
    cd pdfkit-www
    git submodule update --init
    bundle install
    rake

And then grab dist/pdfkit.js or dist/pdfkit.min.js.

Choosing Fonts
--------------

By default we only include font metrics for Helvetica (to keep the
library as small as possible). To enable any of the other built-in PDF
fonts, manually build the fonts first:

    rake "fonts[Times-Roman:Courier:Helvetica]"
    rake

Or to build all of them:

    rake all_fonts
    rake

With only one font the minified library is about 40k. With all fonts
it goes up to 60k.