//
//  Extensions.swift
//  sazometro
//
//  Created by Cristian Sánchez Pineda on 21/02/26.
//

import Foundation

extension Double {
    var formattedAsHours: String {
        if self < 1 {
            return "\(Int(self * 60)) min"
        } else if self == Double(Int(self)) {
            return String(format: "%.0fh", self)
        } else {
            let hours = Int(self)
            let minutes = Int((self - Double(hours)) * 60)
            return "\(hours)h \(minutes)min"
        }
    }
    
}
