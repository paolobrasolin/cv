#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "citeproc-ruby", "~> 2.1"
  gem "csl-styles", "~> 2.0"
end

require "citeproc"
require "csl/styles"
require "yaml"
require "json"

cp = CiteProc::Processor.new style: "apa-no-ampersand", format: "html"

ROOT = File.expand_path("..", __dir__)

entries = JSON.parse(File.read(File.join(ROOT, "_data", "publications.json")))

# FIXME: not sure why but citeproc doesn't like dashes
entries.each do |entry|
  entry.delete("page") if entry["page"]&.include?("-")
end

entries.sort_by! { |entry| entry.dig("issued", "date-parts")&.flatten || ["2100"] }
entries.reverse!

cp.import entries

items = cp.render(:bibliography, cp.data)
items = items.zip(entries).map do |item, entry|
  label = item.tr("{}", "").gsub(/<i>(.*?)<\/i>/, '_\1_').gsub(URI.regexp(["http", "https", "ftp"]), '[\0](\0)')
  label = "**#{label}**" if ["article-journal", "paper-conference"].include?(entry["type"])
  "- " + label
end
puts({ "title" => "Publications", "body" => items.join("\n") }.to_yaml)
