//
//  Value+Stack.swift
//  
//
//  Created by Thomas Bonk on 19.04.21.
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

public extension Value {

  // MARK: - Internal Methods

  /// Push the value to the top of the stack of the given virtual machine
  ///
  /// - Parameters:
  ///   - vm: the virtual machine
  func push(_ vm: LuaVirtualMachine) {
    switch self {
      case .bool(let value, _):
        lua_pushboolean(vm.state, value ? 1 : 0)
        break

      case .double(let value, _):
        lua_pushnumber(vm.state, value)
        break

      case .int(let value, _):
        lua_pushinteger(vm.state, value)
        break

      case .string(let value, _):
        lua_pushstring(vm.state, value.cString(using: .utf8))
        break

      case .void(_, _):
        // do nothing
        break
    }
  }

  /// Pop a typed value from the top of the stack of the given virtual machine
  ///
  /// - Parameters:
  ///   - vm: the virtual machine
  /// - Returns: the value
  /// - Throws: `LuaVirtualMachineError.luaTypeMismatch` if there is a type mismatch between the value type on the top of the stack
  ///           and the requested type.
  @discardableResult
  func pop(_ vm: LuaVirtualMachine) throws -> Value {
    switch self {
      case .bool(_, let name):
        if lua_type(vm.state, .TopOfStack) != LUA_TBOOLEAN {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }


        let v = vm.peekBool(at: .TopOfStack)
        vm.pop(count: 1)
        return .bool(value: v, name: name)

      case .double(_, let name):
        if lua_isnumber(vm.state, .TopOfStack) == 0 {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }

        let v = vm.peekDouble(at: .TopOfStack)
        vm.pop(count: 1)
        return .double(value: v, name: name)

      case .int(_, let name):
        if lua_isinteger(vm.state, .TopOfStack) == 0 {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }

        let v = vm.peekInt(at: .TopOfStack)
        vm.pop(count: 1)
        return .int(value: v, name: name)

      case .string(_, let name):
        if lua_isstring(vm.state, .TopOfStack) == 0 {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }

        let v = vm.peekString(at: .TopOfStack)!
        vm.pop(count: 1)
        return .string(value: v, name: name)

      case .void(_, _):
        return Value.void()
    }
  }
}
