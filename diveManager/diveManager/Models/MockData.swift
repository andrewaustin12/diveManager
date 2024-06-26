import Foundation

struct MockData {
    static let students: [Student] = [
        Student(
            firstName: "John",
            lastName: "Doe",
            studentID: "123-456-7890",
            email: "john@example.com",
            certifications: [
                Certification(name: CertificationAgency.PADI.openWater.rawValue, dateIssued: Date(), agency: .padi),
                Certification(name: CertificationAgency.PADI.advancedOpenWater.rawValue, dateIssued: Date(), agency: .padi)
            ]
        ),
        Student(
            firstName: "Jane",
            lastName: "Smith",
            studentID: "987-654-3210",
            email: "jane@example.com",
            certifications: [
                Certification(name: CertificationAgency.SDI.rescueDiver.rawValue, dateIssued: Date(), agency: .sdi),
                Certification(name: CertificationAgency.SSI.diveControlSpecialist.rawValue, dateIssued: Date(), agency: .ssi)
            ]
        ),
        Student(
            firstName: "Alice",
            lastName: "Johnson",
            studentID: "111-222-3333",
            email: "alice@example.com",
            certifications: [
                Certification(name: CertificationAgency.TDI.trimixDiver.rawValue, dateIssued: Date(), agency: .tdi)
            ]
        ),
        Student(
            firstName: "Bob",
            lastName: "Brown",
            studentID: "444-555-6666",
            email: "bob@example.com",
            certifications: [
                Certification(name: CertificationAgency.RAID.nitroxDiver.rawValue, dateIssued: Date(), agency: .raid),
                Certification(name: CertificationAgency.NAUI.scubaDiver.rawValue, dateIssued: Date(), agency: .naui),
                Certification(name: CertificationAgency.NAUI.advancedScubaDiver.rawValue, dateIssued: Date(), agency: .naui)
            ]
        ),
        // Additional mock students
        Student(
            firstName: "Michael",
            lastName: "Clark",
            studentID: "555-666-7777",
            email: "michael@example.com",
            certifications: [
                Certification(name: CertificationAgency.PADI.rescueDiver.rawValue, dateIssued: Date(), agency: .padi),
                Certification(name: CertificationAgency.SDI.openWaterScubaDiver.rawValue, dateIssued: Date(), agency: .sdi)
            ]
        ),
        Student(
            firstName: "Emily",
            lastName: "Davis",
            studentID: "888-999-0000",
            email: "emily@example.com",
            certifications: [
                Certification(name: CertificationAgency.SSI.stressAndRescue.rawValue, dateIssued: Date(), agency: .ssi),
                Certification(name: CertificationAgency.TDI.nitroxDiver.rawValue, dateIssued: Date(), agency: .tdi)
            ]
        ),
        Student(
            firstName: "David",
            lastName: "Evans",
            studentID: "123-789-4560",
            email: "david@example.com",
            certifications: [
                Certification(name: CertificationAgency.NAUI.masterScubaDiver.rawValue, dateIssued: Date(), agency: .naui),
                Certification(name: CertificationAgency.PADI.divemaster.rawValue, dateIssued: Date(), agency: .padi)
            ]
        ),
        Student(
            firstName: "Sophia",
            lastName: "Garcia",
            studentID: "456-123-7890",
            email: "sophia@example.com",
            certifications: [
                Certification(name: CertificationAgency.RAID.advanced35Diver.rawValue, dateIssued: Date(), agency: .raid)
            ]
        ),
        Student(
            firstName: "James",
            lastName: "Harris",
            studentID: "789-456-1230",
            email: "james@example.com",
            certifications: [
                Certification(name: CertificationAgency.SDI.advancedAdventureDiver.rawValue, dateIssued: Date(), agency: .sdi),
                Certification(name: CertificationAgency.TDI.decompressionProceduresDiver.rawValue, dateIssued: Date(), agency: .tdi)
            ]
        ),
        Student(
            firstName: "Olivia",
            lastName: "Jones",
            studentID: "000-111-2223",
            email: "olivia@example.com",
            certifications: [
                Certification(name: CertificationAgency.PADI.masterInstructor.rawValue, dateIssued: Date(), agency: .padi),
                Certification(name: CertificationAgency.SSI.perfectBuoyancy.rawValue, dateIssued: Date(), agency: .ssi)
            ]
        ),
        Student(
            firstName: "Liam",
            lastName: "King",
            studentID: "333-444-5556",
            email: "liam@example.com",
            certifications: [
                Certification(name: CertificationAgency.NAUI.rescueDiver.rawValue, dateIssued: Date(), agency: .naui)
            ]
        ),
        Student(
            firstName: "Isabella",
            lastName: "Lee",
            studentID: "666-777-8889",
            email: "isabella@example.com",
            certifications: [
                Certification(name: CertificationAgency.SDI.computerDiver.rawValue, dateIssued: Date(), agency: .sdi),
                Certification(name: CertificationAgency.PADI.underwaterNavigator.rawValue, dateIssued: Date(), agency: .padi)
            ]
        ),
        Student(
            firstName: "Ethan",
            lastName: "Martinez",
            studentID: "999-000-1112",
            email: "ethan@example.com",
            certifications: [
                Certification(name: CertificationAgency.TDI.cavernDiver.rawValue, dateIssued: Date(), agency: .tdi),
                Certification(name: CertificationAgency.SSI.equipmentTechniques.rawValue, dateIssued: Date(), agency: .ssi)
            ]
        ),
        Student(
            firstName: "Mia",
            lastName: "Miller",
            studentID: "222-333-4445",
            email: "mia@example.com",
            certifications: [
                Certification(name: CertificationAgency.PADI.boatDiver.rawValue, dateIssued: Date(), agency: .padi)
            ]
        ),
        Student(
            firstName: "Alexander",
            lastName: "Moore",
            studentID: "555-666-7778",
            email: "alexander@example.com",
            certifications: [
                Certification(name: CertificationAgency.RAID.diveMedic.rawValue, dateIssued: Date(), agency: .raid),
                Certification(name: CertificationAgency.TDI.advancedWreckDiver.rawValue, dateIssued: Date(), agency: .tdi)
            ]
        ),
        Student(
            firstName: "Amelia",
            lastName: "Perez",
            studentID: "888-999-0001",
            email: "amelia@example.com",
            certifications: [
                Certification(name: CertificationAgency.NAUI.underwaterEcologist.rawValue, dateIssued: Date(), agency: .naui)
            ]
        ),
        Student(
            firstName: "Logan",
            lastName: "Robinson",
            studentID: "123-789-4561",
            email: "logan@example.com",
            certifications: [
                Certification(name: CertificationAgency.SDI.nightAndLimitedVisibilityDiver.rawValue, dateIssued: Date(), agency: .sdi),
                Certification(name: CertificationAgency.SSI.firstAidAndCPR.rawValue, dateIssued: Date(), agency: .ssi)
            ]
        ),
        Student(
            firstName: "Charlotte",
            lastName: "Scott",
            studentID: "456-123-7892",
            email: "charlotte@example.com",
            certifications: [
                Certification(name: CertificationAgency.PADI.searchAndRecoveryDiver.rawValue, dateIssued: Date(), agency: .padi)
            ]
        ),
        Student(
            firstName: "Lucas",
            lastName: "Taylor",
            studentID: "789-456-1233",
            email: "lucas@example.com",
            certifications: [
                Certification(name: CertificationAgency.TDI.entryLevelTrimixDiver.rawValue, dateIssued: Date(), agency: .tdi)
            ]
        ),
        Student(
            firstName: "Ava",
            lastName: "Thomas",
            studentID: "000-111-2224",
            email: "ava@example.com",
            certifications: [
                Certification(name: CertificationAgency.RAID.explorer35.rawValue, dateIssued: Date(), agency: .raid),
                Certification(name: CertificationAgency.SDI.wreckDiver.rawValue, dateIssued: Date(), agency: .sdi)
            ]
        ),
        Student(
            firstName: "Mason",
            lastName: "Thompson",
            studentID: "333-444-5557",
            email: "mason@example.com",
            certifications: [
                Certification(name: CertificationAgency.PADI.nightDiver.rawValue, dateIssued: Date(), agency: .padi)
            ]
        ),
        Student(
            firstName: "Harper",
            lastName: "White",
            studentID: "666-777-8888",
            email: "harper@example.com",
            certifications: [
                Certification(name: CertificationAgency.SDI.altitudeDiver.rawValue, dateIssued: Date(), agency: .sdi),
                Certification(name: CertificationAgency.TDI.sidemountDiver.rawValue, dateIssued: Date(), agency: .tdi)
            ]
        ),
        Student(
            firstName: "Benjamin",
            lastName: "Williams",
            studentID: "999-000-1113",
            email: "benjamin@example.com",
            certifications: [
                Certification(name: CertificationAgency.SSI.boatDiving.rawValue, dateIssued: Date(), agency: .ssi)
            ]
        ),
        Student(
            firstName: "Evelyn",
            lastName: "Wilson",
            studentID: "222-333-4446",
            email: "evelyn@example.com",
            certifications: [
                Certification(name: CertificationAgency.RAID.iceDiver.rawValue, dateIssued: Date(), agency: .raid)
            ]
        ),
        Student(
            firstName: "Aiden",
            lastName: "Young",
            studentID: "555-666-7779",
            email: "aiden@example.com",
            certifications: [
                Certification(name: CertificationAgency.NAUI.underwaterPhotographer.rawValue, dateIssued: Date(), agency: .naui),
                Certification(name: CertificationAgency.PADI.peakPerformanceBuoyancy.rawValue, dateIssued: Date(), agency: .padi)
            ]
        )
    ]
    
