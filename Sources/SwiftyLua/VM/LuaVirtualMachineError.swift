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
import CLua

public enum LuaVirtualMachineError: Error {

  case luaYield(reason: String)
  case luaErrRun(reason: String)
  case luaErrSyntax(reason: String)
  case luaErrMem(reason: String)
  case luaErrErr(reason: String)
  case luaErrFile(reason: String)
  case luaErrUnknown(reason: String)
  case luaNotImplemented
  case luaTypeMismatch(name: String)
  case luaFunctionAlreadyRegistered(id: UUID)
  case luaFunctionNotRegistered

  internal static func from(code: Int32, with reason: String?) -> LuaVirtualMachineError {
    switch code {
      case LUA_YIELD:
        return LuaVirtualMachineError.luaYield(reason: reason ?? "Unknown reason")

      case LUA_ERRRUN:
        return LuaVirtualMachineError.luaErrRun(reason: reason ?? "Unknown reason")

      case LUA_ERRSYNTAX:
        return LuaVirtualMachineError.luaErrSyntax(reason: reason ?? "Unknown reason")

      case LUA_ERRMEM:
        return LuaVirtualMachineError.luaErrMem(reason: reason ?? "Unknown reason")

      case LUA_ERRERR:
        return LuaVirtualMachineError.luaErrErr(reason: reason ?? "Unknown reason")

      case LUA_ERRFILE:
        return LuaVirtualMachineError.luaErrFile(reason: reason ?? "Unknown reason")

      default:
        return LuaVirtualMachineError.luaErrUnknown(reason: "Der König ist tot, es lebe der König!")
    }
  }
}
