//
//  CGFloatExtension.swift
//  HAP
//
//  Created by Simen Fonnes on 06.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

extension CGFloat {
    func isEqualTo(other:CGFloat, decimalsToCompare:Int) -> Bool{
        let powerOfTen = pow(10, CGFloat(decimalsToCompare))
        return Int(self * powerOfTen) == Int(other * powerOfTen)
    }
}