    static let sessions: [Session] = [
        Session(
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Pool A",
            type: .confinedWater,
            duration: 60,
            notes: "Basic pool training"
            
        ),
        Session(
            date: Date(),
            startTime: Date(),
            endTime: Date().addingTimeInterval(7200),
            location: "Ocean B",
            type: .openWater,
            duration: 120,
            notes: "Open water session"
            
        ),
        // Add more mock sessions as needed
    ]
    
    static let courses: [Course] = [
        Course(
            students: [students[0], students[1]],
            startDate: Date().addingTimeInterval(-86400 * 30), // 30 days ago
            endDate: Date().addingTimeInterval(-86400 * 26),
            sessions: [sessions[0], sessions[1]],
            diveShop: DiveShop(name: "Dive Shop A", address: "Location A", phone: "123-456-7890", email: "diveshopA@gmail.com"),
            certificationAgency: .padi,
            selectedCourse: CertificationAgency.PADI.openWater.rawValue,
            isCompleted: true
        ),
        Course(
            students: [students[2]],
            startDate: Date().addingTimeInterval(-86400 * 60), // 60 days ago
            endDate: Date().addingTimeInterval(-86400 * 58),
            sessions: [sessions[1]],
            diveShop: DiveShop(name: "Dive Shop B", address: "Location B", phone: "987-654-3210", email: "diveshopB@gmail.com"),
            certificationAgency: .ssi,
            selectedCourse: CertificationAgency.SSI.advancedAdventurer.rawValue,
            isCompleted: true
        ),
        // New courses in May
        Course(
            students: [students[3], students[4]],
            startDate: Date().addingTimeInterval(-86400 * 20), // 20 days ago
            endDate: Date().addingTimeInterval(-86400 * 15),
            sessions: [sessions[0]],
            diveShop: DiveShop(name: "Dive Shop C", address: "Location C", phone: "456-789-0123", email: "diveshopc@gmail.com"),
            certificationAgency: .tdi,
            selectedCourse: CertificationAgency.TDI.trimixDiver.rawValue,
            isCompleted: true
        ),
        Course(
            students: [students[5], students[6]],
            startDate: Date().addingTimeInterval(-86400 * 10), // 10 days ago
            endDate: Date().addingTimeInterval(-86400 * 8),
            sessions: [sessions[1]],
            diveShop: DiveShop(name: "Dive Shop D", address: "Location D", phone: "789-012-3456", email: "diveshopC@gmail.com"),
            certificationAgency: .naui,
            selectedCourse: CertificationAgency.NAUI.advancedScubaDiver.rawValue,
            isCompleted: true
        ),
        Course(
            students: [students[3], students[12]],
            startDate: Date().addingTimeInterval(-86400 * 1), // 15 days from now
            endDate: Date().addingTimeInterval(86400 * 3),
            sessions: [sessions[1]],
            diveShop: DiveShop(name: "Dive Shop F", address: "Location F", phone: "890-123-4567", email: "diveshopF@gmail.com"),
            certificationAgency: .tdi,
            selectedCourse: CertificationAgency.TDI.sidemountDiver.rawValue,
            isCompleted: false
        ),
        Course(
            students: [students[3], students[12], students[5]],
            startDate: Date().addingTimeInterval(86400 * 1), // 1 days from now
            endDate: Date().addingTimeInterval(86400 * 3),
            sessions: [sessions[1]],
            diveShop: DiveShop(name: "Big Blue Tech", address: "Koh Tao", phone: "890-123-4567", email: "bigbluetech@gmail.com"),
            certificationAgency: .tdi,
            selectedCourse: CertificationAgency.TDI.sidemountDiver.rawValue,
            isCompleted: false
        ),
        // New courses in June
        Course(
            students: [students[7], students[8]],
            startDate: Date().addingTimeInterval(86400 * 1), // 1 day from now
            endDate: Date().addingTimeInterval(86400 * 30), // 30 days from now
            sessions: [sessions[0]],
            diveShop: DiveShop(name: "Dive Shop E", address: "Location E", phone: "234-567-8901", email: "diveshopE@gmail.com"),
            certificationAgency: .padi,
            selectedCourse: CertificationAgency.PADI.divemaster.rawValue,
            isCompleted: false
        ),
        Course(
            students: [students[7], students[8]],
            startDate: Date().addingTimeInterval(86400 * 1), // 1 day from now
            endDate: Date().addingTimeInterval(86400 * 30), // 30 days from now
            sessions: [sessions[0]],
            diveShop: DiveShop(name: "Dive Shop E", address: "Location E", phone: "234-567-8901", email: "diveshopE@gmail.com"),
            certificationAgency: .padi,
            selectedCourse: CertificationAgency.PADI.instructorDevelopmentCourse.rawValue,
            isCompleted: false
        ),
        Course(
            students: [students[9], students[10]],
            startDate: Date().addingTimeInterval(86400 * 15), // 15 days from now
            endDate: Date().addingTimeInterval(86400 * 18),
            sessions: [sessions[1]],
            diveShop: DiveShop(name: "Dive Shop F", address: "Location F", phone: "890-123-4567", email: "diveshopF@gmail.com"),
            certificationAgency: .sdi,
            selectedCourse: CertificationAgency.SDI.rescueDiver.rawValue,
            isCompleted: false
        )
        // Add more mock courses as needed
    ]
    
