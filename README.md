# require_all
[![Gem Version](https://badge.fury.io/rb/require_all.png)](http://badge.fury.io/rb/require_all)
[![Build Status](https://secure.travis-ci.org/jarmo/require_all.png)](http://travis-ci.org/jarmo/require_all)
[![Coverage](https://coveralls.io/repos/jarmo/require_all/badge.png?branch=master)](https://coveralls.io/r/jarmo/require_all)

A wonderfully simple way to load your code.

Tired of futzing around with `require` statements everywhere, littering your code
with `require File.dirname(__FILE__)` crap?  What if you could just
point something at a big directory full of code and have everything just
automagically load?

Wouldn't that be nice?  Well, now you can!

## Installation

Add this line to your application's Gemfile:

    gem 'require_all'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install require_all

## Usage

```ruby
require 'require_all'

# load all ruby files in the directory "lib" and its subdirectories
require_all 'lib'

# or load all files by using glob
require_all 'lib/**/*.rb'

# or load files in an Array
require_all Dir.glob("blah/**/*.rb").reject { |f| stupid_file? f }

# or load manually specified files
require_all 'lib/a.rb', 'lib/b.rb', 'lib/c.rb', 'lib/d.rb'
```

You can also load files relative to the current file by using `require_rel`:

```ruby
# Instead of
require File.dirname(__FILE__) + '/foobar'

# you can do simply like this
require_rel 'foobar'
```

You can give all the same argument types to the `require_rel` as for `require_all`.

It is recommended to use `require_rel` instead of `require_all` since it will require files relatively
to the current file (`__FILE__`) as opposed to loading files relative from the working directory.

`load_all` and `load_rel` methods also exist to use `Kernel#load` instead of `Kernel#require`!

Files are required in alphabetical order and if there are files in nested directories, they are
required depth-first. If a `NameError` caused by a reference to an uninitialised constant is
encountered during the requiring process, then a `RequireAll::LoadError` will be thrown,
indicating the file that needs the dependency adding to.

## autoload_all

This library also includes methods for performing `autoload` - what a bargain!

Similar syntax is used as for `require_(all|rel)` and `load_(all|rel)` methods with some caveats:

* Directory and file names have to reflect namespaces and/or constant names:

```ruby
# lib/dir1/dir2/my_file.rb
module Dir1
  module Dir2
    class MyFile
    end
  end
end

# lib/loader.rb
autoload_all File.dirname(__FILE__) + "/dir1"
```

* A `base_dir` option has to be specified if loading directories or files from some other location
  than top-level directory:

```ruby
# lib/dir1/other_file.rb
autoload_all File.dirname(__FILE__) + "/dir2/my_file.rb",
             base_dir: File.dirname(__FILE__) + "/../dir1"
```

* All namespaces will be created dynamically by `autoload_all` - this means that `defined?(Dir1)` will
  return `"constant"` even if `my_file.rb` is not yet loaded!

Of course there's also an `autoload_rel` method:
```ruby
autoload_rel "dir2/my_file.rb", base_dir: File.dirname(__FILE__) + "/../dir1"
```

If having some problems with `autoload_all` or `autoload_rel` then set `$DEBUG=true` to see how files
are mapped to their respective modules and classes.

## Version compatibility and upgrading

As of version 2, RequireAll will raise a `RequireAll::LoadError` if it encounters a `NameError`
caused by a reference to an uninitialised constant during the requiring process. As such, it is not
backwards compatible with version 1.x, but simple to upgrade by adding any requires to load
dependencies in files that need them. See [CHANGES](CHANGES.md) for more details.

## Questions? Comments? Concerns?

You can reach the author on github or by email [jarmo.p@gmail.com](mailto:jarmo.p@gmail.com)

## License

MIT (see the [LICENSE](LICENSE) file for details)
