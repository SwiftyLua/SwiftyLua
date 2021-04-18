//
//  BoolValue.swift
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

/// This class represents a BoolValue that shall passed from Swift to a Lua function or vice versa.
public class BoolValue: Value {

  // MARK: Private Properties

  private var v: Bool


  // MARK: - Initialization

  /// Initialize the instance with the given `value`.
  ///
  /// - Parameters:
  ///   - value: the boolean value to be wrapped
  ///   - name: name of the value
  public init(_ value: Bool = false, name: String) {
    self.v = value
    super.init(name: name)
  }


  // MARK: - Public Methods

  /// Return the wrapped boolean value.
  ///
  /// - Returns: the wrapped boolean value
  public func value() -> Bool {
    return self.v
  }

  /// This method pushes tthe value onto the stack of the given VM.
  ///
  /// - Parameters:
  ///   - vm: the VM
  override public func push(_ vm: LuaVirtualMachine) {
    var booleanValue: Int8 = v ? 1 : 0

    lua_pushstring(vm.state, &booleanValue)
  }

  /// This method should pop the value from the stack of the given VM.
  ///
  /// The default implementation throws an error.
  ///
  /// - Parameters:
  ///   - vm: the VM
  ///
  /// - Returns: the top of the stack
  ///
  /// - Throws:
  ///   - `LuaVirtualMachineError.luaTypeMismatch`, if the type on top of the stack doesn't match with the value type
  override public func pop(_ vm: LuaVirtualMachine) throws {
    if lua_type(vm.state, TopOfStack) != LUA_TBOOLEAN {
      throw LuaVirtualMachineError.lusTypeMismatch(name: name)
    }

    v = vm.peekBool(at: TopOfStack)
    vm.pop(count: 1)
  }
}
