#!/usr/bin/env bash
# fail if any commands fails
set -e


##
## INPUTS
## - $INPUT_CODECOV_JSON - The location of the JSON file produced by
##                   swift test --enable-code-coverage
## - $INPUT_PRINT_STDOUT - 'true' by default, but if 'false' then will not
##                   output the whole codecov table to stdout.
## - $INPUT_SORT_ORDER - 'filename' by default. Possible values: filename,
## 		     +cov, -cov
## - $MINIMUM_COVERAGE   - By default, there is no minimum coverage. Set this
##                   to make the script fail if the minimum coverage is not met.
##
## OUTPUTS
## - $CODECOV             - Overal code coverage percent.
## - $MINIMUM_COVERAGE    - Passes the input through to the output.
## - ./codecov.txt        - Code coverage in a file.
##


# Set default location for JSON
CODECOV_JSON=${INPUT_CODECOV_JSON:-.build/debug/codecov/*.json}

# Set default print option
PRINT_STDOUT=${INPUT_PRINT_STDOUT:-true}

# Set default sort order
SORT_ORDER=${INPUT_SORT_ORDER:-filename}

if [[ "$INPUT_MINIMUM_COVERAGE" = '' ]]; then
  MIN_COV_ARG=''
else
  MIN_COV_ARG="--minimum $INPUT_MINIMUM_COVERAGE"
fi

# Run Codecov for overall coverage
set +e
COV=`swift-test-codecov $CODECOV_JSON $MIN_COV_ARG`
FAILED="$?"
set -e

# Run Codecov for full table
FULL_COV_TABLE=`swift-test-codecov $CODECOV_JSON --sort $SORT_ORDER --print-format table`

# Dump to txt file
echo "$FULL_COV_TABLE" > './codecov.txt'

# Export env vars
echo "::set-output name=codecov::${COV}"
echo "::set-output name=minimum_coverage::${INPUT_MINIMUM_COVERAGE}"
echo "CODECOV=${COV}" >> $GITHUB_ENV
echo "MINIMUM_COVERAGE=${INPUT_MINIMUM_COVERAGE}" >> $GITHUB_ENV

# Print to stdout
if [ "$PRINT_STDOUT" = 'true' ]; then
  echo "$FULL_COV_TABLE"
fi

if [[ "$FAILED" = '1' ]]; then
  exit 1
fi
