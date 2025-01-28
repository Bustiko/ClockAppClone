//
//  Extension.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 16.08.2024.
//

import SwiftUI

enum Time {
    case hour
    case minute
    case second
}
extension Binding where Value == String {
    func max(_ limit: Int, time: Time) -> Self {
        
        DispatchQueue.main.async {
            
            if self.wrappedValue.count == 1 {
                self.wrappedValue = "0" + self.wrappedValue
            }else if self.wrappedValue.isEmpty {
                self.wrappedValue = "00"
            }
            
            if self.wrappedValue.count > limit && self.wrappedValue.first != "0"{
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }else if self.wrappedValue.count > limit && self.wrappedValue.first == "0" {
                self.wrappedValue = String(self.wrappedValue.dropFirst())
            }
            if time != Time.hour {
                if self.wrappedValue.count == limit, let secondLastChar = self.wrappedValue.dropLast().last, let secondLastDigit = Int(String(secondLastChar)) {
                    
                    if secondLastDigit > 5 {
                        self.wrappedValue = String(self.wrappedValue.dropLast())
                    }
                }
            }
           
            
        }
        return self
        
    }
}
