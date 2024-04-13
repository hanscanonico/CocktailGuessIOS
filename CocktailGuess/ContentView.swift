import SwiftUI

struct ContentView: View {
    @State private var cocktailImageURL: URL?
    @State private var guess = ""
    @State private var resultMessage = ""
    @State private var cocktailName = ""
    @State private var showAnswer = false
    @State private var showUserAnswer = false
    @State private var isAnswerCorrect = false
    @State private var numberPoints = 0
    

    var body: some View {
        VStack {
            if showAnswer {
                Text(cocktailName)
            }
            
            else if showUserAnswer {
                if isAnswerCorrect {
                    Text(guess)
                }
                else {
                    Text(guess).strikethrough()
                }
            }
            else {
                Text("???")
            }
                
            HStack {
                Text("\(numberPoints)")
                    if let imageURL = cocktailImageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                            case .failure:
                                Text("Failed to load image")
                            case .empty:
                                Text("Loading...")
                            @unknown default:
                                Text("Loading...")
                            }
                        }
                        .padding()
                    } else {
                        Text("Loading...")
                    }
                
            }.frame(maxWidth: .infinity, alignment: .center)
            TextField("Enter your guess", text: $guess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("Check Guess") {
                    checkGuess()
                }.disabled(showAnswer || guess == "")
                
                Button("Show Answer") {
                    showCorrectAnswer()
                }
                .padding()
                .disabled(showAnswer)
            }
                Text(resultMessage)
            
            Button("Next") {
                fetchData()
                showAnswer = false
                showUserAnswer = false
                guess = ""
            }

            
        }
        .onAppear {
            fetchData()
        }
        .padding()
    }

    func fetchData() {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/random.php") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    do {
                        let result = try JSONDecoder().decode(CocktailResponse.self, from: data)
                        if let cocktail = result.drinks.first {
                            if let imageURLString = cocktail.strDrinkThumb, let imageURL = URL(string: imageURLString) {
                                DispatchQueue.main.async {
                                    self.cocktailImageURL = imageURL
                                    self.cocktailName = cocktail.strDrink
                                    self.resultMessage = ""
                                }
                            }
                        }
                    } catch {
                        print("Error decoding data: \(error.localizedDescription)")
                    }
                }.resume()
    }
    
    func checkGuess() {
        isAnswerCorrect = guess.lowercased() == cocktailName.lowercased()
        numberPoints = isAnswerCorrect ? numberPoints + 1 : 0
        showUserAnswer = true
    }
    
    func showCorrectAnswer() {
        numberPoints = 0
        showAnswer = true
    }
}

struct CocktailResponse: Decodable {
    let drinks: [Cocktail]
}

struct Cocktail: Decodable {
    let strDrinkThumb: String?
    let strDrink: String
}
