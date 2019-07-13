# Celluloid::Sync

The `celluloid/culture` sub-module needs to be updated in ever repository which uses it, and integrations between all the gems in Celluloid's core suite began to need greater efficiency in handling many gems at once. This lead to the birth of `Celluloid::Sync` and its automation of several otherwise tedious tasks.


## When all is said and done...

Running `bundle` or `rspec` will trigger `Celluloid::Sync` automatically, without slowing you down.

---

## So what does it do?

**1. It adds the gem you're in to the `$LOADPATH`.**

**2. It tries to find the `VERSION` constant for the current gem and load it.**

This allows easy inclusion of `VERSION` in gemspec, without individually including the required file first.

**3. It updates the `celluloid/culture` sub-module.**

Whenever `bundle` is run, the `culture/` directory is synchronized with the repository before it's used any further.

**4. It keeps `Gemfile` and `gemspec` requirements up to date.**

Avoid circular dependency errors, but still have the power to use locally sourced repositories.

---

## How is it installed in `Gemfile` and `gemspec` then?

Add the line above to the top of both files, before everything else:


```ruby
require File.expand_path("../culture/sync", __FILE__)
```


#### Finishing off `gemspec` ...

You only have one other line to add, other than line above ... right before the closing `end` in the file:

```ruby
require File.expand_path("../culture/sync", __FILE__)
Gem::Specification.new do |gem|
  # ...
  # ...
  # Keep in mind, the VERSION constant of this gem ought to be loaded.
  # ...
  # ...
  Celluloid::Sync.gems(gem)
end

```

#### Finishing off `Gemfile` ...

Same as in `gemspec` you have only two bits to add. The second line we're adding goes at the very end, or at least after `gemspec` is called:

```ruby
require File.expand_path("../culture/sync", __FILE__)

# ...
# below any calls to `gemspec`
# below any other gems
# ...

Celluloid::Sync.gems(self)
```
