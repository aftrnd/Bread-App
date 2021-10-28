//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI

/// A list of categories and expenses
struct ExpensesListView: View {
    
    @ObservedObject var manager: BreadDataManager
    var didSelectCategory: (_ category: SpendingCategory) -> Void

    // MARK: - Main rendering function
    var body: some View {
        VStack {
            Spacer(minLength: UIScreen.main.bounds.height/2.45)
            ZStack {
                RoundedCorner(radius: 45, corners: [.topLeft, .topRight])
                    .foregroundColor(.black).shadow(color: Color(#colorLiteral(red: 0.8827491403, green: 0.9036039114, blue: 0.9225834608, alpha: 1)), radius: 10, x: 0, y: -10)
                ScrollView(showsIndicators: false) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Purchases").font(.title).foregroundColor(Color.white)}
                        
                        Spacer()
                        
                    }.padding(.leading, 0).padding(.bottom, 25).padding(.top, 25)
                    ForEach(0..<SpendingCategory.allCases.count, id: \.self, content: { index in
                        Button(action: {
                            didSelectCategory(SpendingCategory.allCases[index])
                        }, label: {
                            HStack(spacing: 20) {
                                Image(SpendingCategory.allCases[index].rawValue)
                                    .resizable().aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                                    .foregroundColor(Color.blue)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(SpendingCategory.allCases[index].rawValue.capitalized)
                                            .font(.title3).bold().foregroundColor(Color.white)
                                        Text("\(manager.transactionsCount(forCategory: SpendingCategory.allCases[index])) Transactions")
                                    }.lineLimit(1).minimumScaleFactor(0.5)
                                    Spacer()
                                    Text(manager.expensesTotal(forCategory: SpendingCategory.allCases[index]).dollarAmount)
                                        .font(.title3).fontWeight(.medium).multilineTextAlignment(.trailing)
                                        .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                }
                            }
                        }).opacity(manager.selectedMonth == Date().month ? 1 : 0.4)
                        if index != SpendingCategory.allCases.count - 1 {
                            Divider().background(Color.gray).opacity(0.5).padding([.top, .bottom], 12)
                        }
                    })
                    Spacer(minLength: 50)
                }
                .foregroundColor(Color.gray)
                .padding([.leading, .trailing], 30)
            }.ignoresSafeArea()
        }
    }
}

// MARK: - Render preview UI
struct ExpensesListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesListView(manager: BreadDataManager(), didSelectCategory: { _ in })
    }
}
