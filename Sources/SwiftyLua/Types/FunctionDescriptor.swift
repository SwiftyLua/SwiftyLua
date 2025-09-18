//
//  FunctionDescriptor.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 24.04.21.
//  Copyright 2025 Thomas Bonk <thomas@meandmymac.de>
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
import lua4swift

/**
 Describe a function that shall be registered.
 */
public struct FunctionDescriptor {

  // MARK: - Internal Properties

  internal let name: String
  internal let parameters: [TypeChecker]
  internal let fn: SwiftFunction


  // MARK: - Initialization

  /**
   Initialize the function descriptor.

   - Parameters:
     - name: the name of the function
     - parameters: the types of the parameters that are expected by the function
     - fn: the Swift function that shall be called, when Lua calls the function
   */
  public init(name: String, parameters: [TypeChecker] = [], fn: @escaping SwiftFunction) {
    precondition(!name.isEmpty)
    
    self.name = name
    self.parameters = parameters
    self.fn = fn
  }
}
