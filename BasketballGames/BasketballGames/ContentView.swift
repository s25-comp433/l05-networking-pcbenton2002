import SwiftUI

// Model for decoding JSON
struct GameResponse: Codable {
    var id: Int
    var date: String
    var opponent: String
    var team: String
    var isHomeGame: Bool
    var score: GameScore
}

struct GameScore: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games = [GameResponse]()
    
    var body: some View {
        NavigationView {
            List(games, id: \.id) { game in
                VStack(alignment: .leading) {
                    Text("\(game.team) vs. \(game.opponent)")
                        .font(.headline)
                    
                    Text(game.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(game.score.unc) - \(game.score.opponent)")
                        .font(.title2)
                    
                    Text(game.isHomeGame ? "Home" : "Away")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(5)
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([GameResponse].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Failed to load data")
        }
    }
}

#Preview {
    ContentView()
}
