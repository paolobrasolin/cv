css:
	yarn run build:css

pdf:
	yarn run build:pdf

www:
	bundle exec jekyll build

dev:
	tmux \
		new-session 'bundle exec jekyll serve --force_polling --livereload' \; \
		split-window 'yarn run build:css --watch --verbose'
