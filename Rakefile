require 'bundler'
require 'coffee-script'
require 'uglifier'

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

directory 'dist'

file 'dist/pdfkit.js' => Dir["src/**/*.coffee"] + ['Rakefile', 'dist'] do
  open('dist/pdfkit.js', 'w') do |f|
    f.puts preamble
    rdeps("src/pdfkit/lib/document.coffee").each do |name, filename|
      f.puts wrapped(name, filename)
    end
    f.puts wrapped('pdfkit', "src/pdfkit/lib/document.coffee")
    f.puts preloaded_file "src/pdfkit/lib/font/data/Helvetica.afm"
    f.puts tail
  end
end

file 'dist/pdfkit.min.js' => ['dist/pdfkit.js'] do
  open('dist/pdfkit.min.js', 'w') do |f|
    f.write(Uglifier.compile(File.read("dist/pdfkit.js")))
  end
end

task :clean do
  FileUtils.rm_r 'dist'
end

task :build => ['dist/pdfkit.js']
task :compress => ['dist/pdfkit.min.js']
task :default => [:compress]
