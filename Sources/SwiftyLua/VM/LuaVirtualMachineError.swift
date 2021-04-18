//
//  LuaVirtualMachineError.swift
//  
//
//  Created by Thomas Bonk on 17.04.21.
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

public struct LuaVirtualMachineError: Error {

  public internal(set) var code: Int32
  public internal(set) var errorMessage: String?

  public var localizedDescription: String {
    switch code {
      case .luaYield:
        return "The thread/coroutine yields: \(errorMessage ?? "Unknown reason.")"

      case .luaErrRun:
        return "Runtime error: \(errorMessage ?? "Unknown reason.")"

      case .luaErrSyntax:
        return "Syntax error: \(errorMessage ?? "Unknown reason.")"

      case .luaErrMem:
        return "Memory allocation error: \(errorMessage ?? "Unknown reason.")"

      case .luaErrErr:
        return "Der König ist tot, es lebe der König! \(errorMessage ?? "Unknown reason.")"

      case .luaErrFile:
        return "File related error: \(errorMessage ?? "Unknown reason.")"

      default:
        return "Unknown error: \(errorMessage ?? "Unknown reason.")"
    }
  }
}

internal extension Int32 {
  static var luaOk: Int32 { 0 }
  static var luaYield: Int32 { 1 }
  static var luaErrRun: Int32 { 2 }
  static var luaErrSyntax: Int32 { 3 }
  static var luaErrMem: Int32 { 4 }
  static var luaErrErr: Int32 { 5 }
  static var luaErrFile = luaErrErr + 1
}
