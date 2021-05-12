# Lua / CPP interface

`lcpp` uses `cpp` to preprocess C header files and extract `#define'd` constants.

# Usage

``` lua
lcpp = require "lcpp"

constants = lcpp.include("foo.h", {"inc"})

for name, val in pairs(constants) do
    print(name, val)
end
```

The `include` function takes two parameters:

1. name of the header file to parse
2. optional list of directories to search for header files

and returns a table with all the constants defined in the main header file.

# Tests

``` sh
make test
```
