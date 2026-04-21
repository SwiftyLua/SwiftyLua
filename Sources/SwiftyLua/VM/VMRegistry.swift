//
//  VMRegistry.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 28.04.21.
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

import lua4swift
import Synchronization

internal struct WeakRef<T: AnyObject>: @unchecked Sendable {

  // MARK: - Public Properties

  public private(set) weak var ref: T?


  // MARK: - Initialization

  internal init(_ ref: T) {
    self.ref = ref
  }
}

/// Sendable wrapper for the VM registry state, safe because access is always protected by Mutex.
internal struct RegistryState: @unchecked Sendable {
  var entries: [OpaquePointer?: WeakRef<LuaVM>] = [:]
}


internal final class VMRegistry: Sendable {

  // MARK: - Public Class Properties

  public static let shared: VMRegistry = VMRegistry()


  // MARK: - Private Properties

  private let registry = Mutex<RegistryState>(RegistryState())


  // MARK: - Initialization

  private init() {}


  // MARK: - Internal Methods

  internal func register(vm: LuaVM) {
    let key = vm.vm.state
    let weakRef = WeakRef(vm)
    registry.withLock { state in
      state.entries[key] = weakRef
    }
  }

  internal func deregister(vm: LuaVM) {
    let key = vm.vm.state
    registry.withLock { state in
      _ = state.entries.removeValue(forKey: key)
    }
  }

  internal func vm(for state: OpaquePointer?) -> LuaVM? {
    return registry.withLock { registryState in
      registryState.entries[state]?.ref
    }
  }
}
