//
//  CustomTypeImplementation.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 23.04.21.
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
import Cocoa
import lua4swift

/// Protocol that has to be implemented by classes which shall be exposed to Lua
public protocol CustomTypeImplementation: CustomTypeInstance {

  /// return the descriptor for the custom type.
  static func descriptor(_ vm: LuaVM) -> CustomTypeDescriptor
}

public extension CustomTypeImplementation {
  /**
   Return the name of the class that shall appear in the Lua VM.

   The class name is derived from the Swift class name.

   - Returns: The class name
   */
  static func luaTypeName() -> String {
    return String(describing: self.self)
  }
}
