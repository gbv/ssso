REVHASH=$(shell git log -1 --format="%H" ssso.md)
REVDATE=$(shell git log -1 --format="%ai" ssso.md)
REVSHRT=$(shell git log -1 --format="%h" ssso.md)
REVLINK=https://github.com/gbv/ssso/commit/${REVHASH}

html: ssso.html

new: purge html changes rdf

ssso.html: ssso.md template.html5
	@echo "creating ssso.html..."
	@sed 's/GIT_REVISION_DATE/${REVDATE}/' ssso.md  > ssso.tmp
	@ pandoc -s -N --template=template --toc -f markdown -t html5 ssso.tmp \
	| perl -p -e 's!(http://[^<]+)\.</p>!<a href="$$1"><code class="url">$$1</code></a>.</p>!g' \
	| perl -p -e 's!(<h2(.+)span>\s*([^<]+)</a></h2>)!<a id="$$3"></a>$$1!g' \
	| sed 's!<td style="text-align: center;">!<td>!' \
	| sed 's!GIT_REVISION_HASH!<a href="${REVLINK}">${REVSHRT}<\/a>!' > ssso.html
	@git diff-index --quiet HEAD ssso.md || echo "Current ssso.md not checked in, so this is a DRAFT!" 

changes: changes.html

changes.html:
	@git log -4 --pretty=format:'<li><a href=ssso-%h.html><tt>%ci</tt></a>: <a href="https://github.com/gbv/ssso/commit/%H"><em>%s</em></a></li>' ssso.md > changes.html

revision: ssso.html ssso.ttl ssso.owl
	@cp ssso.html ssso-${REVSHRT}.html
	@cp ssso.owl ssso-${REVSHRT}.owl
	@cp ssso.ttl ssso-${REVSHRT}.ttl

website: clean purge revision changes.html ssso.ttl ssso.owl
	@echo "new revision to be shown at http://gbv.github.com/ssso/"
	@rm ssso.html ssso.ttl ssso.owl
	@git checkout gh-pages
	@perl -pi -e 's!ssso-[0-9a-z]{7}!ssso-${REVSHRT}!g' index.html
	@sed -i '/<!-- BEGIN CHANGES -->/,/<!-- END CHANGES -->/ {//!d}; /<!-- BEGIN CHANGES -->/r changes.html' index.html
	@cp ssso-${REVSHRT}.html ssso.html
	@cp ssso-${REVSHRT}.ttl ssso.ttl
	@cp ssso-${REVSHRT}.owl ssso.owl
	@git add index.html ssso-${REVSHRT}.html ssso.ttl ssso.owl ssso.html
	@git commit -m "revision ${REVSHRT}"
	@git checkout master

cleancopy:
	@echo "checking that no local modifcations exist..."
	@git diff-index --quiet HEAD -- 

ssso-tmp.ttl: ssso.md
	$(if $(shell grep -P '\t' $<),$(error "found tabs in $<"))
	@awk '/^```/ { FLAG=!FLAG } !FLAG && /^    / { print }' $< | sed 's/^    //' > $@

rdf: ssso.ttl ssso.owl

ssso.ttl: ssso-tmp.ttl
	@rapper --guess $< -o turtle > $@
	
ssso.owl: ssso-tmp.ttl
	@rapper --guess $< -o rdfxml > $@

purge:
	@rm -f ssso.html ssso-*.html changes.html *.owl *.ttl

.PHONY: clean purge html rdf
