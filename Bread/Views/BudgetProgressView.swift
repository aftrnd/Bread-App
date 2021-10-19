//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI

// Shows the second layer on top of the header view with the budget progress bar
struct BudgetProgressView: View {
    
    @ObservedObject var manager: BreadDataManager
    
    // Main rendering function
    var body: some View {
        VStack {
            Spacer(minLength: UIScreen.main.bounds.height/3.5)
            ZStack {
                RoundedCorner(radius: 45, corners: [.topLeft, .topRight])
                    .foregroundColor(AppConfig.monthBudgetLayerBackground)
                VStack {
                    HStack {
                        Text("Monthly Budget")
                        Text(manager.budget.dollarAmount).bold().lineLimit(1).minimumScaleFactor(0.5)
                        Spacer()
                        Text("\(manager.budget > 0 ? String(format: "%.2f", (manager.spent*100.0)/manager.budget) : "0")%")
                            .fontWeight(.medium).lineLimit(1)
                    }.foregroundColor(Color(#colorLiteral(red: 0.3080217838, green: 0.3223729134, blue: 0.3327233195, alpha: 1)))
                    
                    GeometryReader { reader in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).frame(height: 3).foregroundColor(Color(#colorLiteral(red: 0.8183905482, green: 0.8496081233, blue: 0.9326652884, alpha: 1)))
                            HStack(spacing: 0) {
                                LinearGradient(gradient: Gradient(colors: manager.spent > manager.budget ? AppConfig.overbudgetGradient : AppConfig.progressGradient), startPoint: .leading, endPoint: .trailing)
                                    .mask(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: manager.budget > 0 ? min(CGFloat((CGFloat((manager.spent*100.0)/manager.budget) * reader.size.width) / 100.0), reader.size.width) : 0, height: 10)
                                Spacer(minLength: 0)
                            }
                        }.frame(width: reader.size.width)
                    }
                    Spacer()
                }.padding(30)
            }
        }
    }
}

// MARK: - Render preview UI
struct BudgetProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetProgressView(manager: BreadDataManager())
    }
}
