#!/usr/bin/env bash
# fail if any commands fails
set -e


##
## INPUTS
## - $INPUT_CODECOV_JSON - The location of the JSON file produced by
##                   swift test --enable-code-coverage
## - $INPUT_PRINT_STDOUT - 'true' by default, but if 'false' then will not
##                   output the whole codecov table to stdout.
## - $MINIMUM_COVERAGE   - By default, there is no minimum coverage. Set this
##                   to make the script fail if the minimum coverage is not met.
##
## OUTPUTS
## - $CODECOV    - Overal code coverage percent.
## - ./codecov.txt - Code coverage in a file.
##


# Set default location for JSON
CODECOV_JSON=${INPUT_CODECOV_JSON:-.build/debug/codecov/*.json}

# Set default print option
PRINT_STDOUT=${INPUT_PRINT_STDOUT:-true}

if [[ "$INPUT_MINIMUM_COVERAGE" = '' ]]; then
  MIN_COV_ARG=''
else
  MIN_COV_ARG="--minimum $INPUT_MINIMUM_COVERAGE"
fi

# Run Codecov for overall coverage
set +e
COV=`swift-test-codecov $CODECOV_JSON $MIN_COV_ARG`
if [[ "$?" = '1' ]]; then
  echo $COV
  exit 1
fi
set -e

# Run Codecov for full table
FULL_COV_TABLE=`swift-test-codecov $CODECOV_JSON --table`

# Dump to txt file
echo "$FULL_COV_TABLE" > './codecov.txt'

# Export env var
echo "::set-output name=codecov::${COV}"
echo "CODECOV=${COV}" >> $GITHUB_ENV

# Print to stdout
if [ "$PRINT_STDOUT" = 'true' ]; then
  echo "$FULL_COV_TABLE"
fi
