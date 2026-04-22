//
//  LuaVMLoadCodeTests.swift
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
import Testing

@testable import SwiftyLua

@Suite("LuaVM Load Code")
struct LuaVMLoadCodeTests {

  @Suite("Fundamental Tests")
  struct FundamentalTests {

    @Test("Instantiate a LuaVM without loading the Lua standard libraries")
    func instantiateWithoutLibs() {
      let _ = LuaVM(openLibs: false)
    }

    @Test("Instantiate a LuaVM with loading of the Lua standard libraries")
    func instantiateWithLibs() {
      let _ = LuaVM(openLibs: true)
    }

    @Test("Instantiate a LuaVM with a pre-initialized raw virtual machine")
    func instantiateWithRawVM() {
      let vm = VirtualMachine()
      let _ = LuaVM(vm: vm)
    }
  }

  @Suite("Execute Lua Code")
  struct ExecuteLuaCode {

    @Test("Execute Lua code from string with error")
    func executeStringWithError() throws {
      let vm = LuaVM()

      #expect(throws: (any Error).self) {
        try vm.execute(string: "This is a syntax error")
      }
    }

    @Test("Execute Lua code from string and retrieve result")
    func executeStringAndRetrieveResult() throws {
      let vm = LuaVM()

      if case VirtualMachine.EvalResults.values(let returnValues) = try vm.execute(string: "return 1337;") {
        #expect((returnValues[0] as! Number).toInteger() == 1337)
      } else {
        Issue.record("No return value received")
      }
    }

    @Test("Execute Lua code from file with error")
    func executeFileWithError() throws {
      let vm = LuaVM()

      #expect(throws: (any Error).self) {
        try vm
          .execute(
            url: Bundle.module.url(
              forResource: "syntax_error", withExtension: "lua", subdirectory: "LuaScripts")!)
      }
    }

    @Test("Execute Lua code from file and retrieve result")
    func executeFileAndRetrieveResult() throws {
      let vm = LuaVM()
      let result = try vm
        .execute(
          url: Bundle.module.url(forResource: "return_1337", withExtension: "lua", subdirectory: "LuaScripts")!)

      if case VirtualMachine.EvalResults.values(let returnValues) = result {
        #expect((returnValues[0] as! Number).toInteger() == 1337)
      } else {
        Issue.record("Unexpected result")
      }
    }
  }
}
