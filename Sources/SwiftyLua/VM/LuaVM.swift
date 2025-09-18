//
//  LuaVM.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 23.04.21.
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

import Foundation
import lua4swift

/**
 High level interface for the Lua virtual machine.

 This class wraps the class `lua4swift.VirtualMachine`
 */
public class LuaVM {

  // MARK: - Public Properties

  /// The Lua virtual machine
  public let vm: VirtualMachine

  /// The globals table
  public var globals: Table {
    return vm.globals
  }

  /// The registry table
  public var registry: Table {
    return vm.registry
  }


  // MARK: - Internal Properties

  internal var extensionVariables = [String:Any]()


  // MARK: - Initialization

  /**
   Initialize the virtual machine.

   This initializer creates an instance of the class `lua4swift.VirtualMachine`.

   - Parameters:
     - openLibs: Load the Lua standard libraries, if this parameters is true; otherwise the standard libraries are not
                 loaded.
   */
  public init(openLibs: Bool = true) {
    self.vm = VirtualMachine(openLibs: openLibs)
    VMRegistry.shared.register(vm: self)
  }

  /**
   Initialize the virtual machine with a pre-initialized raw Lau virtual machine.

   - Parameters:
     - vm: the pre-initialized raw Lau virtual machine
   */
  public init(vm: VirtualMachine) {
    self.vm = vm
    VMRegistry.shared.register(vm: self)
  }

  deinit {
    VMRegistry.shared.deregister(vm: self)
  }


  // MARK: - Public Methods

  public func toReference<T: CustomTypeImplementation>(_ obj: T) -> Userdata {
    return vm.createUserdata(obj)
  }
}
