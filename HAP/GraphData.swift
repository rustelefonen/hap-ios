//
//  GraphData.swift
//  HAP
//
//  Created by Fredrik Loberg on 04/02/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class GraphData {    
    var data: [CGFloat]
    var lineColor: UIColor
    var gradientFillTopColor: UIColor?
    var gradientFillBottomColor: UIColor?
    
    convenience init(data: [CGFloat]){
        self.init(data: data, lineColor: UIColor.white, gradientFillTopColor: nil, gradientFillBottomColor: nil)
    }
    
    init(data: [CGFloat], lineColor: UIColor, gradientFillTopColor: UIColor?, gradientFillBottomColor: UIColor?){
        self.data = data
        self.lineColor = lineColor
        self.gradientFillTopColor = gradientFillTopColor
        self.gradientFillBottomColor = gradientFillBottomColor
    }
}
