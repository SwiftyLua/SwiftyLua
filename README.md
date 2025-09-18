# SwiftyLua

SwiftyLua is a Swift wrapper and bridge for Lua.

## Example Usage

You can find usage examples in the test spec [UsageSpec.swift](./Tests/SwiftyLuaTests/UsageSpec.swift).


## Installation

Reference this project in your `Package.swift` like so:

```swift
// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "LuaTest",
    dependencies: [ .package(url: "https://github.com/SwiftyLua/SwiftyLua.git", from: "0.0.2") ],
    targets: [
        .executableTarget(
            name: "LuaTest",
            dependencies: [ .product(name: "SwiftyLua", package: "SwiftyLua") ]
        ),
    ]
)
```

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
