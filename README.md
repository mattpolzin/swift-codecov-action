# swift-codecov-action

A very simple code coverage summary tool for Swift. This tool takes in the JSON output of Swift's code coverage analysis and produces an overall coverage percentage and per-file coverage percentages.

Under the hood, this action uses the https://github.com/mattpolzin/swift-test-codecov tool (written in Swift).

Run this as a GitHub action in the same workflow job as your project's tests are run.

Note that the flow below will only work if your project can be built & tested in a Linux environment because GitHub Actions cannot run Docker on Mac machines and this action runs in a Docker container.

For example,
```yaml
jobs:
  codecov:
    container:
      image: swift:5.3
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - run: swift test --enable-test-discovery --enable-code-coverage
    - uses: mattpolzin/swift-codecov-action@0.6.0
      with:
        MINIMUM_COVERAGE: 98
```

Note that you must execute your project's tests using `swift test` with the `--enable-code-coverage` argument to generate the file ingested by this action.

Inputs:
- `CODECOV_JSON`: The location of the JSON file produced by swift test `--enable-code-coverage`. By default `.build/debug/codecov/*.json`.
- `MINIMUM_COVERAGE`: By default, there is no minimum coverage. Set this to make the script fail if the minimum coverage is not met.
- `PRINT_STDOUT`: `true` by default, but if `false` then will not output the whole codecov table to stdout.
- `SORT_ORDER`: `filename` by default. Determines the sort order of the code coverage table. Possible values: `filename`, `+cov`, `-cov`.

Outputs:
- `CODECOV`: Overall code coverage percentage.
- `MINIMUM_COVERAGE`: Just passing through the `MINIMUM_COVERAGE` input.
  
Regardless of wheher or not you have chosen to have the action print to `stdout`, the code coverage table will be dumped to the `./codecov.txt` file.
