require 'bundler'
require 'coffee-script'
require 'uglifier'
require 'stringio'
require 'json'

def ignored
  ['flate', './font/ttf', './font/subset', './mixins/images']
end

def resolve(name, relative_to)
  if /^\./ =~ name
    File.expand_path(name, File.dirname(relative_to))
  else
    name
  end
end

def locate(path)
  for extension in [".js", ".coffee", ""]
    for search in ['', 'src/']
      candidate = search + path + extension
      if File.exist?(candidate)
        return candidate
      end
    end
  end
  nil
end

def deps(filename)
  open(filename) do |f|
    f.each do |line|
      if /\brequire\s+(('.*')|(".*"))\s*$/ =~ line
        name = $1[1...-1]
        yield [name, resolve(name, filename)]
      end
    end
  end
  mixin_deps(filename) do |d|
    yield d
  end
end

def mixin_deps(filename)
  open(filename) do |f|
    f.each do |line|
      if /\mixin\s+(('.*')|(".*"))\s*$/ =~ line
        name = "./mixins/" + $1[1...-1]
        yield [name, resolve(name, filename)]
      end
    end
  end
end

def rdeps(filename, seen=nil)
  seen ||= {}
  result = []
  deps(filename) do |child_name, child_file|
    next if ignored.include?(child_name)
    child = locate resolve(child_file, filename)
    if child && File.file?(child)
      unless seen[child_name]
        seen[child_name] = true
        result.concat rdeps(child, seen)
        result.push [child_name, child]
      end
    else
      STDERR.puts "Missing dep #{child_name} in #{filename}"
    end
  end
  result
end

def preamble
  CoffeeScript.compile(File.read('src/preamble.coffee'), bare: true)
end

def tail
  CoffeeScript.compile(File.read('src/tail.coffee'), bare: true)
end

def wrapped(name, filename)
  open(filename) do |f|
    src = f.read
    if filename.end_with? 'coffee'
      src = CoffeeScript.compile(src, bare: true)
    end
      
    output = <<EOF
(function(){
  var module = {exports:{}};
  var exports = module.exports;
  modules['#{name}'] = module;
  module.loader = function(){
    module.loader = null;
    #{src};
  }
}).call();
EOF
  end
end

def preloaded_file(filename)
  open(filename) do |f|
    body = f.read.gsub("\n", '\n').gsub("'", "\\'")
    "require('fs').preloaded['#{filename}'] = \"#{body}\";"
  end
end

def modules(name, filename=nil)
  filename ||= locate(name)
  mods = [wrapped(name, filename)]
  rdeps(filename).each do |n, f|
    mods.push wrapped(n, f)
  end
  mods.join("\n")
end

def build(deps, files, io)
  io.puts "(function(){"
  io.puts preamble
  io.puts "var ignored = #{ignored.inspect};"
  deps.each do |name, filename|
    io.puts modules(name, filename)
  end
  files.each do |filename|
    io.puts preloaded_file filename
  end
  io.puts "})();"
end

def font_metrics(filename)
  src = StringIO.new
  src.puts "window = {};"
  build([['font_compiler']], [filename], src)
  context = ExecJS.compile(src.string)
  m = context.eval "window.pdfkit.require('font_compiler').metrics('#{filename}')"
  m.each {|k,v|
    if v.respond_to?(:nan?) && v.nan?
      m[k] = nil
    end
  }
  m
end

directory 'dist'
directory 'src/font_metrics'

file 'dist/pdfkit.js' => Dir["src/**/*.coffee"] + ['Rakefile', 'dist', 'build_font_metrics'] do
  open('dist/pdfkit.js', 'w') do |f|
    build([['pdfkit', "src/pdfkit/lib/document.coffee"], ['font_metrics/Helvetica']], [], f)
    f.puts tail
  end
end

file 'dist/pdfkit.min.js' => ['dist/pdfkit.js'] do
  open('dist/pdfkit.min.js', 'w') do |f|
    f.write(Uglifier.compile(File.read("dist/pdfkit.js")))
  end
end

task :clean do
  FileUtils.rm_r 'dist' if File.exist? 'dist'
  FileUtils.rm_r 'src/font_metrics' if File.exist? 'src/font_metrics'
end

task :build_font_metrics => ['src/font_metrics'] do
  Dir["src/pdfkit/lib/font/data/*.afm"].each do |filename|
    name = File.basename(filename)[0...-4]
    open("src/font_metrics/#{name}.js", "w") do |f|
      f.write "module.exports = " + font_metrics(filename).to_json
    end
  end
end

task :build => ['dist/pdfkit.js']
task :compress => ['dist/pdfkit.min.js']
task :default => [:compress]
