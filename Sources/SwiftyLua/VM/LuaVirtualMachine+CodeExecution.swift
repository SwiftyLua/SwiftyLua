//
//  LuaVirtualMachine+CodeExecution.swift
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
  /// Parses Lua code from a string.
  ///
  /// - Parameters:
  ///   - code: Lua code that shall be loaded
  ///
  /// - Throws: `LuaVMError` in cas of an error
  func load(code:  String) throws {
    let err = luaL_loadstring(state, UnsafeMutablePointer<CChar>(mutating: NSString(string: code).utf8String))
    guard err == LUA_OK else {
      throw LuaVirtualMachineError.from(code: err, with: peekString(at: TopOfStack))
    }
  }
  
  /// Execute Lua code given in `code`.
  ///
  /// - Parameters:
  ///   - code: Lua code that shall be executed
  ///
  /// - Throws: `LuaVMError` in cas of an error
  func execute(code: String) throws {
    try load(code: code)

    let err = lua_pcallk(state, 0, 0, 0, 0, nil)
    guard err == LUA_OK else {
      throw LuaVirtualMachineError.from(code: err, with: peekString(at: TopOfStack))
    }
  }

  /// Loads Lua code from `file`.
  ///
  /// - Parameters:
  ///   - file: Lua file that shall be read
  ///
  /// - Throws: `LuaVMError` in cas of an error
  func load(file: String) throws {
    let err = luaL_loadfilex(state, UnsafeMutablePointer<CChar>(mutating: NSString(string: file).utf8String), nil)
    guard err == LUA_OK else {
      throw LuaVirtualMachineError.from(code: err, with: peekString(at: TopOfStack))
    }
  }

  /// Execute Lua code which is read from `file`.
  ///
  /// - Parameters:
  ///   - file: Lua file that shall be executed
  ///
  /// - Throws: `LuaVMError` in cas of an error
  func execute(file: String) throws {
    try load(file: file)

    let err = lua_pcallk(state, 0, 0, 0, 0, nil)
    guard err == LUA_OK else {
      throw LuaVirtualMachineError.from(code: err, with: peekString(at: TopOfStack))
    }
  }
}
