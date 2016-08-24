//
//  Double_AsFraction.swift
//  Double_AsFraction
//
//  Created by Tony Rizzo on 8/21/16.
//  Copyright © 2016 Koteray. All rights reserved.
//

import Foundation

extension Double {
    
    enum RoundTechnique {
        case Round
        case Up
        case Down
    }
    
    /// The positive number to the left of the decimal point
    var number: Double {
        get {
            return floor(fabs(self))
        }
    }
    
    /// The positive number to the right of the decimal point
    var decimal: Double {
        get {
            return fabs(self) - number
        }
    }

    /**
     
     Fractions must be a sorted array of fraction - sort by the value.
     
     
     */
    
    func asFraction(fractions: [Fraction],roundTechnique: RoundTechnique) -> String {
        
        let bestGuess = Int(floor(decimal * Double(fractions.count)))
        
        return findNearest(bestGuess, fractions: fractions, roundTechnique: roundTechnique)
        
    }
    
    private func findNearest(bestGuess: Int, fractions: [Fraction], roundTechnique: RoundTechnique) -> String {
        
        switch true {
        case self.decimal > fractions[bestGuess].value && self.decimal < fractions[bestGuess + 1].value:
            // Right where we need to be
            switch roundTechnique {
            case .Down:
                return showAnswer(fractions[bestGuess])
            case .Up:
                return showAnswer(fractions[bestGuess + 1])
            case .Round:
                if (self.decimal - fractions[bestGuess].value) < (fractions[bestGuess + 1].value - self.decimal) {
                    return showAnswer(fractions[bestGuess])
                } else {
                    return showAnswer(fractions[bestGuess+1])
                }
            }
            
        // These are if we were close
        case self.decimal < fractions[bestGuess].value && bestGuess>0:
            return findNearest(bestGuess-1, fractions: fractions, roundTechnique: roundTechnique)
        case self.decimal > fractions[bestGuess].value && bestGuess<fractions.count-1:
            return findNearest(bestGuess+1, fractions: fractions, roundTechnique: roundTechnique)
            
        // These should never be called if the algorithm is correct, but just in case..
        case self.decimal < fractions[bestGuess].value && !(bestGuess>0):
            return "Too Small"
        case self.decimal > fractions[bestGuess].value && !(bestGuess<fractions.count-1):
            return "Too Big"
        default:
            return "Default case"
        }
        
    }
    
    
    private func showAnswer(fraction: Fraction) -> String {
        return "\(Int(floor(self)) + fraction.adder) \(fraction.unicode)".stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
}