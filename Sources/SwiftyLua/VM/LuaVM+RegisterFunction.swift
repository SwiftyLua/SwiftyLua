//
//  LuaVM+RegisterFunction.swift
//  
//
//  Created by Thomas Bonk on 24.04.21.
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
import lua4swift

public extension LuaVM {

  /**
   Register a function.

   - Parameters:
     - descriptor: the function descriptor

   - Returns: an object the represents the function
   */
  @discardableResult
  func registerFunction(_ descriptor: FunctionDescriptor, library: Table? = nil) -> Function {
    let function = vm.createFunction(descriptor.parameters, descriptor.fn)

    (library ?? vm.globals)[descriptor.name] = function

    return function
  }

  /**
   Register functions.

   - Parameters:
     - descriptors: the function descriptors

   - Returns: the objects the represent the functions
   */
  @discardableResult
  func registerFunctions(_ descriptors: [FunctionDescriptor], library: Table? = nil) -> [Function] {
    return descriptors.map { descriptor in registerFunction(descriptor, library: library) }
  }

}
