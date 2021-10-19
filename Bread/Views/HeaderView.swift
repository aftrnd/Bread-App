//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI

// Dashboard Header View
struct HeaderView: View {
    
    @ObservedObject var manager: BreadDataManager
    var showUpdateBudgetFlow: () -> Void
    
    // MARK: - Main rendering function
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: AppConfig.headerGradient), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                HeaderTitleButtonView
                ZStack {
                    MonthBudgetView
                    MonthSelectorView
                }.padding(.bottom, 50)
            }
            Spacer(minLength: UIScreen.main.bounds.height/2)
        }
    }
    
    // Header title and budget button
    private var HeaderTitleButtonView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(AppConfig.headerTitle).font(.title3).fontWeight(.heavy)
                    //RoundedRectangle(cornerRadius: 5).frame(width: 150, height: 2)
                }
                Spacer()
                Button(action: {
                    showUpdateBudgetFlow()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }, label: {
                    Image(systemName: "dollarsign.circle").font(.system(size: 30))
                })
            }
            Spacer()
        }.padding([.leading, .trailing], 20).foregroundColor(.white).padding(.top, 15)
    }
    
    // Month budget
    private var MonthBudgetView: some View {
        VStack(spacing: 5) {
            Text(manager.selectedMonth).font(.title)
            Text(manager.spent.dollarAmount).font(.system(size: 48)).bold().lineLimit(1).minimumScaleFactor(0.5)
        }.foregroundColor(.white).frame(maxWidth: UIScreen.main.bounds.width-110)
    }
    
    // Month selector view
    private var MonthSelectorView: some View {
        HStack {
            createArrowButton(name: "chevron.backward.circle") { manager.selectPreviousMonth() }
            Spacer()
            createArrowButton(name: "chevron.forward.circle") { manager.selectNextMonth() }
        }.padding([.leading, .trailing], 20).opacity(0.4)
    }
    
    private func createArrowButton(name: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }, label: {
            Image(systemName: name).font(.system(size: 30))
        }).foregroundColor(.white)
    }
}

// Render preview UI
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(manager: BreadDataManager(), showUpdateBudgetFlow: { })
    }
}
