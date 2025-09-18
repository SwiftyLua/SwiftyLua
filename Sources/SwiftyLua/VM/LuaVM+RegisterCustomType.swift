//
//  LuaVM+RegisterCustomType.swift
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

import Swift
import Foundation
import lua4swift

public extension LuaVM {

  /**
   Register a custom type (class or struct).

   If the parameter `library` is given, the custom type is added to that library.

   - Todo: Check whether it is necessary to register the `__gc` meta method

   - Parameters:
     - type: the custom type that shall be registered
     - library: a table that represents a library
   - Returns: The custom type wrapper
   */
  @discardableResult
  func registerCustomType<T: CustomTypeImplementation>(type: T.Type, library: Table? = nil) -> CustomType<T> {
    let tyepDescriptor = T.descriptor(self)

    let customType: CustomType<T> = vm.createCustomType { type in
      // Create methods
      tyepDescriptor.methods.forEach { descriptor in
        type[descriptor.name] = type.createMethod(descriptor.parameters, descriptor.fn)
      }
    }

    // Create constructor
    customType["new"] = vm.createFunction(tyepDescriptor.constructor.parameters, tyepDescriptor.constructor.fn)

    // Create class methods
    tyepDescriptor.functions.forEach { descriptor in
      customType[descriptor.name] = vm.createFunction(descriptor.parameters, descriptor.fn)
    }

    (library ?? globals)[T.luaTypeName()] = customType

    return customType
  }
}
