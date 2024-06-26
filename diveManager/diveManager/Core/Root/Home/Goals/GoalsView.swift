import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var context // SwiftData context
    @Query var goals: [Goal] // Query to fetch goals from the data model
    @Query var invoices: [Invoice] // Query to fetch invoices from the data model
    @Query var courses: [Course] // Query to fetch courses from the data model
    @Query var students: [Student] // Query to fetch students from the data model
    @Query var certifications: [Certification] // Query to fetch certifications from the data model
    @State private var showingAddGoalView = false // State to manage the display of the AddGoalView

    // Fetching the currency symbol from UserDefaults
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    // Fetching the current month as a string
    var currentMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date())
    }

    // Determining the current quarter based on the current month
    var currentQuarter: String {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 1...3:
            return "Q1"
        case 4...6:
            return "Q2"
        case 7...9:
            return "Q3"
        default:
            return "Q4"
        }
    }

    // Fetching the current year as a string
    var currentYear: String {
        let year = Calendar.current.component(.year, from: Date())
        return "\(year)"
    }

    // Filtering goals by their type
    var monthlyGoals: [Goal] {
        goals.filter { $0.type == .monthly }
    }

    var quarterlyGoals: [Goal] {
        goals.filter { $0.type == .quarterly }
    }

    var yearlyGoals: [Goal] {
        goals.filter { $0.type == .yearly }
    }

    var body: some View {
        NavigationStack {
            List {
                SectionView(title: "Monthly - \(currentMonth)", goals: monthlyGoals, currentCurrencySymbol: currentCurrencySymbol, onDelete: deleteGoal, invoices: invoices, courses: courses, students: students, certifications: certifications)
                SectionView(title: "Quarterly - \(currentQuarter)", goals: quarterlyGoals, currentCurrencySymbol: currentCurrencySymbol, onDelete: deleteGoal, invoices: invoices, courses: courses, students: students, certifications: certifications)
                SectionView(title: "Yearly - \(currentYear)", goals: yearlyGoals, currentCurrencySymbol: currentCurrencySymbol, onDelete: deleteGoal, invoices: invoices, courses: courses, students: students, certifications: certifications)
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddGoalView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoalView) {
                AddGoalView()
            }
        }
    }

    // Function to delete a goal and save the context
    private func deleteGoal(_ goal: Goal) {
        context.delete(goal)
        do {
            try context.save()
        } catch {
            print("Failed to delete goal: \(error)")
        }
    }
}

struct SectionView: View {
    let title: String
    let goals: [Goal]
    let currentCurrencySymbol: String
    let onDelete: (Goal) -> Void
    let invoices: [Invoice] // Passing the invoices to SectionView
    let courses: [Course] // Passing the courses to SectionView
    let students: [Student] // Passing the students to SectionView
    let certifications: [Certification] // Passing the certifications to SectionView

