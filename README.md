# swift-codecov-action

A very simple code coverage summary tool for Swift. This tool takes in the JSON output of Swift's code coverage analysis and produces an overall coverage percentage and per-file coverage percentages.

Run this as a GitHub action in the same workflow job as your project's tests are run.

Note that the flow below will only work if your project can be built & tested in a Linux environment because GitHub Actions cannot run Docker on Mac machines and this action runs in a Docker container.

For example,
```yaml
jobs:
  codecov:
    container:
      image: swift:5.1
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - run: swift test --enable-test-discovery --enable-code-coverage
    - uses: mattpolzin/swift-codecov-action@0.4.0
```

Note the `--enable-code-coverage` argument to `swift test` is **required**.

Inputs:
- `CODECOV_JSON`: The location of the JSON file produced by swift test `--enable-code-coverage`. By default `.build/debug/codecov/*.json`.
- `MINIMUM_COVERAGE`: By default, there is no minimum coverage. Set this to make the script fail if the minimum coverage is not met.
- `PRINT_STDOUT`: `true` by default, but if `false` then will not output the whole codecov table to stdout.

Outputs:
- `CODECOV`: Overall code coverage percentage (not output if action fails due to minimum coverage not being met).
