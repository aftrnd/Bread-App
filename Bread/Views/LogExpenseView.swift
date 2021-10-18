//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI

/// Main view to log expenses
struct LogExpenseView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager: BudgetizeDataManager
    @State private var amount: Double = 0.00
    @State private var spendLocation: String = ""
    @State private var spendCategory: SpendingCategory?
    @State private var showSpendCategories: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Text(amount.dollarAmount).font(.system(size: 50)).bold()
                Text("How much did you spend?").foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).frame(width: UIScreen.main.bounds.width-60, height: 1).padding([.leading, .trailing]).padding()
                HStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        TextField("ex: Apple", text: $spendLocation).multilineTextAlignment(.center).font(.system(size: 30))
                        Text("Where did you spend?").foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    }.frame(width: UIScreen.main.bounds.width/2.5)
                    RoundedRectangle(cornerRadius: 10).frame(width: 1, height: 50).padding([.leading, .trailing])
                    VStack(spacing: 0) {
                        Text(spendCategory?.rawValue.capitalized ?? "ex: Food").font(.system(size: 30))
                            .font(.system(size: 30)).opacity(spendCategory != nil ? 1.0 : 0.25)
                            .onTapGesture { showSpendCategories = true }
                        Text("Spending Category").foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    }.frame(width: UIScreen.main.bounds.width/2.5)
                }.padding([.leading, .trailing], 20).opacity(0.7)
            }.lineLimit(1).minimumScaleFactor(0.5).frame(height: UIScreen.main.bounds.height/2.5)
            Spacer()
            ZStack {
                LinearGradient(gradient: Gradient(colors: AppConfig.headerGradient), startPoint: .top, endPoint: .bottom)
                    .mask(RoundedCorner(radius: 45, corners: [.topLeft, .topRight])).shadow(color: Color(#colorLiteral(red: 0.8827491403, green: 0.9036039114, blue: 0.9225834608, alpha: 1)), radius: 10, x: 0, y: -10)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    CustomNumberInputView(amount: $amount)
                    Spacer()
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        if let category = spendCategory {
                            manager.logExpense(forCategory: category, amount: amount, description: spendLocation)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Add Transaction").font(.system(size: 20)).fontWeight(.medium)
                            .padding().padding([.leading, .trailing], 35).foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 40).foregroundColor(.blue))
                    }).disabled(!isTransactionValid).opacity(isTransactionValid ? 1 : 0.5)
                }.padding(20)
            }
        }
        .actionSheet(isPresented: $showSpendCategories, content: {
            ActionSheet(title: Text("Choose a category"), message: nil, buttons: actionSheetButtons)
        })
    }
    
    /// Determine if the transaction details are filled out
    private var isTransactionValid: Bool {
        spendCategory != nil && spendLocation != "ex: Amazon" && amount != 0.00
    }
    
    /// Action sheet category buttons
    private var actionSheetButtons: [ActionSheet.Button] {
        var buttons = [ActionSheet.Button]()
        SpendingCategory.allCases.forEach { (category) in
            buttons.append(ActionSheet.Button.default(Text(category.rawValue.capitalized), action: {
                spendCategory = category
            }))
        }
        buttons.append(ActionSheet.Button.cancel())
        return buttons
    }
}

/// Custom Numbers Input
struct CustomNumberInputView: View {
    
    @Binding var amount: Double
    @State var fontSize: CGFloat = 45
    @State var color: Color = .white
    @State private var formattedNumber: String = ""
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let numbers = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "", "0", "<"]
    
    // MARK: - Main rendering function
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(0..<numbers.count, id: \.self, content: { index in
                Button(action: {
                    if numbers[index] == "<" {
                        formattedNumber = "\(formattedNumber.dropLast())"
                    } else {
                        formattedNumber.append(numbers[index])
                    }
                    if let doubleValue = Double(formattedNumber) {
                        amount = doubleValue * 0.01
                    } else {
                        amount = 0.0
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }, label: {
                    if numbers[index] == "<" {
                        Image(systemName: "arrow.left").font(.system(size: 40))
                    } else {
                        Text(numbers[index])
                    }
                })
                .lineLimit(1).minimumScaleFactor(0.5).font(.system(size: fontSize)).foregroundColor(color)
                .frame(width: UIScreen.main.bounds.width/4)
            })
        }
    }
}

// MARK: - Render preview UI
struct LogExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        LogExpenseView(manager: BudgetizeDataManager())
    }
}
