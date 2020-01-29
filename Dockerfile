FROM swift:latest as builder

ENV SCRIPT_VERSION '0.5.0'

WORKDIR /build
RUN git clone https://github.com/mattpolzin/swift-test-codecov.git

WORKDIR swift-test-codecov
RUN git checkout "$SCRIPT_VERSION" \
 && swift build

FROM swift:slim
# WORKDIR /github/workspace
COPY --from=builder /build/swift-test-codecov/.build/debug/swift-test-codecov /usr/bin/swift-test-codecov

COPY swift_codecov.sh /usr/bin/swift_codecov.sh

# ARG CODECOV_JSON=.build/debug/codecov/*.json
# ARG PRINT_STDOUT=true
# ENV CODECOV_JSON=$CODECOV_JSON
# ENV PRINT_STDOUT=$PRINT_STDOUT

ENTRYPOINT ["swift_codecov.sh"]
