//
//  LuaLibrary.swift
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

/// This enumaration provides cases for Lua standard libraries that can be loaded from the host application.
public enum LuaLibrary: Int8 {
  /// Basic Library
  case base

  // Coroutine Library
  case coroutine

  /// Debug facilities
  case debug

  // Input and output
  case io

  // Mathematical functions
  case math

  /// Operating system facilities
  case os

  /// Package library
  case package

  /// String manipulation
  case string

  /// Table manipulation
  case table

  /// Basic UTF-8 support
  case utf8

  /// All libraries
  case all


  // MARK: - Private Variables

  private static var libraries: Dictionary<LuaLibrary, ((OpaquePointer?) -> Int32)> = {
    return [
      .base: luaopen_base,
      .coroutine:  luaopen_coroutine,
      .debug:  luaopen_debug,
      .io:  luaopen_io,
      .math:  luaopen_math,
      .os:  luaopen_os,
      .package:  luaopen_package,
      .string:  luaopen_string,
      .table:  luaopen_table,
      .utf8:  luaopen_utf8,
      .all: { state in
        luaL_openlibs(state)
        return 1
      }
    ]
  }()


  // MARK: - Private Methods

  @discardableResult
  internal func open(_ L: OpaquePointer!) -> Int32 {
    return LuaLibrary.libraries[self]!(L)
  }
}
