REVHASH=$(shell git log -1 --format="%H" ssso.md)
REVDATE=$(shell git log -1 --format="%ai" ssso.md)
REVSHRT=$(shell git log -1 --format="%h" ssso.md)
REVLINK=https://github.com/gbv/ssso/commit/${REVHASH}

html: ssso.html

new: purge html changes

ssso.html: ssso.md template.html5
	@echo "creating ssso.html..."
	@sed 's/GIT_REVISION_DATE/${REVDATE}/' ssso.md  > ssso.tmp
	@ pandoc -s -N --template=template --toc -f markdown -t html5 ssso.tmp \
	| perl -p -e 's!(http://[^<]+)\.</p>!<a href="$$1"><code class="url">$$1</code></a>.</p>!g' \
	| sed 's!<td style="text-align: center;">!<td>!' \
	| sed 's!GIT_REVISION_HASH!<a href="${REVLINK}">${REVSHRT}<\/a>!' > ssso.html
	@git diff-index --quiet HEAD ssso.md || echo "Current ssso.md not checked in, so this is a DRAFT!" 

changes: changes.html

changes.html:
	@git log -4 --pretty=format:'<li><a href=ssso-%h.html><tt>%ci</tt></a>: <a href="https://github.com/gbv/ssso/commit/%H"><em>%s</em></a></li>' ssso.md > changes.html

revision: ssso.html
	@cp ssso.html ssso-${REVSHRT}.html

website: clean purge revision changes.html
	@echo "new revision to be shown at http://gbv.github.com/ssso/"
	@rm ssso.html
	@git checkout gh-pages
	@perl -pi -e 's!ssso-[0-9a-z]{7}!ssso-${REVSHRT}!g' index.html
	@sed -i '/<!-- BEGIN CHANGES -->/,/<!-- END CHANGES -->/ {//!d}; /<!-- BEGIN CHANGES -->/r changes.html' index.html
	@git add index.html ssso-${REVSHRT}.html
	@git commit -m "revision ${REVSHRT}"
	@git checkout master

cleancopy:
	@echo "checking that no local modifcations exist..."
	@git diff-index --quiet HEAD -- 

ssso.ttl: ssso.md
	@grep '^    ' $< | sed 's/^    //' > $@

ssso.owl: ssso.ttl
	@rapper --guess ssso.ttl -o rdfxml > $@

purge:
	@rm -f ssso.html ssso-*.html changes.html

.PHONY: clean purge html