    static let diveShops: [DiveShop] = [
        DiveShop(name: "Oceanic Adventures", address: "123 Ocean Ave, Honolulu, HI", phone: "808-123-4567", email: "diveshopA@gmail.com"), //0
        DiveShop(name: "Blue Water Divers", address: "456 Beach Blvd, Miami, FL", phone: "305-987-6543", email: "diveshopA@gmail.com"), // 1
        DiveShop(name: "Deep Sea Explorers", address: "789 Marina Way, San Diego, CA", phone: "619-543-2109", email: "diveshopA@gmail.com"), //2
        DiveShop(name: "Davy Jones Locker", address: "Koh Tao, Thailand", phone: "+31 007452322", email: "diveshopA@gmail.com"),//3
        DiveShop(name: "Big Blue Tech", address: "Koh Tao, Thailand", phone: "+12 32355222", email: "diveshopA@gmail.com")//4
    ]
    
    static let invoices: [Invoice] = [
        Invoice(
            student: students[0],
            diveShop: nil,
            date: Date(),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 30,
                to: Date()
            )!,
            //amount: 400.0,
            isPaid: false,
            billingType: .student,
            amount: 232, items: [item[0], item[5]]
        ),
        Invoice(
            student: nil,
            diveShop: diveShops[4],
            date: Date(),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 15,
                to: Date()
            )!,
            //amount: 1800.0,
            isPaid: true,
            billingType: .diveShop,
            amount: 432, items: [item[0], item[4], item[5]]
        ),
        Invoice(
            student: nil,
            diveShop: diveShops[0],
            date: Date(),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 45,
                to: Date()
            )!,
            //amount: 350.0,
            isPaid: false,
            billingType: .diveShop,
            amount: 656, items: [item[3], item[1]]
        ),
        Invoice(
            student: students[2],
            diveShop: nil,
            date: Date(
                timeIntervalSince1970: 1700000000
            ),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 30,
                to: Date(
                    timeIntervalSince1970: 1700000000
                )
            )!,
            //amount: 1700.0,
            isPaid: true,
            billingType: .student,
            amount: 232, items: [item[2], item[4], item[5], item[3]]
        ), // March 15, 2024
        Invoice(
            student: students[3],
            diveShop: nil,
            date: Date(
                timeIntervalSince1970: 1700600000
            ),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 30,
                to: Date(
                    timeIntervalSince1970: 1700600000
                )
            )!,
            //amount: 550.0,
            isPaid: true,
            billingType: .student,
            amount: 321, items: [item[1], item[2], item[3]]
        ), // March 22, 2024
        Invoice(
            student: students[4],
            diveShop: nil,
            date: Date(
                timeIntervalSince1970: 1702000000
            ),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 30,
                to: Date(
                    timeIntervalSince1970: 1702000000
                )
            )!,
            //amount: 400.0,
            isPaid: false,
            billingType: .student,
            amount: 486, items: [item[0], item[2]]
        ), // April 5, 2024
        Invoice(
            student: students[5],
            diveShop: nil,
            date: Date(
                timeIntervalSince1970: 1702600000
            ),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 30,
                to: Date(
                    timeIntervalSince1970: 1702600000
                )
            )!,
            //amount: 700.0,
            isPaid: false,
            billingType: .student,
            amount: 500, items: [item[0], item[3], item[5], item[6]]
        ), // April 12, 2024
        Invoice(
            student: students[6],
            diveShop: nil,
            date: Date(
                timeIntervalSince1970: 1703200000
            ),
            dueDate: Calendar.current.date(
                byAdding: .day,
                value: 30,
                to: Date(
                    timeIntervalSince1970: 1703200000
                )
            )!,
            //amount: 650.0,
            isPaid: true,
            billingType: .student,
            amount: 400, items: [item[1], item[2], item[5]]
        ) // April 20, 2024
    ]
    
    static let emailLists: [EmailList] = [
        EmailList(name: "Test List", students: [students[0], students[1], students[3], students[5], students[2]])
    ]
    
    static let expenses: [Expense] = [
        Expense( date: Date(), amount: 2300.0, expenseDescription: "Equipment Purchase"),
        Expense(date: Date(), amount: 150.0, expenseDescription: "Facility Rent"),
        Expense(date: Date().addingTimeInterval(-86400 * 10), amount: 50.0, expenseDescription: "Mask"),
        Expense(date: Date().addingTimeInterval(-86400 * 45), amount: 50.0, expenseDescription: "try dive"),
        Expense(date: Date().addingTimeInterval(-86400 * 20), amount: 150.0, expenseDescription: "sidemount course"),
        Expense(date: Date().addingTimeInterval(-86400 * 38), amount: 50.0, expenseDescription: "Marketing"),
        Expense(date: Date().addingTimeInterval(-86400 * 45), amount: 150.0, expenseDescription: "fins"),
        Expense(date: Date().addingTimeInterval(-86400 * 54),amount: 450.0, expenseDescription: "computer"),
        Expense(date: Date().addingTimeInterval(-86400 * 10), amount: 250.0, expenseDescription: "Rescue Diver"),
        Expense(date: Date(timeIntervalSince1970: 1700000000), amount: 222.0, expenseDescription: "Tank Rental"),
        
        // More expenses...
    ]
    
    static let item: [InvoiceItem] = [
        InvoiceItem(itemDescription: "Tech sidemount course", amount: 200, category: .course), // 0
        InvoiceItem(itemDescription: "Openwater course", amount: 250, category: .course), // 1
        InvoiceItem(itemDescription: "Advanced openwater course", amount: 200, category: .course), //2
        InvoiceItem(itemDescription: "Mask", amount: 100, category: .sales), //3
        InvoiceItem(itemDescription: "Apeks Regs", amount: 1200, category: .sales), //4
        InvoiceItem(itemDescription: "Extra day of training", amount: 200, category: .misc), //5
        InvoiceItem(itemDescription: "DM for 4 people", amount: 200, category: .dm) //5
    ]
    
    static let goals: [Goal] = [
        Goal(amount: 1000, type: .monthly, category: .revenue, year: 2024, month: 6),
        Goal(amount: 5000, type: .quarterly, category: .sales, year: 2024, quarter: 2),
        Goal(amount: 20000, type: .yearly, category: .sales, year: 2024)
    ]
}

