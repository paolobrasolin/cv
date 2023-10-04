css:
	yarn run build:css

pdf:
	yarn run build:pdf

www:
	bundle exec jekyll build

_includes/favicon.ico.base64: favicon.ico
	base64 --wrap=0 $< > $@

_data/publications.yaml: _data/publications.bib
	ruby _publications/main.rb $< > $@

dev:
	tmux \
		new-session 'bundle exec jekyll serve --force_polling --livereload' \; \
		split-window 'yarn run build:css --watch --verbose'
