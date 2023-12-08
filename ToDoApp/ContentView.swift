import SwiftUI

struct ContentView: View {
    @State private var toDoItems: [ToDoItem] = []
    @State private var completedCount: Int = 0

    var body: some View {
        VStack {
            Text("To-Do List")
                .font(.largeTitle)
                .padding()

            
            HStack {
                TextField("New To-Do Item", text: $newToDoItemTitle)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: addToDoItem) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .padding()
                }
            }

          
            List {
                ForEach(toDoItems.indices, id: \.self) { index in
                    ToDoRow(item: $toDoItems[index], onToggleCompletion: onToggleCompletion)
                }
                .onDelete(perform: deleteToDoItem)
            }

            Spacer()

            Text("Completed \(completedCount) of \(toDoItems.count)")
                .font(.title)
                .padding()
        }
    }

    private func addToDoItem() {
        guard !newToDoItemTitle.isEmpty else { return }
        let newItem = ToDoItem(title: newToDoItemTitle)
        toDoItems.append(newItem)
        newToDoItemTitle = ""
        updateCompletedCount()
    }

    private func deleteToDoItem(offsets: IndexSet) {
        toDoItems.remove(atOffsets: offsets)
        updateCompletedCount()
    }

    private func onToggleCompletion(_ item: ToDoItem) {
        updateCompletedCount()
    }

    private func updateCompletedCount() {
        completedCount = toDoItems.filter { $0.isDone }.count
    }

    @State private var newToDoItemTitle: String = ""
}

struct ToDoRow: View {
    @Binding var item: ToDoItem
    let onToggleCompletion: (ToDoItem) -> Void

    var body: some View {
        HStack {
            Image(systemName: item.isDone ? "checkmark.circle" : "circle")
                .onTapGesture {
                    item.isDone.toggle()
                    onToggleCompletion(item)
                }
            Text(item.title)
        }
    }
}

struct ToDoItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
