//
//  LuaVirtualMachine+CallLua.swift
//  
//
//  Created by Thomas Bonk on 18.04.21.
//  Copyright 2021 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import CLua


public extension LuaVirtualMachine {

  /// Call the Lua function `functionName` and pass the `parameters` to it. `result` contains the result returned by the Lua function.
  ///
  /// - Parameters:
  ///   - function functionName: the name of the Lua function that shall be called
  ///   - parameters: an array with the parameters that shall be passed to the Lua function
  ///   - result: the return value of the called Lua function
  func call(function functionName: String, parameters: [Value], result: inout [Value]) throws {
    lua_getglobal(state, functionName.cString(using: .utf8))

    parameters.forEach { parameter in
      parameter.push(self)
    }

    let err = lua_pcallk(state, Int32(parameters.count), Int32(result.count), 0, 0, nil)
    guard err == LUA_OK else {
      throw LuaVirtualMachineError.from(code: err, with: peekString(at: .TopOfStack))
    }

    var returnValues = [Value]()
    try result.forEach { res in
      returnValues.append(try res.pop(self))
    }

    result = returnValues
  }

  /// Call the Lua function `functionName` and pass the `parameters` to it.
  ///
  /// - Parameters:
  ///   - function functionName: the name of the Lua function that shall be called
  ///   - parameters: an array with the parameters that shall be passed to the Lua function
  func call(function functionName: String, parameters: [Value]) throws {
    var returnValues = [Value]()

    try call(function: functionName, parameters: parameters, result: &returnValues)
  }
}
