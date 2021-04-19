//
//  ValuesSpec.swift
//  
//
//  Created by Thomas Bonk on 18.04.21.
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

final class ValuesSpec: QuickSpec {

  override func spec() {

    describe("Test whether returned values are valid") {
      it("Value.bool is valid") {
        let vm = LuaVirtualMachine()

        Value.bool(value: true, name: "boolVal").push(vm)

        let val: Bool = try Value.bool().pop(vm).value()

        expect(val).to(equal(true))
      }

      it("Value.double is valid") {
        let vm = LuaVirtualMachine()

        Value.double(value: 13.37, name: "doubleVal").push(vm)

        let val: Double = try Value.double().pop(vm).value()

        expect(val).to(equal(13.37))
      }

      it("Value.int is valid") {
        let vm = LuaVirtualMachine()

        Value.int(value: 1337, name: "intVal").push(vm)

        let val: Int64 = try Value.int().pop(vm).value()

        expect(val).to(equal(1337))
      }

      it("Value.string is valid") {
        let vm = LuaVirtualMachine()

        Value.string(value: "aString", name: "strVal").push(vm)

        let val: String = try Value.string().pop(vm).value()

        expect(val).to(equal("aString"))
      }

      it("Value.void is valid") {
        let vm = LuaVirtualMachine()

        Value.void(value: (), name: "voidVal").push(vm)

        let void = try Value.void().pop(vm)
        let val: Void = try void.value()

        expect(val == ()).to(beTruthy())
      }
    }

    describe("Test whether type mismatch errors are thrown") {
      it("Value.bool mismatches Value.string") {
        let vm = LuaVirtualMachine()

        Value.bool(value: true, name: "val").push(vm)

        expect {
          let _: String = try Value.string().pop(vm).value()
        }.to(throwError())
      }

      it("Value.bool mismatches Value.double") {
        let vm = LuaVirtualMachine()

        Value.bool(value: true, name: "val").push(vm)

        expect {
          let _: Double = try Value.double().pop(vm).value()
        }.to(throwError())
      }

      it("Value.bool mismatches Value.int") {
        let vm = LuaVirtualMachine()

        Value.bool(value: true, name: "val").push(vm)

        expect {
          let _: Int64 = try Value.int().pop(vm).value()
        }.to(throwError())
      }

      it("Value.string mismatches Value.bool") {
        let vm = LuaVirtualMachine()

        Value.string(value: "aString", name: "val").push(vm)

        expect {
          let _: Bool = try Value.bool().pop(vm).value()
        }.to(throwError())
      }
    }

  }

}
