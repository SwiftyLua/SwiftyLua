//
//  LuaVMRegisterCustomTypeSpec.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 25.04.21.
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

class Car: CustomTypeImplementation {

  public var name: String = ""

  // MARK: - Descriptor

  static func descriptor(_ vm: LuaVM) -> CustomTypeDescriptor {
    return CustomTypeDescriptor(
      constructor: ConstructorDescriptor { (args: Arguments) -> SwiftReturnValue in
        return .value(vm.toReference(Car()))
      },
      functions: [],
      methods: [
        MethodDescriptor("getName") { (instance: CustomTypeImplementation, args: Arguments) -> SwiftReturnValue in
          let car = instance as! Car
          return .value(car.name)
        },
        MethodDescriptor("setName", parameters: [String.arg]) { (instance: CustomTypeImplementation, args: Arguments) -> SwiftReturnValue in
          let car = instance as! Car

          car.name = args.string
          return .nothing
        }
      ]
    )
  }
}

class LuaVMRegisterCustomTypeSpec: QuickSpec {

  override class func spec() {

    describe("Register Custom Type") {

      it("Create and register custom type, then execute script") {
        let vm = LuaVM(openLibs: true)
        vm.registerCustomType(type: Car.self)

        expect {
          try vm
            .execute(
              url: Bundle.module.url(forResource: "register_custom_type", withExtension: "lua", subdirectory: "LuaScripts")!)
        }.toNot(throwError())
      }

      it("Retrieve Car object after execution") {
        let vm = LuaVM(openLibs: true)
        vm.registerCustomType(type: Car.self)

        // First execute the script that creates the car
        _ = try! vm.execute(
          url: Bundle.module.url(forResource: "register_custom_type", withExtension: "lua", subdirectory: "LuaScripts")!)

        expect {
          if case VirtualMachine.EvalResults.values(let returnValue) = try vm.execute(string: "return myCar;") {
            let car: Car = (returnValue[0] as! Userdata).toCustomType()

            expect(car.name).to(equal("Volvo"))
          } else {
            assertionFailure("Unexpected result")
          }
        }.toNot(throwError())
      }

      it("Retrieve Car name using method call") {
        let vm = LuaVM(openLibs: true)
        vm.registerCustomType(type: Car.self)

        // First execute the script that creates the car
        _ = try! vm.execute(
          url: Bundle.module.url(forResource: "register_custom_type", withExtension: "lua", subdirectory: "LuaScripts")!)

        expect {
          if case VirtualMachine.EvalResults.values(let returnValue) = try vm.execute(string: "return myCar:getName()") {
            let name = (returnValue[0] as! String)

            expect(name).to(equal("Volvo"))
          } else {
            assertionFailure("Unexpected result")
          }
        }.toNot(throwError())
      }

    }

  }
}
