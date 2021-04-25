//
//  LuaVMRegisterCustomTypeSpec.swift
//  
//
//  Created by Thomas Bonk on 25.04.21.
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

class Car: CustomTypeImplementation {

  var name: String = ""

  // MARK: - Descriptor

  static let descriptor: CustomTypeDescriptor = CustomTypeDescriptor(
    constructor: FunctionDescriptor("new", fn: { args in
      return .value(Car())
    }),
    functions: [],
    methods: [
      MethodDescriptor("getName", fn: { instance, args in
        let car = instance as! Car
        return .value(car.name)
      }),
      MethodDescriptor("setName", fn: { instance, args in
        let car = instance as! Car

        car.name = args.string
        return .nothing
      })
    ]
  )
}

class LuaVMRegisterCustomTypeSpec: QuickSpec {

  override func spec() {

    describe("Register Custom Type") {
    }

  }
}
