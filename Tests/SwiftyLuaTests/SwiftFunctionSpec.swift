//
//  SwiftFunctionSpec.swift
//  
//
//  Created by Thomas Bonk on 20.04.21.
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

final class SwiftFunctionSpec: QuickSpec {

  override func spec() {

    describe("Call Swift functions from Lua") {

      it("Register a Swift function and calling it") {
        func add(values: [Value]) -> [Value] {
          let a: Int64 = try! values[0].value()
          let b: Int64 = try! values[1].value()
          return [Value.int(value: a + b)]
        }

        let vm = LuaVirtualMachine()

          try vm.register(function: SwiftFunction("add", parameters: [.int(name: "a"), .int(name: "b")], returnValues: [.int(name: "a + b")], closure: add(values:)))

          var result = [Value.int(name: "add(1,2)")]
        try vm.execute(code: "return add(1,2)", results: &result)

        let val: Int64 = try result[0].value()
        expect(val).to(equal(3))
      }
      
    }

  }
}
