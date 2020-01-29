#!/usr/bin/env bash
# fail if any commands fails
set -e



##
## INPUTS
## - $INPUT_CODECOV_JSON - The location of the JSON file produced by
##                   swift test --enable-code-coverage
## - $INPUT_PRINT_STDOUT - 'true' by default, but if 'false' then will not
##                   output the whole codecov table to stdout.
##
## OUTPUTS
## - $CODECOV    - Overally code coverage percent.
## - codecov.txt - Code coverage in a file.
##


# Set default location for JSON
CODECOV_JSON=${INPUT_CODECOV_JSON:-.build/debug/codecov/*.json}

# Set default print option
PRINT_STDOUT=${INPUT_PRINT_STDOUT:-true}

# Run Codecov for overall coverage
COV=`swift-test-codecov $CODECOV_JSON`

# Run Codecov for full table
FULL_COV_TABLE=`swift-test-codecov $CODECOV_JSON --table`

# Dump to txt file
echo "$FULL_COV_TABLE" > "${BITRISE_DEPLOY_DIR}/codecov.txt"

# Export env var
echo "::set-output name=codecov::${COV}"
echo "::set-env name=CODECOV::${COV}"

# Print to stdout
if [ "$PRINT_STDOUT" = 'true' ]; then
  echo "$FULL_COV_TABLE"
fi
