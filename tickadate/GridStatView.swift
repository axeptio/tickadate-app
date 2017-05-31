//
//  GridStatView.swift
//  tickadate
//
//  Created by Romain Bessuges-Meusy on 24/05/2017.
//  Copyright © 2017 Agilitation. All rights reserved.
//

import UIKit
import DynamicColor

struct GridStatValue {
  var label:String
  var value:Float
}

struct GridStatLayoutDirection {
  var first:LayoutDirection
  var second:LayoutDirection
  
  func isTransposed() -> Bool {
    return (self.second == .ltr || self.second == .rtl)
  }
  
  func isHorizontalAxisInversed() -> Bool {
    return (self.first == .rtl || self.second == .rtl)
  }
  
  func isVerticalAxisInversed() -> Bool {
    return (self.first == .btt || self.second == .btt)
  }
}

enum LayoutDirection {
  case ltr
  case rtl
  case ttb
  case btt
}

@IBDesignable
class GridStatView: UIView {
  
  var direction:GridStatLayoutDirection = GridStatLayoutDirection(first: .ltr, second: .ttb)
  var numberOfRows:Int = 4
  var numberOfCols:Int = 10
  var space:CGFloat = 6
  var values:[Float] = [0.3, 0.5, 0.8, 0.9, 1] {
    didSet {
      self.max = values.max() ?? 0
      self.setNeedsDisplay()
    }
  }
  
  var offsets:[Int] = []
  
  var max:Float = 0
  
  func index(x:Int, y:Int, width:Int, height:Int, direction:GridStatLayoutDirection) -> Int {
    var a:Int = 1
    var b:Int = 1
    var c:Int = 0
    var d:Int = 0
    
    if direction.isTransposed() {
      b = height
    } else {
      a = width
    }
    
    if direction.isHorizontalAxisInversed() {
      b = b * -1
      d = (width - 1) * height
    }
    
    if direction.isVerticalAxisInversed() {
      a = a * -1
      c = (height - 1) * width
    }
    
    return a * y + b * x + c + d
  }
  
  func offsetRange(index:Int) -> Int {
    var currentRange:Int = 0
    
    for (i, position) in self.offsets.enumerated(){
      if position < index {
        currentRange = i
      }
    }
    
    return currentRange
  }
  
  override func draw(_ rect: CGRect) {
    self.isOpaque = false
    self.backgroundColor = UIColor.clear
    
    if let context:CGContext =  UIGraphicsGetCurrentContext() {
      context.clear(rect)
      let cellWidth:CGFloat = (rect.width + space) / CGFloat(numberOfCols)  - space
      let cellHeight:CGFloat =  (rect.height + space) / CGFloat(numberOfRows)  - space

      for rowIndex in 0 ... numberOfRows - 1 {
        for colIndex in 0 ... numberOfCols - 1 {
          
          let index = self.index(x: colIndex, y: rowIndex, width: numberOfCols, height: numberOfRows, direction: self.direction)
          let offset = CGFloat(offsetRange(index: index)) * (cellWidth + space)
          
          var value:Float = 0
          if(values.count > index){
            value = (self.max > 0) ? values[index] / self.max : 0
          }
          let square:CGRect = CGRect(
            x: CGFloat(colIndex) * (cellWidth + space) + offset,
            y: CGFloat(rowIndex) * (cellHeight + space),
            width: cellWidth,
            height: cellHeight
          )
        
          let color:CGColor = (value == 0) ? DynamicColor(hexString: "EEEEEE").cgColor :  tintColor.tinted(amount: CGFloat(1 - value / 2)).cgColor
          DrawUtils.drawRect(onContext: context, inRect: square, color: color)
        }
      }
    }
  }
  
}
