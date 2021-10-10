//
//  LuaVM+Debug.swift
//  
//
//  Created by Thomas Bonk on 28.04.21.
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
import CLua

public struct DebugInfo {

  let event: Int32
  let name: String              /* (n) */
  let namewhat: String          /* (n) */
  let what: String              /* (S) */
  let source: String            /* (S) */
  let srclen: Int               /* (S) */
  let currentline: Int32        /* (l) */
  let linedefined: Int32        /* (S) */
  let lastlinedefined: Int32    /* (S) */
  let nups: UInt8               /* (u) number of upvalues */
  let nparams: UInt8            /* (u) number of parameters */
  let isvararg: Bool            /* (u) */
  let istailcall: Bool          /* (t) */
  let ftransfer: UInt16;        /* (r) index of first value transferred */
  let ntransfer: UInt16         /* (r) number of transferred values */
  let short_src: String         /* (S) */

  // MARK: - Initialization

  fileprivate init(_ info: lua_Debug) {
    event = info.event
    name = String(cString: info.name)
    namewhat = String(cString: info.namewhat)
    what = String(cString: info.what)
    source = String(cString: info.source)
    srclen = info.srclen
    currentline = info.currentline
    linedefined = info.linedefined
    lastlinedefined = info.lastlinedefined
    nups = info.nups
    nparams = info.nparams
    isvararg = (info.isvararg == 1)
    istailcall = (info.istailcall == 1)
    ftransfer = info.ftransfer
    ntransfer = info.ntransfer
    //short_src = String(cString: &(info.short_src))
    short_src = ""
  }
}

public protocol DebugCallback {
  func debug(vm: LuaVM, info: DebugInfo)
}

public extension LuaVM {

  var debugCallback: DebugCallback? {
    get {
      return extensionVariables[.DebugCallbackKey] as? DebugCallback
    }
    set {
      if newValue == nil {
        lua_sethook(vm.state, debugHook, 0, 0)
      } else {
        lua_sethook(vm.state, debugHook, LUA_MASKLINE, 0)
      }

      extensionVariables[.DebugCallbackKey] = newValue
    }
  }

  var debuggingEnabled: Bool {
    get {
      return (extensionVariables[.DebuggingEnabledKey] as? Bool) ?? false
    }
    set {
      extensionVariables[.DebuggingEnabledKey] = newValue
    }
  }

}

extension String {
  fileprivate static let DebugCallbackKey = "@@@@@DEBUG_CALLBACK@@@@@"
  fileprivate static let DebuggingEnabledKey = "@@@@@DEBUGGING_ENABLED@@@@@"
}

private func debugHook(_ state: OpaquePointer?, _ debug: UnsafeMutablePointer<lua_Debug>?) {
  if let lua = VMRegistry.shared.vm(for: state) {
    if lua.debuggingEnabled {
      lua.debugCallback?.debug(vm: lua, info: DebugInfo(debug!.pointee))
    }
  }
}
