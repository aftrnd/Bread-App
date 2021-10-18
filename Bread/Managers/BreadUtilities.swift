//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import Foundation

/// Base class to handle budget data calculation and storage
public class BreadUtilities {
    
    /// Current selected month by the user
    static public var selectedMonth: String = Date().month
    
    /// Returns the total number of transactions for a category for this current selected month
    /// - Parameter category: a spending category
    /// - Returns: returns a number/integer
    static public func numberOfTransactions(forCategory category: String) -> Int {
        let totalExpense = dailyExpenses(forCategory: category)
        var sum: Int = 0
        totalExpense.compactMap({ $0.value }).forEach { (dailyData) in
            dailyData.forEach { (_) in sum += 1 }
        }
        return sum
    }
    
    /// Returns the total amount of money spent for a category for this current selected month
    /// - Parameter category: a spending category
    /// - Returns: returns a double
    static public func totalAmountSpent(forCategory category: String) -> Double {
        let totalExpense = dailyExpenses(forCategory: category)
        var sum: Double = 0.0
        totalExpense.compactMap({ $0.value }).forEach { (allData) in
            allData.forEach { (dailyData) in
                if let expense = dailyData["amount"] as? Double { sum += expense }
            }
        }
        return sum
    }
    
    /// Returns all expenses for a given category, for a specific day of this current selected month
    /// - Parameter category: a spending category
    /// - Returns: returns a dictionary where each key represents the day of this current selected month
    static public func dailyExpenses(forCategory category: String) -> [String: [[String: Any]]] {
        var aggregatedData = [String: [[String: Any]]]()
        datesArray.forEach { (date) in
            if let data = UserDefaults.standard.array(forKey: "\(date)_\(category)") as? [[String: Any]] {
                aggregatedData[date] = data
            }
        }
        return aggregatedData
    }
    
    /// Returns a tuple with the description/location of the transaction and amount
    /// - Parameters:
    ///   - index: transaction at index
    ///   - category: a spending category
    /// - Returns: tuple with description and amount
    static public func transaction(atIndex index: Int, forCategory category: String) -> (description: String, amount: Double) {
        let expenses = dailyExpenses(forCategory: category)
        let flatMapExpenses = expenses.values.compactMap({ $0 }).flatMap({ $0 })[index]
        guard let description = flatMapExpenses["description"] as? String, let amount = flatMapExpenses["amount"] as? Double else {
            return ("", 0.0)
        }
        return (description, amount)
    }
    
    /// Returns an array of days for this current selected month
    /// - Returns: returns an array of strings
    static var datesArray: [String] {
        var lastDates = [String]()
        var currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        if currentMonth != (Month.allCases.firstIndex(where: { $0.rawValue == selectedMonth })! + 1) {
            var components = DateComponents()
            var updatedDateComponents = DateComponents()
            updatedDateComponents.month = (Month.allCases.firstIndex(where: { $0.rawValue == selectedMonth })! + 1)
            updatedDateComponents.year = Calendar.current.component(.year, from: currentDate)
            let range = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: updatedDateComponents)!)!
            components.month = (Month.allCases.firstIndex(where: { $0.rawValue == selectedMonth })! + 1)
            components.day = range.upperBound - 1
            components.year = Calendar.current.component(.year, from: currentDate)
            currentDate = Calendar.current.date(from: components)!
        }
        for dateIndex in 0..<31 {
            if let date = Calendar.current.date(byAdding: .day, value: -dateIndex, to: currentDate) {
                if Calendar.current.isDate(date, equalTo: currentDate, toGranularity: .month) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    lastDates.append(dateFormatter.string(from: date))
                }
            }
        }
        return lastDates
    }
    
    // Returns a unique key for storing expenses for a given category for today's date
    /// - Parameters:
    ///   - date: today's date
    ///   - category: a spending category
    /// - Returns: returns a formatted key
    static func key(forDate date: Date, category: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return "\(dateFormatter.string(from: date))_\(category)"
    }
    
    // Store the expense details for a category
    /// - Parameters:
    ///   - category: a spending category
    ///   - amount: amount spent to be tracked
    ///   - description: description of your transaction
    static public func logExpense(forCategory category: String, amount: Double, description: String) {
        var existingExpense = [[String: Any]]()
        if let currentExpenses = UserDefaults.standard.array(forKey: key(forDate: Date(), category: category)) as? [[String: Any]] {
            existingExpense = currentExpenses
        }
        existingExpense.append(["amount": amount, "description": description])
        UserDefaults.standard.setValue(existingExpense, forKey: key(forDate: Date(), category: category))
        UserDefaults.standard.synchronize()
    }
}

// MARK: - Useful Extensions
public extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}

public extension Double {
    var dollarAmount: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        return currencyFormatter.string(from: NSNumber(value: self)) ?? "- -"
    }
}
