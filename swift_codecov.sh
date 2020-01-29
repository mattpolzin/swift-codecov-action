#!/usr/bin/env bash
# fail if any commands fails
set -e



##
## INPUTS
## - $CODECOV_JSON - The location of the JSON file produced by
##                   swift test --enable-code-coverage
## - $PRINT_STDOUT - 'true' by default, but if 'false' then will not
##                   output the whole codecov table to stdout.
##
## OUTPUTS
## - $CODECOV    - Overally code coverage percent.
## - codecov.txt - Code coverage in a file.
##

echo "hi! $(ls -la)"


# Set default location for JSON
CODECOV_JSON=${CODECOV_JSON:-.build/debug/codecov/*.json}

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
if [ "${PRINT_STDOUT:-true}" = 'true' ]; then
  echo "$FULL_COV_TABLE"
fi
