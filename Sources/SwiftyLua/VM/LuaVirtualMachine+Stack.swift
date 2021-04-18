//
//  LuaVirtualMachine+Stack.swift
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

public extension LuaVirtualMachine {

  /// Converts the item at `index` to a string and returns it.
  ///
  /// If the value is a number, then this methods also changes the actual value in the stack to a string.
  ///
  /// - Parameters:
  ///   - at: The stack index
  ///
  /// - Returns: A string or nil, if the value isn't a string or a numeric value.
  func peekString(at index: Int32) -> String? {
    var length: Int = 0

    guard let value = lua_tolstring(state, index, &length) else {
      return nil
    }

    return String(cString: value)
  }
}
