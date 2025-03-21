//
//  CustomTypeInstanceSpec.swift
//  
//
//  Created by Thomas Bonk on 23.04.21.
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

class CustomTypeInstanceSpec: QuickSpec {

  override class func spec() {

    describe("The extension of CustomTypeInstance returns the right class name") {

      class MyClass: CustomTypeImplementation {
        static func descriptor(_ vm: LuaVM) -> CustomTypeDescriptor {
          return
            CustomTypeDescriptor(
              constructor: ConstructorDescriptor { (args: Arguments) -> SwiftReturnValue in
                return .value(vm.toReference(MyClass()))
              })
        }
      }


      it("The classname shall be 'MyClass'") {
        expect(MyClass.luaTypeName()).to(equal("MyClass"))
      }

    }
  }
}
