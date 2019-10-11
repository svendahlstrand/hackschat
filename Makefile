QUOTE_YEARS=1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
QUOTE_FILES=$(addprefix quote-from-,$(addsuffix -years-ago.html,$(QUOTE_YEARS)))

.PHONY: all lint sloc clean

all: public/index.html

# Put everything together: results in a webpage with quotes.
public/index.html: header.html $(QUOTE_FILES) footer.html
	cat $^ > $@

# Extract a quote from a locally saved Hackaday entry.
#
# Example: make quote-from-3-years-ago.html
quote-from-%-years-ago.html: entry-from-%-years-ago.html
	./scripts/extract-quote $< |\
	sed 's/^/    /' > $@

# Save a local HTML copy of the last Hackaday entry from years before.
#
# Example: make entry-from-3-years-ago.html
entry-from-%-years-ago.html:
	./scripts/years-ago "$*" | xargs ./scripts/fetch-entries | head -n 1 |\
	xargs curl --silent --show-error > $@

# Lint by running shellcheck on all scripts.
lint:
	shellcheck --enable=all scripts/*

# Count total lines of code excluding comments and empty lines.
sloc: Makefile header.html footer.html ./scripts/*
	cat $^ | grep --invert-match '^\s*#' | grep --invert-match '^\s*$$' | wc -l

clean:
	rm -f public/*.html {entry,quote}*.html
