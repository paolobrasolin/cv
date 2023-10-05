require 'bibtex'
require 'citeproc'
require 'csl/styles'
require 'yaml'

cp = CiteProc::Processor.new style: 'apa-no-ampersand', format: 'html'
cp.import BibTeX.open(ARGV[0]).to_citeproc
items = cp.render(:bibliography, cp.data)
items = items.map do |item|
    "- " + item.tr('{}', '').gsub(/<i>(.*?)<\/i>/, '_\1_').gsub(URI.regexp(['http','https','ftp']), '[\0](\0)')
end
puts ({ "title" => "Publications", "body" => items.join("\n") }.to_yaml)
