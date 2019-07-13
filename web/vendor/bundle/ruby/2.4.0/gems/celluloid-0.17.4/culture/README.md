Celluloid::Culture
==================
[![Build Status](https://travis-ci.org/celluloid/culture.svg)](https://travis-ci.org/celluloid/culture)

### Please see...
* Important [issues for discussion](/celluloid/culture/issues).
* Information about [Celluloid::Sync](SYNC.md).
* Information about [RuboCop](rubocop/README.md).


## Integration
To add `celluloid/culture` and its many splendors to a gem, install it as a sub-module of the gem repository. Once you fully integrate [`Celluloid::Sync`](SYNC.md), the sub-module will be automatically refreshed.

##### Add celluloid/culture as GIT submodule:
```sh
git submodule add http://github.com/celluloid/culture.git
```

Make sure `http://` is used and no other method of inclusion. CI needs it to be `http://`

### Then what?
Once you've done that, read up on [Celluloid::Sync](SYNC.md) and [RuboCop](rubocop/README.md).