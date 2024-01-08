css:
	yarn run build:css

pdf:
	yarn run build:pdf

www:
	bundle exec jekyll build

_includes/favicon.ico.base64: favicon.ico
	base64 --wrap=0 $< > $@

# NOTE: _data/my_publications.json is a CSL export from Zotero
_data/publications.yaml: _data/my_publications.json
	ruby _publications/main.rb $< > $@

dev:
	tmux \
		new-session 'bundle exec jekyll serve --force_polling --livereload' \; \
		split-window 'yarn run build:css --watch --verbose'
