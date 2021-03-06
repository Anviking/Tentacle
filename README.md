# Tentacle [![MIT license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/mdiep/Tentacle/master/LICENSE.md)
A Swift framework for the GitHub API

```swift
let client = Client(.DotCom, token: "…")
client
    .releaseForTag("tag-name", inRepository: Repository(owner: "ReactiveCocoa", name: "ReactiveCocoa"))
    .startWithNext { release in
        print("Downloaded release: \(release)")
    }
```

Tentacle is built with [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa).

## License
Tentacle is available under the [MIT License](LICENSE.md)
