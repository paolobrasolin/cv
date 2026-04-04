#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "liquid", "~> 5.0"
  gem "kramdown", "~> 2.4"
end

require "yaml"
require "liquid"
require "kramdown"
require "fileutils"
require "base64"

ROOT = File.expand_path("..", __dir__)

module Filters
  def markdownify(input)
    Kramdown::Document.new(input.to_s).to_html
  end

  def slugify(input)
    input.to_s.downcase.strip.gsub(/[^\w\s-]/, "").gsub(/[\s_]+/, "-")
  end
end

env = Liquid::Environment.build do |e|
  e.register_filter(Filters)
  e.file_system = Liquid::LocalFileSystem.new(
    File.join(ROOT, "templates"), "%s.liquid"
  )
end

# Load data
data = {}
Dir.glob(File.join(ROOT, "data", "*.yaml")).each do |f|
  data[File.basename(f, ".yaml")] = YAML.load_file(f, permitted_classes: [Date])
end

# Load assets
assets = {
  "css" => File.read(File.join(ROOT, "includes", "index.css")),
  "icons_svg" => File.read(File.join(ROOT, "includes", "icons.svg")),
  "favicon_base64" => Base64.strict_encode64(File.binread(File.join(ROOT, "includes", "favicon.ico")))
}

# Render
template = Liquid::Template.parse(
  File.read(File.join(ROOT, "templates", "index.liquid")),
  environment: env
)
output = template.render("data" => data, "assets" => assets)

out_dir = File.join(ROOT, "site")
FileUtils.mkdir_p(out_dir)
File.write(File.join(out_dir, "index.html"), output)

puts "Built site/index.html"
