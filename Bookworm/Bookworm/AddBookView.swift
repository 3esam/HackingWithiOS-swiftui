//
//  AddBookView.swift
//  Bookworm
//
//  Created by Esam Sherif on 5/14/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 0
    @State private var genre = ""
    @State private var review = ""
    @State private var completionDate = Date.now
    
    @State private var validationError = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                
                if (!validationError.isEmpty){
                    Section {
                        Text(validationError)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre){
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    DatePicker("Completion Date", selection: $completionDate, displayedComponents: .date)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        if(canSaveBook())
                        {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rating = Int16(rating)
                            newBook.genre = genre
                            newBook.review = review
                            newBook.date = completionDate
                            
                            try? moc.save()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
    
    func canSaveBook() -> Bool {
        validationError = ""
        
        if (title.isEmpty){
            validationError = "title should not be empty"
        } else if (author.isEmpty) {
            validationError = "author should not be empty"
        }
        
        return validationError.isEmpty
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
