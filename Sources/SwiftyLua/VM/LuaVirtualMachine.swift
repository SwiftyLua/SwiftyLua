//
//  LuaVirtualMachine.swift
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


/// The  Lua VM.
///
/// This class provides the interface for the raw Lua C API
public final class LuaVirtualMachine: Hashable {

  // MARK: - Public Properties

  /// The ID of the virtual machine
  public private(set) var id = UUID()


  // MARK: - Private Properties

  internal var state: OpaquePointer!
  internal var functions: [String:SwiftFunction] = [:]


  // MARK: - Initialization

  /// Initialize the Lua VM.
  public init() {
    state = luaL_newstate()
  }

  deinit {
    lua_close(state)
  }


  // MARK: - Opening Lua standard libraries

  /// Load the standard libraries that are given in the set `libraries`.
  ///
  /// - Parameters:
  ///   - libraries: the standard libraries that shall me loaded
  public func openLibraries(_ libraries: Set<LuaLibrary> = [.all]) {
    libraries.forEach { lib in
      lib.open(self.state)
    }
  }


  // MARK: - Equatable & Hashable

  public static func == (lhs: LuaVirtualMachine, rhs: LuaVirtualMachine) -> Bool {
    return lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
