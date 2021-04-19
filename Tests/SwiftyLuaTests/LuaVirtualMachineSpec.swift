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

final class LuaVirtualMachineSpec: QuickSpec {

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

    describe("Calling Lua function from swift") {
      it("Call method without parameters and without return values") {
        let vm = LuaVirtualMachine()

        vm.openLibraries()

        try vm.execute(code: """
          function no_params_no_return_value()
          end
          """)

        try vm.call(function: "no_params_no_return_value", parameters: [])
      }

      it("Call method one string parameter and without return values") {
        let vm = LuaVirtualMachine()

        vm.openLibraries()

        try vm.execute(code: """
          function no_params_no_return_value(param1)
          end
          """)

        try vm.call(function: "no_params_no_return_value", parameters: [.string(value: "value", name: "param1")])
      }

      it("Call method one int parameter and an int return value") {
        let vm = LuaVirtualMachine()

        vm.openLibraries()

        try vm.execute(code: """
          function inc(n)
            return n + 1
          end
          """)

        var results = [Value.int(value: 0, name: "returnValue")]
        try vm.call(function: "inc", parameters: [.int(value: 11, name: "n")], result: &results)

        let val: Int64 = try results[0].value()
        expect(val).to(be(12))
        expect(results[0].name()).to(equal("returnValue"))
      }
    }
  }
}
