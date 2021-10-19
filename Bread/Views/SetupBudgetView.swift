//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI

/// The view where the user gets to set their budget
struct SetupBudgetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager: BreadDataManager
    @State private var amount: Double = 0.00
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Text(amount.dollarAmount).font(.system(size: 50)).bold()
                Text("What's your budget for \(manager.selectedMonth)?").foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).frame(width: UIScreen.main.bounds.width-60, height: 1).padding([.leading, .trailing]).padding()
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
                        manager.udpateBudget(value: amount)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Update Budget").font(.system(size: 20)).fontWeight(.medium)
                            .padding().padding([.leading, .trailing], 35).foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 40).foregroundColor(.blue))
                    })
                }.padding(20)
            }
        }
    }
}

// MARK: - Render preview UI
struct SetupBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        SetupBudgetView(manager: BreadDataManager())
    }
}
