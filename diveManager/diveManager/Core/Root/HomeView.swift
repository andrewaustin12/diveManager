//
//  HomeView.swift
//  diveManager
//
//  Created by andrew austin on 2/27/24.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @StateObject var diveManager = DiveManager()

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Courses Taught")) {
                    ForEach(diveManager.courses) { course in
                        VStack(alignment: .leading) {
                            Text(course.courseName).font(.headline)
                            Text("Agency: \(course.agency)")
                            Text("School: \(course.schoolName)") // Display school name
                            Text("Students: \(course.numberOfStudents)")
                        }
                    }
                    .onDelete(perform: deleteCourse)
                }
                
                Section(header: Text("Dive Sessions")) {
                    ForEach(diveManager.diveSessions) { session in
                        VStack(alignment: .leading) {
                            Text("Location: \(session.location)")
                            Text("School: \(session.schoolName)") // Display school name
                            Text("Divers: \(session.numberOfDivers)")
                        }
                    }
                    .onDelete(perform: deleteSession)
                }
            }
            .navigationTitle("Dive Manager")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Add actions to add courses or sessions, including specifying the school
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    func deleteCourse(at offsets: IndexSet) {
        diveManager.courses.remove(atOffsets: offsets)
    }
    
    func deleteSession(at offsets: IndexSet) {
        diveManager.diveSessions.remove(atOffsets: offsets)
    }
}


#Preview {
    HomeView()
}
