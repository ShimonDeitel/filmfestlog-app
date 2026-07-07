import Foundation

struct FilmEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var rating: Int = 3
    var dateAdded: Date = Date()
    var festival: String
    var director: String
    var screeningDate: Date
    var notes: String

    init(id: UUID = UUID(), title: String, rating: Int = 3, dateAdded: Date = Date(), festival: String = "", director: String = "", screeningDate: Date = Date(), notes: String = "") {
        self.id = id
        self.title = title
        self.rating = rating
        self.dateAdded = dateAdded
        self.festival = festival
        self.director = director
        self.screeningDate = screeningDate
        self.notes = notes
    }
}
