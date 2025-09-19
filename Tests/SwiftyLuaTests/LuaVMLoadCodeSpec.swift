//
//  LuaVMLoadCodeSpec.swift
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
import Nimble
import Quick

@testable import SwiftyLua

class LuaVMLoadCodeSpec: QuickSpec {

  override class func spec() {

    describe("Fundamental Tests") {

      it("Instantiate a LuaVM without loading the Lua standard libraries") {
        let _ = LuaVM(openLibs: false)
      }

      it("Instantiate a LuaVM with loading of the Lua standard libraries") {
        let _ = LuaVM(openLibs: true)
      }

      it("Instantiate a LuaVM with a pre-initialized raw virtual machine") {
        let vm = VirtualMachine()
        let _ = LuaVM(vm: vm)
      }
    }


    describe("Execute Lua Code ") {

      it("Execute Lua code from string with error ") {
        let vm = LuaVM()

        expect {
          try vm.execute(string: "This is a syntax error")
        }.to(throwError())
      }

      it("Execute Lua code from string and retrieve result") {
        let vm = LuaVM()

        if case VirtualMachine.EvalResults.values(let returnValues) = try vm.execute(string: "return 1337;") {
          expect((returnValues[0] as! Number).toInteger()).to(equal(1337))
        } else {
          expect("No return value received").to(equal(""))    // How to produce a failure without that heck?
        }
      }

      it("Execute Lua code from file with error ") {
        let vm = LuaVM()

        expect {
          try vm
            .execute(
              url: Bundle.module.url(forResource: "syntax_error", withExtension: "lua", subdirectory: "LuaScripts")!)
        }.to(throwError())
      }

      it("Execute Lua code from file and retrieve result") {
        let vm = LuaVM()
        let result = try vm
          .execute(
            url: Bundle.module.url(forResource: "return_1337", withExtension: "lua", subdirectory: "LuaScripts")!)

        if case VirtualMachine.EvalResults.values(let returnValues) = result {
          expect((returnValues[0] as! Number).toInteger()).to(equal(1337))
        } else {
          assertionFailure("Unexpected result")
        }
      }

    }

  }
}
