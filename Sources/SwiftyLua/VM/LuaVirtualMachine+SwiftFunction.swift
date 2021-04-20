//
//  LuaVirtualMachine+SwiftFunction.swift
//  
//
//  Created by Thomas Bonk on 20.04.21.
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

private func functionWrapper(_ state: OpaquePointer?) -> Int32 {
  let swiftFunction = Unmanaged<SwiftFunction>.fromOpaque(lua_touserdata(state, UpvalueIndex(1))).takeUnretainedValue()
  let vm = swiftFunction.vm!
  var parameterValues: [Value] = []

  let paramsOnStack = lua_gettop(state)

  guard paramsOnStack >= swiftFunction.parameters.count else {
    vm.pushString("Swift function >\(swiftFunction.name)<: expected \(swiftFunction.parameters.count) but found ˜\(paramsOnStack)")
    return 0
  }

  do {
    parameterValues.append(
      contentsOf:
        try swiftFunction.parameters.map { value in
          return try value.pop(vm)
        }
        .reversed())
  } catch {
    vm.pushString("Swift function >\(swiftFunction.name)<: type mismatch: \(error)")
    return lua_error(state)
  }

  let returnValues = swiftFunction.closure(parameterValues)

  guard returnValues.count == swiftFunction.returnValues.count else {
    vm.pushString("Swift function >\(swiftFunction.name)<: expected to return \(swiftFunction.returnValues.count) but actually returned \(returnValues.count)")
    return lua_error(state)
  }

  returnValues.reversed().forEach { value in
    value.push(vm)
  }

  return Int32(returnValues.count)
}

public extension LuaVirtualMachine {

  func register(function: SwiftFunction) throws {
    guard function.vm == nil else {
      // function has been reqistered with another VM
      throw LuaVirtualMachineError.luaFunctionAlreadyRegistered(id: function.vm!.id)
    }

    function.vm = self
    functions[function.name] = function

    lua_pushlightuserdata(state, Unmanaged.passUnretained(functions[function.name]!).toOpaque())
    lua_pushcclosure(state, functionWrapper, 1);
    lua_setglobal(state, function.name.cString(using: .utf8));
  }
}
