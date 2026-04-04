log := @printf "\n\u001b[7m ■ %s \u001b[0m\n"

site/index.html:
	ruby scripts/render_index.rb

pdf: assets/paolo-brasolin-cv.pdf

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
		--volume "$(CURDIR)/site/:/home/pptruser/site/" \
		--volume "$(CURDIR)/assets/:/home/pptruser/assets/" \
		ghcr.io/puppeteer/puppeteer:latest \
		node _puppeteer/index.js \
			--source "file:///home/pptruser/site/index.html" \
			--target "/home/pptruser/$@"
	$(log) "Restore strict permissions on target"
	chmod -R o-w $@

includes/favicon.ico.base64: favicon.ico
	base64 --wrap=0 $< > $@

# NOTE: data/publications.json is a CSL export from Zotero
data/publications.yaml: data/publications.json
	ruby scripts/render_publications.rb > $@

