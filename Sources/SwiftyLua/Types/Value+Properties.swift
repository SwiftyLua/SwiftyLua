//
//  Value+Properties.swift
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

public extension Value {

  // MARK: - Public Methods

  /// Get the typed value.
  ///
  /// - Returns: the typed value
  ///
  /// - Throws: `LuaVirtualMachineError.luaTypeMismatch` if there is a type mismatch between the requested type and the value type.
  func value<T>() throws -> T {
    switch self {
      case .bool(let value, let name):
        guard value is T else {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }
        return value as! T

      case .double(let value, let name):
        guard value is T else {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }
        return value as! T

      case .int(let value, let name):
        guard value is T else {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }
        return value as! T

      case .string(let value, let name):
        guard value is T else {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }
        return value as! T

      case .pointer(let value, _):
        return value as! T

      case .void(let value, let name):
        guard value is T else {
          throw LuaVirtualMachineError.luaTypeMismatch(name: name)
        }
        return value as! T
    }
  }

  func object<T: AnyObject>(type: T.Type) throws -> T {
    switch self {
      case .pointer(let value, _):
        return Unmanaged<T>.fromOpaque(value!).takeUnretainedValue()

      default:
        throw LuaVirtualMachineError.luaTypeMismatch(name: name())
    }
  }

  /// Get the name of the  value.
  ///
  /// - Returns: the name of the value
  func name() -> String {
    switch self {
      case .bool(_, let name):
        return name

      case .double(_, let name):
        return name

      case .int(_, let name):
        return name

      case .string(_, let name):
        return name

      case .pointer(_ , let name):
        return name

      case .void(_, let name):
        return name
    }
  }
}
