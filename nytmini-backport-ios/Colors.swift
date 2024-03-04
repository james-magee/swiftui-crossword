//
//  Colors.swift
//  nytmini-backport-ios
//
//  Created by James Magee on 2/24/24.
//

import UIKit
import SwiftUI

/**
 *      color logic:
 *         1. start with a color palette
 *         2. assign different elements of the app to colors of the palette
 *            experiment at two levels: color palette, and which elements have which colors
 */

// Light Palette
let primaryLight    = UIColor(red: 255/255, green: 242/255, blue: 207/255, alpha: 1.0)
let secondaryLight  = UIColor.black
let tertiaryLight   = UIColor.orange
let quaternarylight = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)

// Dark Palette
let primaryDark     = UIColor.black
let secondaryDark   = UIColor(red: 99/255, green: 84/255, blue: 39/255, alpha: 1.0)
let tertiaryDark    = UIColor(red: 105/255, green: 42/255, blue: 1/255, alpha: 1.0)
let quarternaryDark = UIColor(red: 45/255, green: 45/255, blue: 35/255, alpha: 1.0)


extension Color {
  
  static var primaryColor: Color {
    Color(UIColor{ $0.userInterfaceStyle == .dark ? primaryDark : primaryLight})
  }
  
  static var secondaryColor: Color {
    Color(UIColor{ $0.userInterfaceStyle == .dark ? secondaryDark : secondaryLight})
  }
  
  static var tertiaryColor: Color {
    Color(UIColor{ $0.userInterfaceStyle == .dark ? tertiaryDark : tertiaryLight})
  }
  
  static var quaternaryColor: Color {
    Color(UIColor{ $0.userInterfaceStyle == .dark ? quarternaryDark : quaternarylight})
  }
}


//
//enum Colors {
//  
//  // square colors
//  case openSquare
//  case closedSquare
//  case openSquareBorder
//  case closedSquareBorder
//  case squareHightlighted
//  case axisHighlighted
//  case number
//  
//  // hint colors
//  case hintBanner
//  
//  // other colors
//  case wholeAppBackground
//  
//  var lightValue: Color {
//    var color = Color.clear
//    switch self {
//    case .openSquare, .wholeAppBackground:
//      color = Color(red: 255/255, green: 242/255, blue: 207/255)
//      //      color = Color(red: 255/255, green: 233/255, blue: 171/255)
//    case .closedSquareBorder:
//      color = Color(red: 255/255, green: 236/255, blue: 184/255)
//    case .closedSquare, .openSquareBorder:
//      color = Color.black
//    case .squareHightlighted:
//      color = Color(UIColor.orange).opacity(0.55)
//    case .axisHighlighted:
//      color = Color(UIColor.systemGray6)
//    case .number:
//      color = Color.black
//      
//    case .hintBanner:
//      color = Color(UIColor.systemGray6)
//    }
//    return color
//  }
//  
//  var darkValue: Color {
//    var color = Color.clear
//    switch self {
//    case .wholeAppBackground:
//      color = .black
//    case .openSquare, .closedSquareBorder:
//      color = Color(red: 99/255, green: 84/255, blue: 39/255)
//    case .closedSquare, .openSquareBorder:
//      color = .black
//    case .squareHightlighted:
//      color = Color.yellow.opacity(0.25)
//    case .axisHighlighted:
//      color = .white.opacity(0.25)
//    case .number:
//      color = .white
//    case .hintBanner:
//      color = .white
//    }
//    return color
//  }
//}
