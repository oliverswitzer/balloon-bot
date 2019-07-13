# About
[RuboCop](https://github.com/bbatsov/rubocop) is a ruby static code analyzer.
It's more than just a lint. It verifies the code against ruby best practices and performs code correctness analysis.
Celluloid culture doesn't always agree with all rubocop default policies and so we provide a rubocop configuration file that overrides its default behavior.

# Integration

[Integrate `celluloid/culture`](../README.md#integration), then include `culture/rupocop/.rubocop.yml` in your default rubocop config.

##### Add celluloid/culture as GIT submodule:

* See instructions: [Integrate the `celluloid/culture` sub-module](../README.md#integration)

##### Include `culture/rupocop/rubocop.yml` in the `.rubocop.yml` in the root of your project:
```yml
inherit_from:
  - culture/rubocop/rubocop.yml
```

# How to add rubocop to your project

The `rubocop` gem is automatically included by `Celluloid::Sync.gems` when that is [implemented](../SYNC.md).

##### Add a 'rubocop' target in your `Rakefile`

# Hints
It's possible to use rubocop for autocorrection of minor problems.

Always verify these changes by running:

```sh
bundle exec rubocop
```

Once you are ready to auto-corret the issues you are shown, run it with the `-a` option:
```sh
bundle exec rubocop -a
```
