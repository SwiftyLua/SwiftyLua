//
//  Constants.swift
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
import CLua

// MARK: - Constants

public extension Int32 {

  /// Index value for the top of stack
  static var TopOfStack: Int32 { -1 }
  static var RegistryIndex: Int32 = -LUAI_MAXSTACK - 1000
}

public func UpvalueIndex(_ i: Int32) -> Int32 {
  return Int32.RegistryIndex - i
}
