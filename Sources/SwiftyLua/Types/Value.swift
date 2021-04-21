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

/// This enumeration is used to pass values from Swift to Lua functions as well as receiving values from Lua.
public enum Value {
  /**
    Encapsulate a Bool value.

    - Parameters:
      - value: the Bool value
      - name: name of the value
   */
  case bool(value: Bool = false, name: String = "bool")

  /**
    Encapsulate a Double value.

    - Parameters:
      - value: the Double value
      - name: name of the value
   */
  case double(value: Double = 0.0, name: String = "double")

  /**
    Encapsulate an Int value.

    - Parameters:
      - value: the Int value
      - name: name of the value
   */
  case int(value: Int64 = 0, name: String = "int")

  /**
    Encapsulate a String value.

    - Parameters:
      - value: the String value
      - name: name of the value
   */
  case string(value: String = "", name: String = "string")

  /**
    Enacpsulate a pointer.

   - Parameters:
     - value: the Pointer value
     - name: name of the value
   */
  case pointer(value: UnsafeMutableRawPointer? = nil, name: String = "pointer")

  /**
    Encapsulate a Void value.

    - Parameters:
      - value: the Void value
      - name: name of the value
   */
  case void(value: Void = (), name: String = "void")
}
