//
//  CustomTypeDescriptor.swift
//  
//
//  Created by Thomas Bonk on 24.04.21.
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
import lua4swift

/**
 Describe a custom type that shall be registered.
 */
public struct CustomTypeDescriptor {
  /// Constructor descriptor for the custom type
  public var constructor: FunctionDescriptor

  /// Static functions of the custom type.
  public var functions: [FunctionDescriptor]

  /// Instance metheods of the custom type.
  public var methods: [MethodDescriptor]
}
