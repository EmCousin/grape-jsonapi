## Changelog

### v1.0.1 (next)

* Your contribution here.

### v1.0.0 (November 21, 2020)

[#14](https://github.com/EmCousin/grape_fast_jsonapi/pull/14) - [@EmCousin](https://github.com/EmCousin)

* Changed dependency from [fast_jsonapi](https://github.com/Netflix/fast_jsonapi) to [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)
* Deprecated `Grape::Formatter::FastJsonapi` and `Grape::FastJsonapi::Parser` in favor to `Grape::Formatter::Jsonapi` and `Grape::Jsonapi::Parser`. Will be removed in v1.1
* Fixed bugs due to breaking changes caused by the switch
* Added and configured Rubocop
* Security updates

### v0.2.6 (June 20, 2020)

* [#14](https://github.com/EmCousin/grape_fast_jsonapi/pull/14) and [#21](https://github.com/EmCousin/grape_fast_jsonapi/pull/21) - Fixes to swagger parser: Respect `:key` setting, fix column type rendering, allow adding to schema - [@vincentvanbush](https://github.com/vincentvanbush) and [@nathanvda](https://github.com/nathanvda)

### v0.2.5 (January 23, 2020)

* [#18](https://github.com/EmCousin/grape_fast_jsonapi/pull/18) - Revert to model_name instead of class-name - [@dblommesteijn](https://github.com/dblommesteijn)

Note : This PR fixes a bug when serializing a ActiveRecord::Relation instance, the formatter was looking for a formatter `ActiveRecord::RelationSerializer` serializer that doesn't exist, insteafd of looking for the serializer corresponding to its model name.

* Security updates

### v0.2.4 (December 16, 2019)

* [#15](https://github.com/EmCousin/grape_fast_jsonapi/pull/15) - Handle serializers which don't have any attributes - [@vesan](https://github.com/vesan)

### v0.2.3 (December 12, 2019)

* Reverted v0.2.2 and bumped `loofah` using `dependabot` - [@EmCousin](https://github.com/EmCousin).

### v0.2.2 (December 12, 2019)

* Fixed low severity vulnerabiliy issue with `loofah` dependency - [@EmCousin](https://github.com/EmCousin).

### v0.2.1 (September 18, 2019)

* [#12](https://github.com/EmCousin/grape_fast_jsonapi/pull/12) - Removed call to `rails` and fixed a potential security issue - [@EmCousin](https://github.com/EmCousin).

### v0.2.0 (February 8, 2019)

* [#5](https://github.com/EmCousin/grape_fast_jsonapi/pull/5): Provide custom Grape Swagger parser for fast_jsonapi object serializers, as well as unit test coverage - [@EmCousin](https://github.com/EmCousin)
* [#6](https://github.com/EmCousin/grape_fast_jsonapi/pull/6) - Fix to make the parser compatible with latest version of fast_jsonapi (1.5 at date) - [@rromanchuk](https://github.com/rromanchuk).

### v0.1.0

* Initial public release - [@EmCousin](https://github.com/EmCousin).
