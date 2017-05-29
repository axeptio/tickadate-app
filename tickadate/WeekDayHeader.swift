//
//  WeekDayHeader.swift
//  tickadate
//
//  Created by Romain Bessuges-Meusy on 11/05/2017.
//  Copyright © 2017 Agilitation. All rights reserved.
//

import UIKit
import DynamicColor

@IBDesignable
class WeekDayHeader: BorderedView {
  
  var labels:[UILabel] = []
  
  func prepareLabels() {
    
    self.borderOnLeftSide = false
    self.borderOnRightSide = false
    self.borderOnTopSide = true
    self.borderOnBottomSide = true
    
    let symbols = Calendar.current.shortWeekdaySymbols
    let first = Calendar.current.firstWeekday - 1
    var weekdaySymbol:String!
    var weekdayIndex:Int!
    
    for index in first ... first + 7 {
      
      weekdayIndex = index > 6 ? index - 7 : index
      weekdaySymbol = symbols[weekdayIndex]
      
      let label = UILabel()
      label.font = UIFont.boldSystemFont(ofSize: 14)
      label.textColor = UIColor.white
      label.textAlignment = .center
      label.text = weekdaySymbol
      label.layer.shadowRadius = 1
      label.layer.shadowColor = UIColor.black.cgColor
      label.layer.shadowOffset = CGSize(width: 0, height: 1)
      label.layer.shadowOpacity = 1
      self.addSubview(label)
      labels.append(label)
    }
  }
  
  override func draw(_ rect: CGRect) {
    
    super.draw(rect)
    
    if labels.count == 0 {
      self.prepareLabels()
    }
    
    let labelWidth:CGFloat! = floor(rect.width / 7)
    var labelOffset:CGFloat! = 0.0

    for label in labels {

      label.frame.origin.x = labelOffset
      label.frame.size.width = labelWidth
      label.frame.size.height = rect.height
      labelOffset.add(labelWidth)
    }
  }
}