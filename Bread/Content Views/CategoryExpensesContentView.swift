//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI

// Expenses list based on a given category
struct CategoryExpensesContentView: View {
    
    @ObservedObject var manager: BudgetizeDataManager
    var category: SpendingCategory
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            HeaderLayer
            TotalTransactionsLayer
            TransactionsListLayer
        }
        .navigationTitle(category.rawValue.capitalized)
        .onAppear(perform: {
        })
    }
    
    // Header Layer
    private var HeaderLayer: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: AppConfig.categoryExpensesGradient), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text(manager.expensesTotal(forCategory: category).dollarAmount).font(.system(size: 50)).bold().opacity(0.9)
                Text("Total Spent for \(manager.selectedMonth)").opacity(0.8)
                Spacer(minLength: UIScreen.main.bounds.height/1.8)
            }.lineLimit(1).minimumScaleFactor(0.5).padding(30).padding(.top, 10).foregroundColor(.white)
        }
    }
    
    // Total Transactions
    private var TotalTransactionsLayer: some View {
        VStack {
            Spacer(minLength: UIScreen.main.bounds.height/3.5)
            ZStack {
                RoundedCorner(radius: 45, corners: [.topLeft, .topRight])
                    .foregroundColor(AppConfig.monthBudgetLayerBackground)
                VStack {
                    HStack {
                        Text("Total transactions")
                        Spacer()
                        Text("\(manager.transactionsCount(forCategory: category))").fontWeight(.medium).lineLimit(1)
                    }.foregroundColor(Color(#colorLiteral(red: 0.3080217838, green: 0.3223729134, blue: 0.3327233195, alpha: 1)))
                    Spacer()
                }.padding(30)
            }
        }
    }
    
    /// Transactions list layer
    private var TransactionsListLayer: some View {
        VStack {
            Spacer(minLength: UIScreen.main.bounds.height/2.7)
            ZStack {
                RoundedCorner(radius: 45, corners: [.topLeft, .topRight])
                    .foregroundColor(.white).shadow(color: Color(#colorLiteral(red: 0.8827491403, green: 0.9036039114, blue: 0.9225834608, alpha: 1)), radius: 10, x: 0, y: -10)
                if manager.transactionsCount(forCategory: category) == 0 {
                    VStack {
                        Image(systemName: "cart.fill").font(.system(size: 40)).padding(5)
                        Text("Nothing to See Here").font(.system(size: 27)).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        Text("You don't have any transactions for this category yet").font(.system(size: 20))
                            .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    }.multilineTextAlignment(.center).padding(30)
                } else {
                    ScrollView(showsIndicators: false) {
                        Spacer(minLength: 30)
                        ForEach(0..<manager.transactionsCount(forCategory: category), id: \.self, content: { index in
                            HStack {
                                Text(manager.transactionDetails(atIndex: index, forCategory: category).description)
                                    .font(.system(size: 18))
                                Spacer()
                                Text(manager.transactionDetails(atIndex: index, forCategory: category).amount.dollarAmount)
                                    .font(.title3).multilineTextAlignment(.trailing)
                            }.lineLimit(1).minimumScaleFactor(0.5)
                            if index != manager.transactionsCount(forCategory: category) - 1 {
                                Divider().padding([.top, .bottom], 12)
                            }
                        })
                        Spacer(minLength: 50)
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    .padding([.leading, .trailing], 30)
                }
            }.ignoresSafeArea()
        }
    }
}

// MARK: - Render preview UI
struct CategoryExpensesContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryExpensesContentView(manager: BudgetizeDataManager(), category: .clothing)
    }
}
