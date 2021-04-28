//
//  LuaVM+LoadCode.swift
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

public extension LuaVM {

  /**
   Execute Lua code that is loaded from a file.

   - Parameters:
     - url: the file url
     - args: the arguments that shall be passed to the code
   - Returns: the results of the code execution
   - Throws: `LuaVMError.loadError` in case of an error
   */
  @discardableResult
  func execute(url: URL, args: [Value] = []) throws -> VirtualMachine.EvalResults {
    let result = vm.eval(url, args: args)

    if case VirtualMachine.EvalResults.error(let message) = result {
      throw LuaVMError.loadError(message: message)
    }

    return result
  }

  /**
   Execute Lua code that is loaded from a string.

   - Parameters:
     - string: the string with the code
     - args: the arguments that shall be passed to the code
   - Returns: the results of the code execution
   - Throws: `LuaVMError.loadError` in case of an error
   */
  @discardableResult
  func execute(string: String, args: [Value] = []) throws -> VirtualMachine.EvalResults {
    let result = vm.eval(string, args: args)

    if case VirtualMachine.EvalResults.error(let message) = result {
      throw LuaVMError.loadError(message: message)
    }

    return result
  }
}
