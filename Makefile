NAME=ssso
GITHUB=https://github.com/gbv/ssso/

SOURCE=$(NAME).md

REVHASH=$(shell git log -1 --format="%H" $(SOURCE))
REVDATE=$(shell git log -1 --format="%ai" $(SOURCE))
REVSHRT=$(shell git log -1 --format="%h" $(SOURCE))

REVLINK=$(GITHUB)commit/$(REVHASH)

new: purge html changes ttl owl

html: $(NAME).html
ttl: $(NAME).ttl
owl: $(NAME).owl

$(NAME).html: $(SOURCE) template.html5
	@echo "creating $@..."
	@sed 's/GIT_REVISION_DATE/${REVDATE}/' $(SOURCE)  > $(NAME).tmp
	@ pandoc -s -N --template=template --toc -f markdown -t html5 $(NAME).tmp \
	| perl -p -e 's!(http://[^<]+)\.</p>!<a href="$$1"><code class="url">$$1</code></a>.</p>!g' \
	| perl -p -e 's!(<h2(.+)span>\s*([^<]+)</a></h2>)!<a id="$$3"></a>$$1!g' \
	| sed 's!<td style="text-align: center;">!<td>!' \
	| sed 's!GIT_REVISION_HASH!<a href="${REVLINK}">${REVSHRT}<\/a>!' > $@
	@git diff-index --quiet HEAD $(SOURCE) || echo "Current $(SOURCE) not checked in, so this is a DRAFT!" 

changes: changes.html

changes.html:
	@git log -4 --pretty=format:'<li><a href=$(NAME)-%h.html><tt>%ci</tt></a>: <a href="$(GITHUB)commit/%H"><em>%s</em></a></li>' $(SOURCE) > $@

revision: $(NAME).html $(NAME).ttl $(NAME).owl
	@cp $(NAME).html $(NAME)-${REVSHRT}.html
	@cp $(NAME).owl $(NAME)-${REVSHRT}.owl
	@cp $(NAME).ttl $(NAME)-${REVSHRT}.ttl

website: clean purge revision changes.html $(NAME).ttl $(NAME).owl
	@echo "new revision to be shown at $(GITHUB)"
	@rm $(NAME).html $(NAME).ttl $(NAME).owl
	@git checkout gh-pages
	@perl -pi -e 's!$(NAME)-[0-9a-z]{7}!$(NAME)-${REVSHRT}!g' index.html
	@sed -i '/<!-- BEGIN CHANGES -->/,/<!-- END CHANGES -->/ {//!d}; /<!-- BEGIN CHANGES -->/r changes.html' index.html
	@cp $(NAME)-${REVSHRT}.html $(NAME).html
	@cp $(NAME)-${REVSHRT}.ttl $(NAME).ttl
	@cp $(NAME)-${REVSHRT}.owl $(NAME).owl
	@git add index.html $(NAME)-${REVSHRT}.html $(NAME).ttl $(NAME).owl $(NAME).html
	@git commit -m "revision ${REVSHRT}"
	@git checkout master

cleancopy:
	@echo "checking that no local modifcations exist..."
	@git diff-index --quiet HEAD -- 

$(NAME)-tmp.ttl: $(SOURCE)
	$(if $(shell grep -P '\t' $<),$(error "found tabs in $<"))
	@awk '/^```/ { FLAG=!FLAG } !FLAG && /^    / { print }' $< | sed 's/^    //' > $@

$(NAME).ttl: $(NAME)-tmp.ttl
	@rapper --guess $< -o turtle > $@
	
$(NAME).owl: $(NAME)-tmp.ttl
	@rapper --guess $< -o rdfxml > $@

purge:
	@rm -f $(NAME).html $(NAME)-*.html changes.html *.owl *.ttl

.PHONY: clean purge html rdf

