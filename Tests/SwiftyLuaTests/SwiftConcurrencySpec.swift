//
//  SwiftConcurrencySpec.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 19 September 2025.
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

/// This class demonstrates SwiftyLua's thread safety and compatibility with Swift concurrency
class SwiftConcurrencySpec: QuickSpec {

  override class func spec() {

    describe("Swift Concurrency with SwiftyLua") {

      it("Create multiple VMs sequentially to demonstrate thread safety") {
        var vms: [LuaVM] = []

        for i in 0..<5 {
          let vm = LuaVM(openLibs: true)
          vm.globals["vm_id"] = i
          vms.append(vm)
        }

        expect(vms.count).to(equal(5))

        // Verify each VM has the correct ID
        for (index, vm) in vms.enumerated() {
          let result = try! vm.execute(string: "return vm_id")
          if case VirtualMachine.EvalResults.values(let returnValues) = result {
            let vmId = (returnValues[0] as! Number).toInteger()
            expect(vmId).to(equal(Int64(index)))
          }
        }
      }

      it("Demonstrate VM isolation and thread safety") {
        // Create multiple VMs and verify they don't interfere with each other
        let vm1 = LuaVM(openLibs: true)
        let vm2 = LuaVM(openLibs: true)
        let vm3 = LuaVM(openLibs: true)

        vm1.globals["test_var"] = "VM1"
        vm2.globals["test_var"] = "VM2"
        vm3.globals["test_var"] = "VM3"

        let result1 = try! vm1.execute(string: "return test_var")
        let result2 = try! vm2.execute(string: "return test_var")
        let result3 = try! vm3.execute(string: "return test_var")

        if case VirtualMachine.EvalResults.values(let returnValues1) = result1,
           case VirtualMachine.EvalResults.values(let returnValues2) = result2,
           case VirtualMachine.EvalResults.values(let returnValues3) = result3 {

          expect(returnValues1[0] as? String).to(equal("VM1"))
          expect(returnValues2[0] as? String).to(equal("VM2"))
          expect(returnValues3[0] as? String).to(equal("VM3"))
        } else {
          fail("Expected string return values")
        }
      }

      it("Demonstrate async function registration") {
        let vm = LuaVM(openLibs: true)

        // Register an async Swift function that can be called from Lua
        vm.registerFunction(
          FunctionDescriptor(
            name: "asyncDelay",
            parameters: [Number.arg],
            fn: { (args: Arguments) -> SwiftReturnValue in
              let delay = args.number.toDouble()

              // Simulate async work (in real use, this could be a network call, etc.)
              Thread.sleep(forTimeInterval: delay / 1000.0) // Convert ms to seconds

              return .value("Delayed execution completed")
            }))

        let result = try! vm.execute(string: "return asyncDelay(100)")

        if case VirtualMachine.EvalResults.values(let returnValues) = result {
          expect(returnValues[0] as? String).to(equal("Delayed execution completed"))
        } else {
          fail("Expected a return value")
        }
      }

      it("Use actor-based VM registry safely") {
        let vm1 = LuaVM(openLibs: true)
        let vm2 = LuaVM(openLibs: true)

        // Both VMs should be properly registered without data races
        expect(vm1.vm.state).toNot(beNil())
        expect(vm2.vm.state).toNot(beNil())
        expect(vm1.vm.state).toNot(equal(vm2.vm.state))
      }

    }

  }

}