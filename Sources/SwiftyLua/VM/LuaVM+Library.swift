//
//  LuaVM+Library.swift
//  
//
//  Created by Thomas Bonk on 25.04.21.
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

public extension LuaVM {

  /**
   Create a library and call a closure that add functions and custom types to the library.

   - Parameters:
     - name: the name of the library
     - registerBlock: the closre that creates registers the function and custom types with the library.
   - Returns: the created library
   */
  func createLibrary(_ name: String, registerBlock: (Table) -> ()) -> Table {
    precondition(name.isEmpty)

    let library = vm.createTable()

    registerBlock(library)

    globals[name] = library

    return library
  }
}
