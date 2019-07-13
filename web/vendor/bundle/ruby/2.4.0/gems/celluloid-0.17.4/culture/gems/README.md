# Motivation
To achieve the higher level of modularity, Celluloid was split into small sub-projects that naturally depend on each other.
Bundler can't handle circular dependencies properly and currently the only workaround is to list all celluloid-ish dependencies in both Gemfile and gemspec.
This is error-prone and not efficient. Thus it was required to put some better workaround in place.

# Configuration
The list of gems and their properties are now defined in `dependencies.yml`.

For example:

```yml
celluloid:
  bundler:
    github: celluloid/celluloid
    branch: 0.17.0-prerelease
celluloid-extras:
  bundler:
    github: celluloid/celluloid-extras
celluloid-supervision:
  bundler:
    github: celluloid/celluloid-supervision
celluloid-pool:
  bundler:
    github: celluloid/celluloid-pool
celluloid-fsm:
  bundler:
    github: celluloid/celluloid-fsm
timers:
  gemspec:
     - ~> 4.0.0
  bundler:
    github: celluloid/timers
```

# Modification of `gemspec` and `Gemfile`

The injection of dependencies into `gemspec` and `Gemfile` is handled by `Celluloid::Sync.gems()`, which routes to either `Celluloid::Gems.gemspec` or `Celluloid::Gems.gemfile` depending on what is passed to it:

* Discussed in [SYNC.md](../SYNC.md#how-do-you-install-it-in-gemfile-and-gemspec-then)