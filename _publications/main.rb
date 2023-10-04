require 'bibtex'
require 'citeproc'
require 'csl/styles'
require 'yaml'

cp = CiteProc::Processor.new style: 'apa', format: 'html'
cp.import BibTeX.open(ARGV[0]).to_citeproc
items = cp.render(:bibliography, cp.data)
items = items.map { |item| "- " + item }
puts ({ "title" => "Publications", "body" => items.join("\n") }.to_yaml)
