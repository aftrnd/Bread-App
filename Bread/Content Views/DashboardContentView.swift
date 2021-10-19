//
//  AppConfig.swift
//  Bread App
//
//  Created by Nick Jackson on 10/18/21.
//

import SwiftUI

/// Modal Flows
enum ModalFlow: Identifiable {
    case logExpenses
    case updateBudget
    var id: Int { hashValue }
}

/// Alert type
enum AlertType: Identifiable {
    case setupBudget
    case overbudget
    var id: Int { hashValue }
    
    /// Alert message
    var message: String {
        switch self {
        case .setupBudget:
            return "You must setup your budget first"
        case .overbudget:
            return "You've spent more than your allocated budget this month"
        }
    }
}

/// Main content/app screen
struct DashboardContentView: View {
    
    @ObservedObject private var manager = BreadDataManager()
    @State private var modalFlow: ModalFlow?
    @State private var alertType: AlertType?
    @State private var didShowOverbudgetAlert: Bool = false
    @State private var showCategoryExpenses: Bool = false
    @State private var selectedCategory: SpendingCategory! {
        didSet { showCategoryExpenses = true }
    }
    
    /// Change default behavior
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    // MARK: - Main rendering function
    var body: some View {
        NavigationView {
            ZStack {
                if selectedCategory != nil {
                    NavigationLink(destination: CategoryExpensesContentView(manager: manager, category: selectedCategory),
                                   isActive: $showCategoryExpenses, label: { EmptyView() })
                }
                HeaderView(manager: manager, showUpdateBudgetFlow: { modalFlow = .updateBudget })
                BudgetProgressView(manager: manager)
                ExpensesListView(manager: manager, didSelectCategory: { category in
                    selectedCategory = category
                })
                AddExpenseButton
            }
            .navigationBarHidden(true).navigationBarTitle("Home")
            .sheet(item: $modalFlow, content: { flow in
                switch flow {
                case .logExpenses:
                    LogExpenseView(manager: manager).onDisappear(perform: {
                        /// Show the overbudget alert if needed
                        if manager.spent > manager.budget && !didShowOverbudgetAlert {
                            didShowOverbudgetAlert = true
                            alertType = .overbudget
                        }
                    })
                case .updateBudget:
                    SetupBudgetView(manager: manager)
                }
            })
            .alert(item: $alertType, content: { type in
                Alert(title: Text(type.message), message: nil, dismissButton: .cancel({
                    if type == .setupBudget {
                        modalFlow = .updateBudget
                    }
                }))
            })
        }
        .onAppear(perform: {
            /// Show the update budget screen if the budget is not set
            if manager.budget == 0 && manager.selectedMonth == Date().month {
                modalFlow = .updateBudget
            }
        })
    }
    
    /// Add Expense Button 
    private var AddExpenseButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                if manager.selectedMonth == Date().month {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        if manager.budget == 0 {
                            alertType = .setupBudget
                        } else {
                            modalFlow = .logExpenses
                        }
                    }, label: {
                        Image(systemName: "plus.viewfinder")
                            .font(.system(size: 22, weight: .bold)).foregroundColor(.white)
                        
                            //Button & Shadow color
                            .padding().background(Circle().foregroundColor(.blue))
                            .shadow(color: Color(.black), radius: 10, x: 0, y: 0)
                    })
                }
            }
        }.padding()
    }
}

// MARK: - Render preview UI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContentView()
    }
}
