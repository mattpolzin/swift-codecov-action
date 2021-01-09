FROM mattpolzin2/swift-test-codecov:0.10.0

# WORKDIR /github/workspace

COPY swift_codecov.sh /usr/bin/swift_codecov.sh

ENTRYPOINT ["swift_codecov.sh"]
