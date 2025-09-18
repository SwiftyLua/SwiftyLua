//
//  ConstructorDescriptor.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 26.04.21.
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
 Describe a constructor of a Swift class that shall be registered.
 */
public struct ConstructorDescriptor {

  // MARK: - Internal Properties

  internal var parameters: [TypeChecker]
  internal var fn: SwiftFunction


  // MARK: - Initialization

  /**
   Initialize a constructor descriptor.

   - Parameters:
     - parameters: parameters for the constructor
     - fn: the Swift function that shall be executed, when the constructor is called from Lua
   */
  public init(parameters: [TypeChecker] = [], fn: @escaping SwiftFunction) {
    self.parameters = parameters
    self.fn = fn
  }
}
