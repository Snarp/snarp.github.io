require 'kramdown'
require 'erb'

@layout_fname = File.join("templates", "layout.html.erb")
@readme_fname = File.join("templates", "README.md.erb")

def icon(basename, type=@type)
  if type==:md
    return ""
  elsif type==:html
    return File.read(File.join("templates","svg","#{basename}.svg")).strip
  end
end

def build_readme(type=:md, write: true)
  @type=type
  template = ERB.new File.read(@readme_fname)
  md = template.result(binding)
  File.write('README.md', md) if write
  return md
end

def build_index
  md = build_readme(:html, write: false)
  @body=Kramdown::Document.new(md).to_html.strip
  template = ERB.new File.read(@layout_fname)
  html = template.result(binding).strip
  File.write('index.html', html)
  return html
end

def build
  build_index
  build_readme
end

build