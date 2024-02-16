log := @printf "\n\u001b[7m ■ %s \u001b[0m\n"

css:
	yarn run build:css

pdf:
	yarn run build:pdf

assets/paolo-brasolin-cv.pdf:
	$(log) "Create target path $(dir $@)"
	mkdir -p $(dir $@)
	$(log) "Ensure a target file with correct ownership exists"
	touch $@
	$(log) "Set lax permissions on target to let docker overwrite it"
	chmod -R o+w $@
	$(log) "Regenerate target file"
	docker run -it --init --cap-add=SYS_ADMIN --rm \
		--volume "$(CURDIR)/_puppeteer/:/home/pptruser/_puppeteer/" \
		--volume "$(CURDIR)/_site/:/home/pptruser/_site/" \
		--volume "$(CURDIR)/assets/:/home/pptruser/assets/" \
		ghcr.io/puppeteer/puppeteer:latest \
		node _puppeteer/index.js \
			--source "file:///home/pptruser/_site/index.html" \
			--target "/home/pptruser/$@"
	$(log) "Restore strict permissions on target"
	chmod -R o-w $@

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