    var body: some View {
        Section(header: Text(title)
            .font(.title2)
            .fontWeight(.bold)) {
            if goals.isEmpty {
                HStack {
                    ZStack {
                        Gauge(value: 0, in: 0...1) {
                            EmptyView()
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .padding(4)
                        )
                        Text("0%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading) {
                        Text("No goals")
                            .font(.headline)
                        Text("Add a goal to get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 10)

                    Spacer()
                }
                .padding(.vertical, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ForEach(goals) { goal in
                    HStack {
                        ZStack {
                            Gauge(value: calculateProgress(for: goal), in: 0...1) {
                                EmptyView()
                            }
                            .gaugeStyle(.accessoryCircularCapacity)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Circle()
                                    .trim(from: 0, to: CGFloat(calculateProgress(for: goal)))
                                    .stroke(Color.teal, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                    .shadow(color: Color.teal.opacity(0.7), radius: 2, x: 0, y: 0)
                                    .rotationEffect(Angle(degrees: -90))
                                    .padding(4)
                            )
                            Text("\(Int(calculateProgress(for: goal) * 100))%")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        VStack(alignment: .leading) {
                            Text(goal.category.rawValue.capitalized)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            HStack(alignment: .firstTextBaseline) {
                                if goal.category == .courses || goal.category == .certifications {
                                    Text("\(calculateProgressAmount(for: goal), specifier: "%.f")")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.primary)
                                    Text(" of \(goal.amount, specifier: "%.f")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("\(currentCurrencySymbol)\(calculateProgressAmount(for: goal), specifier: "%.f")")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.primary)
                                    Text(" of \(currentCurrencySymbol)\(goal.amount, specifier: "%.f")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.leading, 10)

                        Spacer()
                    }
                    .padding(.vertical, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .swipeActions {
                        Button(role: .destructive) {
                            onDelete(goal)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }

    // Function to calculate the progress based on the goal category
    private func calculateProgress(for goal: Goal) -> Double {
        let progressAmount = calculateProgressAmount(for: goal)
        return min(progressAmount / goal.amount, 1.0)
    }

    // Function to calculate the progress amount based on the goal type and category
    private func calculateProgressAmount(for goal: Goal) -> Double {
        switch goal.category {
        case .revenue:
            return calculateTotalRevenue(for: goal)
        case .sales:
            return calculateTotalSales(for: goal)
        case .courses:
            return calculateTotalCourses(for: goal)
        
        case .certifications:
            return calculateTotalCertifications(for: goal)
        default:
            return 0.0
        }
    }

    // Function to calculate the total revenue based on the goal type and date range
    private func calculateTotalRevenue(for goal: Goal) -> Double {
        let calendar = Calendar.current
        let filteredInvoices: [Invoice]

        switch goal.type {
        case .monthly:
            filteredInvoices = invoices.filter {
                calendar.component(.year, from: $0.date) == goal.year &&
                calendar.component(.month, from: $0.date) == goal.month
            }
        case .quarterly:
            let startMonth = (goal.quarter! - 1) * 3 + 1
            let endMonth = startMonth + 2
            filteredInvoices = invoices.filter {
                calendar.component(.year, from: $0.date) == goal.year &&
                (startMonth...endMonth).contains(calendar.component(.month, from: $0.date))
            }
        case .yearly:
            filteredInvoices = invoices.filter {
                calendar.component(.year, from: $0.date) == goal.year
            }
        }

        return filteredInvoices.reduce(0) { $0 + $1.amount }
    }

    // Function to calculate the```swift
    // Function to calculate the total sales based on the goal type and date range
    private func calculateTotalSales(for goal: Goal) -> Double {
        let calendar = Calendar.current
        let filteredInvoices: [Invoice]

        switch goal.type {
        case .monthly:
            filteredInvoices = invoices.filter {
                calendar.component(.year, from: $0.date) == goal.year &&
                calendar.component(.month, from: $0.date) == goal.month
            }
        case .quarterly:
            let startMonth = (goal.quarter! - 1) * 3 + 1
            let endMonth = startMonth + 2
            filteredInvoices = invoices.filter {
                calendar.component(.year, from: $0.date) == goal.year &&
                (startMonth...endMonth).contains(calendar.component(.month, from: $0.date))
            }
        case .yearly:
            filteredInvoices = invoices.filter {
                calendar.component(.year, from: $0.date) == goal.year
            }
        }

        // Sum up the amounts of invoice items that belong to the 'sales' category
        return filteredInvoices.reduce(0) { total, invoice in
            total + invoice.items.filter { $0.category == .sales }.reduce(0) { $0 + $1.amount }
        }
    }

    // Function to calculate the total number of courses based on the goal type and date range
    private func calculateTotalCourses(for goal: Goal) -> Double {
        let calendar = Calendar.current
        let filteredCourses: [Course]

        switch goal.type {
        case .monthly:
            filteredCourses = courses.filter {
                calendar.component(.year, from: $0.startDate) == goal.year &&
                calendar.component(.month, from: $0.startDate) == goal.month
            }
        case .quarterly:
            let startMonth = (goal.quarter! - 1) * 3 + 1
            let endMonth = startMonth + 2
            filteredCourses = courses.filter {
                calendar.component(.year, from: $0.startDate) == goal.year &&
                (startMonth...endMonth).contains(calendar.component(.month, from: $0.startDate))
            }
        case .yearly:
            filteredCourses = courses.filter {
                calendar.component(.year, from: $0.startDate) == goal.year
            }
        }

        return Double(filteredCourses.count)
    }

    // Function to calculate the total number of certifications based on the goal type and date range
    private func calculateTotalCertifications(for goal: Goal) -> Double {
        let calendar = Calendar.current
        let filteredCertifications: [Certification]

        switch goal.type {
        case .monthly:
            filteredCertifications = certifications.filter {
                calendar.component(.year, from: $0.dateIssued) == goal.year &&
                calendar.component(.month, from: $0.dateIssued) == goal.month
            }
        case .quarterly:
            let startMonth = (goal.quarter! - 1) * 3 + 1
            let endMonth = startMonth + 2
            filteredCertifications = certifications.filter {
                calendar.component(.year, from: $0.dateIssued) == goal.year &&
                (startMonth...endMonth).contains(calendar.component(.month, from: $0.dateIssued))
            }
        case .yearly:
            filteredCertifications = certifications.filter {
                calendar.component(.year, from: $0.dateIssued) == goal.year
            }
        }

        return Double(filteredCertifications.count)
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Goal.self, Invoice.self, InvoiceItem.self, Course.self, Student.self, Certification.self, configurations: config)

        return GoalsView()
            .modelContainer(container)
    }
}
