.PHONY: all lint sloc clean

all: public/index.html

# Put everything together: results in a webpage with 10 year old quote.
public/index.html: header.html hackaday-quote-from-10-years-ago.html footer.html
	cat $^ > $@

# Extract a quote from a locally saved Hackaday entry.
#
# Example: make hackaday-quote-from-3-years-ago.html
hackaday-quote-from-%-years-ago.html: hackaday-entry-from-%-years-ago.html
	./scripts/extract-quote $< |\
	sed 's/^/    /' > $@

# Save a local HTML copy of the last Hackaday entry from years before.
#
# Example: make hackaday-entry-from-3-years-ago.html
hackaday-entry-from-%-years-ago.html:
	./scripts/years-ago "$*" | xargs ./scripts/fetch-entries | head -n 1 |\
	xargs curl --silent --show-error > $@

# Lint by running shellcheck on all scripts.
lint:
	shellcheck --enable=all scripts/*

# Count total lines of code excluding comments and empty lines.
sloc: Makefile header.html footer.html ./scripts/extract-quote ./scripts/fetch-entries ./scripts/years-ago
	cat $^ | grep --invert-match '^\s*#' | grep --invert-match '^\s*$$' | wc -l

clean:
	rm -f public/*.html hackaday-*.html
