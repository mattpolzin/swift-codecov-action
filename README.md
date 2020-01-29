# swift-codecov-action

A very simple code coverage summary tool for Swift. This tool takes in the JSON output of Swift's code coverage analysis and produces an overall coverage percentage and per-file coverage percentages.

Run this as a GitHub action in the same workflow job as your project's tests are run.

For example,
```yaml
jobs:
  bionic:
    container: 
      image: swift:5.1-bionic
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - run: swift test --enable-test-discovery --enable-code-coverage
    - uses: mattpolzin/swift-codecov-action@0.1.0
```

Note the `--enable-code-coverage` argument to `swift test` is **required**.
