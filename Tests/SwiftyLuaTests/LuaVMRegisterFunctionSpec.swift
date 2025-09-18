//
//  LuaVMRegisterFunctionSpec.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 24.04.21.
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
import Quick
import Nimble

@testable import SwiftyLua

class LuaVMRegisterFunctionSpec: QuickSpec {

  override class func spec() {

    describe("Register Functions") {

      it("Register a function, call it and retrieve its results") {
        let vm = LuaVM()

        vm
          .registerFunction(
            .init(name: "add_integers", parameters: [Number.arg, Number.arg]) { args in
              let (a, b) = (args.number, args.number)

              return .values([a.toInteger() + b.toInteger()])
            })

        if case VirtualMachine.EvalResults.values(let returnValues) = try vm.execute(string: "return add_integers(4, 16);") {
          expect((returnValues[0] as! Number).toInteger()).to(equal(20))
        } else {
          assertionFailure("Unexpected result")
        }
      }

      it("Register two functions, call them and retrieve their results") {
        let vm = LuaVM()

        vm
          .registerFunctions([
            .init(name: "one") { args in
              return .value(1)
            },
          .init(name: "two") { args in
              return .value(2)
            }])

        if case VirtualMachine.EvalResults.values(let returnValues) = try vm.execute(string: "return one();") {
          expect((returnValues[0] as! Number).toInteger()).to(equal(1))
        } else {
          assertionFailure("Unexpected result")
        }

        if case VirtualMachine.EvalResults.values(let returnValues) = try vm.execute(string: "return two();") {
          expect((returnValues[0] as! Number).toInteger()).to(equal(2))
        } else {
          assertionFailure("Unexpected result")
        }
      }

    }
  }

}
