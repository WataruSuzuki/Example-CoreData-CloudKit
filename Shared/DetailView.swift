//
//  DetailView.swift
//  CloudKitCoreData
//
//  Created by 鈴木航 on 2020/12/04.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var parent: Parent?
    @State private var children: [Child]?
    
    var body: some View {
        if let children = loadChildren(from: parent), !children.isEmpty {
            List {
                ForEach(children) { child in
                    Text(child.name ?? "(・A・)")
                }
            }
        } else {
            Text("(・A・)")
                .toolbar(content: {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            addChildren(parent: parent)
                        }, label: {
                            Label("Add child", systemImage: "plus")
                        })
                    }
                })
        }
    }
    
    private func loadChildren(from: Parent?) -> [Child]? {
        guard children == nil else {
            return children!
        }
        
        if let set = parent?.children,
           let children = set.allObjects as? [Child] {
            return children
        }
        return nil
    }
    
    private func addChildren(parent: Parent?) {
        withAnimation {
            guard let parent = parent else { return }
            let newItem = Child(context: viewContext)
            newItem.name = "(・∀・)"
            parent.children = [newItem]

            do {
                try viewContext.save()
                children = parent.children?.allObjects as? [Child]
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
