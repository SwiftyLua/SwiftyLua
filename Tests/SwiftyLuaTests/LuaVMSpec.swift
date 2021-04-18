//
//  LuaVMSpec.swift
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
import Quick
import Nimble

@testable import SwiftyLua

final class LuaVMSpec: QuickSpec {

  override func spec() {

    describe("Instantiating a LuaVM") {

      it("Instantiate a LuaVM") {
        let _ = LuaVirtualMachine()
      }

      it("Instantiate a LuaVM and load all libraries") {
        let vm = LuaVirtualMachine()

        vm.openLibraries([.all])
      }

      it("Instantiate a LuaVM and load libraries by their identifiers") {
        let vm = LuaVirtualMachine()

        vm.openLibraries([.base, .coroutine, .debug, .io, .math, .os, .package, .string, .table, .utf8])
      }

    }

    describe("Excuting code") {

      it("Excute valid code") {
        let vm = LuaVirtualMachine()

        try vm.execute(code: "a = 1337")
      }

      it("Execute code with syntax error") {
        let vm = LuaVirtualMachine()

        expect {
          try vm.execute(code: "This is an error")
        }.to(throwError())
      }

      it("Execute code with function call") {
        let vm = LuaVirtualMachine()

        vm.openLibraries()

        try vm.execute(code: """
          function fib(m)
            if m < 2 then
              return m
            end
            return fib(m-1) + fib(m-2)
          end

          fib(35)
          """)
      }

    }
  }
}
