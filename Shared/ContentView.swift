//
//  ContentView.swift
//  Shared
//
//  Created by 鈴木航 on 2020/12/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
                            keyPath: \Parent.timestamp,
                            ascending: true)
        ],
        animation: .default
    )
    private var parents: FetchedResults<Parent>

    var body: some View {
        NavigationView {
            #if os(iOS)
            iOSBody
            #else
            macOSBody
            #endif
        }
    }
    
    #if os(iOS)
    private var iOSBody: some View {
        commonBody
            .navigationBarItems(leading: EditButton())
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: addItem, label: {
                    Image(systemName: "plus")
                }))
            .navigationTitle("CloutKit CoreData")
    }
    #endif //iOS
    
    #if os(macOS)
    private var macOSBody: some View {
        commonBody
            .toolbar(content: {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            })
    }
    #endif //macOS
    
    private var commonBody: some View {
        List {
            ForEach(parents) { item in
                NavigationLink(destination: DetailView(parent: item)) {
                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                }
            }
            .onDelete(perform: deleteparents)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Parent(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteparents(offsets: IndexSet) {
        withAnimation {
            offsets.map { parents[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
