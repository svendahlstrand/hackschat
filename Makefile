.PHONY: all sloc clean

all: build/index.html

# Put everything together: results in a webpage with 10 year old quote.
build/index.html: header.html hackaday-quote-from-10y-ago.html footer.html
	cat $^ > $@

# Extract a quote from a locally saved Hackaday entry.
#
# Example: make hackaday-quote-from-30d-ago.html
hackaday-quote-from-%-ago.html: hackaday-entry-from-%-ago.html
	./scripts/extract-quote $< |\
	sed 's/^/    /' > $@

# Save a local HTML copy of the last Hackaday entry from a specific date.
#
# Example: make hackaday-entry-from-30d-ago.html
hackaday-entry-from-%-ago.html:
	./scripts/fetch-hackaday-entries "-$*" | head -n 1 |\
	xargs curl --silent --show-error > $@

# Count total lines of code excluding comments and empty lines.
sloc: Makefile header.html footer.html ./scripts/fetch-hackaday-entries ./scripts/extract-quote
	cat $^ | grep --invert-match '^\s*#' | grep --invert-match '^\s*$$' | wc -l

clean:
	rm -f build/*.html hackaday-*.html
