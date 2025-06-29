import SwiftUI

struct Whiskers: View {
    @State private var sillyLocation: String = ""
    @State private var message: String = ""

    var body: some View {
        VStack {
            TextField("Enter silly location", text: $sillyLocation)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Find Silly") {
                message = findSilly(sillyLocation)
            }
            .padding()

            Text(message)
                .padding()
        }
        .padding()
    }

    func findSilly(_ silly: String) -> String {
        switch silly {
        case "under the couch":
            return "Found it! Your silly is under the couch! 🎉"
        case "in a sock":
            return "Found it! Your silly is in a sock! 🎉"
        case "on the shelf":
            return "Found it! Your silly is on the shelf! 🎉"
        default:
            return "Hmm... where could your silly be? 🤔"
        }
    }
}



struct 🌟WhiskersFinder300: View {
    var body: some View {
        VStack {
            Text("Welcome to Whiskers Finder300! 🐱✨")
                .font(.largeTitle)
                .padding()
            Button(action: {
                print("Fur-tastic find! 你")
            }) {
                Text("Find Silly Things! 🐾")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

