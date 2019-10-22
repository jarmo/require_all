### 3.0.0:

* Merged PR #29 (https://github.com/jarmo/require_all/pull/29)
  Respect inflections defined by ActiveSupport when autoloading.

  Thanks to James Le Cuirot (@chewi)

### 2.0.0:

* Merged PR #24 (https://github.com/jarmo/require_all/pull/24)
  Prior to version 2, RequireAll attempted to automatically resolve dependencies between files, thus
  allowing them to be required in any order. Whilst convenient, the approach used (of rescuing
  `NameError`s and later retrying files that failed to load) was fundamentally unsafe and can result
  in incorrect behaviour (for example issue #8, plus more detail and discussion in #21).

  Thanks to Joe Horsnell (@joehorsnell)

### 1.5.0:

* Merged PR #13 (https://github.com/jarmo/require_all/pull/13).
* Merged PR #18 (https://github.com/jarmo/require_all/pull/18).

### 1.4.0:

* License is now correctly as MIT. Thanks to Eric Kessler for pull request #16.

### 1.3.3:

* Support empty directories without crashing. Issue #11. Thanks to Eric Kessler.

### 1.3.2:

* Add license to gemspec.

### 1.3.1:

* README improvements.

### 1.3.0:

* Make everything work with Ruby 1.9 and 2.0. Awesome! Thanks to Aaron Klaassen.

### 1.2.0:

* Add load_all, and load_rel which behave similarly to require_all/require_rel except that Kernel#load is used
* Add autoload_all and autoload_rel (see README and/or specs for examples of usage)
* Minor bug fixes
* Improved specs

### 1.1.0:

* Add require_rel (require_all relative to the current file)
* Fix bug in auto-appending .rb ala require

### 1.0.1:

* Allow require_all to take a directory name as an argument

### 1.0.0:

* Initial release (was originally load_glob, converted to require_all which is
  a lot cooler, seriously trust me)
