//
//  Operators.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-20.
//  Copyright © 2016 Shaun Reiger. All rights reserved.
//

import UIKit

infix operator ** { associativity left precedence 160 }
func ** (left: CGFloat, right: CGFloat) -> CGFloat! {
    return pow(left, right)
}
infix operator **= { associativity right precedence 90 }
func **= (left: inout CGFloat, right: CGFloat) {
    left = left ** right
}
