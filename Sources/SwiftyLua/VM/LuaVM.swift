//
//  LuaVM.swift
//  
//
//  Created by Thomas Bonk on 23.04.21.
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

/**
 High level interface for the Lua virtual machine.

 This class wraps the class `lua4swift.VirtualMachine`
 */
public class LuaVM {

  // MARK: - Public Properties

  public let vm: VirtualMachine


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
  }

  /**
   Initialize the virtual machine with a pre-initialized raw Lau virtual machine.

   - Parameters:
     - vm: the pre-initialized raw Lau virtual machine
   */
  public init(vm: VirtualMachine) {
    self.vm = vm
  }
}
