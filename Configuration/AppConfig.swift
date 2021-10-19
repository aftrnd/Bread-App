//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI
import Foundation

/// Basic app configurations
class AppConfig: NSObject {
    
    // MARK: - Views configuration
    static let headerTitle: String = "Hello, Nick!"
    static let headerGradient: [Color] = [Color(#colorLiteral(red: 0.2835162282, green: 0.283606559, blue: 0.2921500206, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]
    static let progressGradient: [Color] = [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(.blue)]
    static let monthBudgetLayerBackground: Color = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    static let overbudgetGradient: [Color] = [Color(#colorLiteral(red: 1, green: 0.6526550726, blue: 0.9900812507, alpha: 1)), Color(#colorLiteral(red: 0.9324082488, green: 0.3444498677, blue: 0.6237461509, alpha: 1))]
    static let categoryExpensesGradient: [Color] = [Color(#colorLiteral(red: 1, green: 0.6526550726, blue: 0.3911871046, alpha: 0.5)), Color(#colorLiteral(red: 0.9333333333, green: 0.3444498677, blue: 0.2549019608, alpha: 1))]
}
