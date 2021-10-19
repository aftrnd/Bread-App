//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI
import Foundation

// Months of the year
enum Month: String, CaseIterable {
    case January, February, March, April, May, June, July, August, September, October, November, December
}

// A list of categories to track expenses
enum SpendingCategory: String, CaseIterable {
    case food
    case housing
    case clothing
    case entertainment
    case transportation
    case other
}

// Main data manager for the app
class BreadDataManager: ObservableObject {
    
    // These properties are dynamic and will invoke UI changes
    @Published var selectedMonth: String = Date().month
    @Published var budget: Double = 0.0
    @Published var spent: Double = 0.0
    
    // Default initizlier
    init() {
        getBudgetNumbers()
    }
    
    // Private functions
    // Get budget/spent numbers for `selectedMonth`
    private func getBudgetNumbers() {
        spent = 0.0
        budget = UserDefaults.standard.double(forKey: "budget_\(selectedMonth)")
        SpendingCategory.allCases.forEach { (category) in
            spent += expensesTotal(forCategory: category)
        }
    }
    
    private func updateUserInterfaceData() {
        BreadUtilities.selectedMonth = selectedMonth
        getBudgetNumbers()
    }
    
    // Public functions
    func selectPreviousMonth() {
        if selectedMonth == Month.January.rawValue { return }
        let currentMonthIndex = Month.allCases.firstIndex(of: Month(rawValue: selectedMonth)!)!
        let previousMonthIndex = Month.allCases.index(before: currentMonthIndex)
        selectedMonth = Month.allCases[previousMonthIndex].rawValue
        updateUserInterfaceData()
    }
    
    func selectNextMonth() {
        if selectedMonth == Month.December.rawValue { return }
        let currentMonthIndex = Month.allCases.firstIndex(of: Month(rawValue: selectedMonth)!)!
        let nextMonthIndex = Month.allCases.index(after: currentMonthIndex)
        selectedMonth = Month.allCases[nextMonthIndex].rawValue
        updateUserInterfaceData()
    }
    
    func udpateBudget(value: Double) {
        UserDefaults.standard.setValue(value, forKey: "budget_\(selectedMonth)")
        UserDefaults.standard.synchronize()
        updateUserInterfaceData()
    }
    
    func transactionsCount(forCategory category: SpendingCategory) -> Int {
        BreadUtilities.numberOfTransactions(forCategory: category.rawValue)
    }
    
    func expensesTotal(forCategory category: SpendingCategory) -> Double {
        BreadUtilities.totalAmountSpent(forCategory: category.rawValue)
    }
    
    func transactionDetails(atIndex index: Int, forCategory category: SpendingCategory) -> (description: String, amount: Double) {
        BreadUtilities.transaction(atIndex: index, forCategory: category.rawValue)
    }
    
    func logExpense(forCategory category: SpendingCategory, amount: Double, description: String) {
        BreadUtilities.logExpense(forCategory: category.rawValue, amount: amount, description: description)
        updateUserInterfaceData()
        objectWillChange.send()
    }
}
