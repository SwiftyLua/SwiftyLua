//
//  UsageSpec.swift
//  SwiftyLua
//
//  Created by Thomas Bonk on 27.04.21.
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

@testable import SwiftyLua

class UsageSpec: QuickSpec {

  override class func spec() {

    describe("Instantiating a Lua virtual machine") {
      /**
       The class `LuaVM` is represents a Lua virtual machine. Its constructor accepts a boolean value that determines
       whether the standard Lua libraries shall be loaded or not. The default value is `true` for loading the standard
       libraries.
       */

      it("Instantiate a Lua VM without loading the Lua standard library") {
        let _ = LuaVM(openLibs: false)
      }

      it("Instantiate a Lua VM with loading the Lua standard library") {
        // The parameter `openLibs` defaults to true, so you don't need to pass it to the constructor.
        let _ = LuaVM()
      }
    }

    describe("Executing Lua code") {
      it("Execute code from a string") {
        let lua = LuaVM()
        let result = try lua.execute(string: """
          function fib(m)
            if m < 2 then
              return m
            end
            return fib(m-1) + fib(m-2)
          end

          return fib(15);
          """)

        if case VirtualMachine.EvalResults.values(let returnValue) = result {
          NSLog("Result of fib(15) = \((returnValue[0] as! Number).toInteger())")
        }
      }

      it("Execute code from a file") {
        let lua = LuaVM()
        let result =
          try lua.execute(
            url: Bundle.module.url(forResource: "fib", withExtension: "lua", subdirectory: "LuaScripts")!)

        if case VirtualMachine.EvalResults.values(let returnValue) = result {
          NSLog("Result of fib(15) = \((returnValue[0] as! Number).toInteger())")
        }
      }
    }

    describe("Setting a global variables and structs") {

      it("Register a global variable") {
        let lua = LuaVM()
        
        lua.globals["global_var"] = 1337

        let result = try lua.execute(string: "return global_var;")

        if case VirtualMachine.EvalResults.values(let returnValue) = result {
          NSLog("globale_var = \((returnValue[0] as! Number).toInteger())")
        }
      }

      it("Register a global struct") {
        let lua = LuaVM()
        let point = lua.vm.createTable()

        point["x"] = 0.5
        point["y"] = 1.5

        lua.globals["point"] = point

        let result = try lua.execute(string: "return point.x, point.y;")

        if case VirtualMachine.EvalResults.values(let returnValue) = result {
          NSLog("(x, y) = (\((returnValue[0] as! Number).toDouble()), \((returnValue[1] as! Number).toDouble())) ")
        }
      }
    }

    describe("Registering a native Swift function") {
      it("Register a native Swift function and call it") {
        let lua = LuaVM()

        lua.registerFunction(
          FunctionDescriptor(
            name: "fib",
            parameters: [Int.arg],
            fn: { (args: Arguments) -> SwiftReturnValue in

              let n = args.number.toInteger()

              var fib = 1
              var prevFib = 1

              for _ in 2..<n {
                let temp = fib;

                fib = fib + prevFib
                prevFib = temp
              }

              return .values([fib])
            }))

        let result = try lua.execute(string: "return fib(15);")

        if case VirtualMachine.EvalResults.values(let returnValue) = result {
          NSLog("Result of fib(15) = \((returnValue[0] as! Number).toInteger())")
        }
      }
    }

    describe("Registering a native Swift type (class or struct)") {

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

      it("Register a native Swift type and instantiate it") {
        let lua = LuaVM()

        lua.registerCustomType(type: Car.self)
        let result = try lua
          .execute(string: """
            myCar = Car.new();

            myCar:setName('Volvo');

            return myCar;
          """)

        if case VirtualMachine.EvalResults.values(let returnValue) = result {
          let car: Car = (returnValue[0] as! Userdata).toCustomType()

          NSLog("myCar.name = \(car.name)")
        }
      }
    }

  }

}
