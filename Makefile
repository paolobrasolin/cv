all: site/index.html

site/index.html: data/publications.yaml
	ruby scripts/render_index.rb

# NOTE: data/publications.json is a CSL export from Zotero
data/publications.yaml: data/publications.json
	ruby scripts/render_publications.rb > $@
