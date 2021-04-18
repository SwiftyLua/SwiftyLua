//
//  Value.swift
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

/// Base class for a value that shall be passed to the Lua VM.
///
/// This class is abstract, i.e. if the method `value()` is not overriden, it raises a `fatalError`.
public class Value : Hashable {

  // MARK: - Public Properties

  public private(set) var name: String


  // MARK: - Initialization

  public init(name: String) {
    self.name = name
  }


  // MARK: - Public Methods

  /// Return the wrapped value.
  ///
  /// This method must be overriden, otherwise it raises a `fatalError`.
  ///
  /// - Returns: the wrapped value
  public func value<T: Hashable>() -> T {
    fatalError("The method Value.value() must be overriden")
  }

  /// This method should push tthe value onto the stack of the given VM.
  ///
  /// The default implementation of this method does nothing
  ///
  /// - Parameters:
  ///   - vm: the VM
  public func push(_ vm: LuaVirtualMachine) {

  }

  /// This method should pop the value from the stack of the given VM.
  ///
  /// The default implementation throws an error.
  ///
  /// - Parameters:
  ///   - vm: the VM
  ///
  /// - Throws:
  ///   - `LuaVirtualMachineError.luaNotImplemented`, if the method has not been overriden.
  ///   - `LuaVirtualMachineError.luaTypeMismatch`, if the type on top of the stack doesn't match with the value type
  public func pop(_ vm: LuaVirtualMachine) throws {
    throw LuaVirtualMachineError.luaNotImplemented
  }

  
  // MARK: - Hashable and Equatable

  public static func == (lhs: Value, rhs: Value) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(value() as AnyHashable)
  }
}
