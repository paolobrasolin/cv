require "citeproc"
require "csl/styles"
require "yaml"
require "json"

cp = CiteProc::Processor.new style: "apa-no-ampersand", format: "html"

entries = JSON.parse(File.read("_data/my_publications.json"))

# FIXME: not sure why but citeproc doesn't like dashes
entries.each do |entry|
  entry.delete("page") if entry["page"]&.include?("-")
end

entries.sort_by! { |entry| entry.dig("issued", "date-parts")&.flatten || ["2100"] }
entries.reverse!

cp.import entries

items = cp.render(:bibliography, cp.data)
items = items.map do |item|
  "- " + item.tr("{}", "").gsub(/<i>(.*?)<\/i>/, '_\1_').gsub(URI.regexp(["http", "https", "ftp"]), '[\0](\0)')
end
puts ({ "title" => "Publications", "body" => items.join("\n") }.to_yaml)
