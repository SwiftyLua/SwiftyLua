//
//  SwiftFunction.swift
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

/// This class encapsulates a Swift function that shall be registered with a `LuaVirtualMachine`.
public class SwiftFunction {

  // MARK: - Public Typealiases

  /**
    This closure is executed when the function is called from Lua.

    - Parameters:
        - parameters: an array of `Value`s
    - Returns: An array of `Value`s; the array can be empty, if there are now return values.
   */
  public typealias Closure = (_ parameters: [Value]) -> [Value]


  // MARK: - Public Properties

  public private(set) var name: String

  /// The parameters that the function accepts.
  public private(set) var parameters: [Value]

  /// The return values of the function
  public private(set) var returnValues: [Value]

  /// The virtual machine at which this function is registered
  public internal(set) weak var vm: LuaVirtualMachine? = nil


  // MARK: - Internal Properties

  internal      var closure: Closure


  // MARK: - Initialization

  /**
    Initialize teh function descriptor.

    - Parameters:
      - name: the function name
      - parameters: an array with function parameters, that defines their types
      - returnValues: an array with return values
      - closure: the Swift function or a closure that shall be called from Lua
   */
  public init(_ name: String, parameters: [Value], returnValues: [Value], closure: @escaping Closure) {
    self.name = name
    self.parameters = parameters
    self.returnValues = returnValues
    self.closure = closure
  }
}
