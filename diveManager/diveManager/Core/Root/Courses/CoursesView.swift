import SwiftUI

struct CoursesView: View {
    @State private var courses: [Course] = [
        Course(name: "Freediving Basics", students: [], sessions: [], diveShop: nil, certificationAgency: nil, isCompleted: false)
    ]
    @State private var showingAddCourse = false
    @State private var selectedCourse: Course?
    
    var body: some View {
        VStack {
            List {
                ForEach($courses) { $course in
                    NavigationLink(destination: CourseDetailView(course: $course)) {
                        VStack(alignment: .leading) {
                            Text(course.name)
                                .font(.headline)
                            if let diveShop = course.diveShop {
                                Text("Dive Shop: \(diveShop.name)")
                                    .font(.subheadline)
                            }
                            if let agency = course.certificationAgency {
                                Text("Agency: \(agency.name)")
                                    .font(.subheadline)
                            }
                            Text("Completed: \(course.isCompleted ? "Yes" : "No")")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteCourse)
            }
            .navigationTitle("Courses")
            .toolbar {
                Button(action: { showingAddCourse = true }) {
                    Label("Add Course", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddCourse) {
                AddCourseView(courses: $courses)
            }
        }
    }
    
    func deleteCourse(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
