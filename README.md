# SwiftyLua

SwiftyLua is a Swift wrapper and bridge for Lua.

## Usage

### Instantiating a Lua virtual machine

The class `LuaVM` is represents a Lua virtual machine. Its constructor accepts a boolean value that determines whether the standard
Lua libraries shall be loaded or not. The default value is `true` for loading the standard libraries.

Example:
```Swift
import SwiftyLua

let luaVmWithoutLibs = LuaVM(openLibs: false) // Lua VM without opening the standard library
let luaVmWithLibs = LuaVM(openLibs: true)     // Lua VM with opening the standard library
```

### Setting a variable



### Setting a struct

### Registering a native Swift function

### Registering a native Swift type (class or struct)

## Licenses

### lua4swift
I forked the lua4swift package from [weyhan/lua4swift](https://github.com/weyhan/lua4swift), removed the Lua sources and made some
minor changes that are all available from [SwiftyLua/lua4swift](https://github.com/SwiftyLua/lua4swift).

Released under MIT license.

Copyright (c) 2015 Steven Degutis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, 
distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the 
following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.
