0.20.5 (2015-09-30)
-----
* Revamped test suite, using shared RSpec configuration layer provided by Celluloid itself.
* Updated gem dependencies provided by Celluloid::Sync... extraneous gems removed, or marked as development dependencies.

0.20.2 (2015-08-07)
-----
* `ActorSystem` moved to `Actor::System` in Celluloid; that is reflected here.
* Only show `:debug` level of output if `$CEULLULOID_DEBUG` set to `true`.

0.20.1 (2015-07-15)
-----
* Refactored `Celluloid::Internals::CPUCounter`

0.20.0
-----
* Original release of new gem, extracted from `Celluloid`
