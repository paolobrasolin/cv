site/index.html:
	ruby scripts/render_index.rb

includes/favicon.ico.base64: favicon.ico
	base64 --wrap=0 $< > $@

# NOTE: data/publications.json is a CSL export from Zotero
data/publications.yaml: data/publications.json
	ruby scripts/render_publications.rb > $@
