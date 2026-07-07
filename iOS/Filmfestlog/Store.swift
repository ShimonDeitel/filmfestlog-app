import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [FilmEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall immediately.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("filmfestlog_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: FilmEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: FilmEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: FilmEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([FilmEntry].self, from: data) else {
            seed()
            return
        }
        entries = decoded
    }

    private func seed() {
        entries = [
            FilmEntry(title: "Sample Film 1", rating: 3, festival: "Sample", director: "Sample", screeningDate: Date(), notes: "Sample"),
            FilmEntry(title: "Sample Film 2", rating: 4, festival: "Sample", director: "Sample", screeningDate: Date(), notes: "Sample"),
            FilmEntry(title: "Sample Film 3", rating: 5, festival: "Sample", director: "Sample", screeningDate: Date(), notes: "Sample")
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
