require 'kramdown'
require 'erb'
require 'fileutils'

@template_dir = File.join("templates")
# @pub_dir = "output"
@pub_dir = nil
@layout_fname = File.join(@template_dir, "layout.html.erb")
@readme_fname = File.join(@template_dir, "README.md.erb")

def icon(basename, type=@type)
  if type==:md
    return ""
  elsif type==:html
    return File.read(File.join(@template_dir,"svg","#{basename}.svg")).gsub(/\s*\n+\s*/," ").strip
  end
end

def build_readme(type=:md, write: true)
  orig_type=@type
  @type=type
  md = ERB.new(File.read(@readme_fname)).result(binding)
  save_file('README.md', md) if write
  @type=orig_type
  return md
end

def build_index(write: true)
  @body = Kramdown::Document.new(
    build_readme(:html, write: false)
  ).to_html.strip
  html = ERB.new(File.read(@layout_fname)).result(binding).strip
  save_file('index.html', html) if write
  return html
end

def save_file(fname, str, dir: @pub_dir)
  if dir
    FileUtils.mkdir_p(dir)
    fname = File.join(dir, fname)
  end
  File.write(fname, str)
end

def build(write: true)
  {
    md: build_readme(write: write), 
    html: build_index(write: write), 
  }
end

build