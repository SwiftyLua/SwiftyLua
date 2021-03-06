//
//  VMRegistry.swift
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

internal class WeakRef<T: AnyObject> {

  // MARK: - Public Properties

  public private(set) weak var ref: T?


  // MARK: - Initialization

  internal init(_ ref: T) {
    self.ref = ref
  }
}


internal class VMRegistry {

  // MARK: - Public Class Properties

  public static var shared: VMRegistry = { VMRegistry() }()


  // MARK: - Private Properties

  private var registry: [OpaquePointer?:WeakRef<LuaVM>] = [:]


  // MARK: - Internal Methods

  internal func register(vm: LuaVM) {
    registry[vm.vm.state] = WeakRef(vm)
  }

  internal func deregister(vm: LuaVM) {
    guard registry.contains(where: { (key, _) in key == vm.vm.state }) else {
      return
    }

    registry.removeValue(forKey: vm.vm.state)
  }

  internal func vm(for state: OpaquePointer?) -> LuaVM? {
    guard registry.contains(where: { (key, _) in key == state }) else {
      return nil
    }

    return registry[state]!.ref!
  }
}
