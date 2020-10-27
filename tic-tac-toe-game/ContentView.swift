//
//  ContentView.swift
//  tic-tac-toe-game
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Tic Tac Toe")
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    // Moves
    @State var moves: [String] = Array(repeating: "", count: 9)
    
    // Identify the current player
    @State var isPlayingX = true
    
    @State var gameOver = false
    @State var msg = ""
    
    var body: some View {
        VStack {
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(
                        .flexible(), spacing: 15
                    ),
                    count: 3
                ),
                spacing : 15
            ) {
                ForEach(0..<9, id: \.self) { index in
                    ZStack {
                        
                        // Flip animation
                        Color.blue
                        
                        Color.white
                            .opacity(moves[index] == "" ? 1 : 0)
                        
                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .opacity(moves[index] != "" ? 1 : 0)
                    }
                    .frame(
                        width: getSize(),
                        height: getSize()
                    )
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
                        anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                        anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                        perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
                    )
                    // Add move on tap
                    .onTapGesture(
                        perform: {
                            withAnimation(
                                Animation.easeIn(
                                    duration: 0.5
                                )
                            ) {
                                if moves[index] == "" {
                                    moves[index] = isPlayingX ? "X" : "0"
                                    isPlayingX.toggle()
                                }
                            }
                        }
                    )
                }
            }
            .padding(15)
        }
        // Check winner when moves updates
        .onChange(of: moves, perform: { value in
            checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            Alert(
                title: Text("Winner"),
                message: Text(msg),
                dismissButton: .destructive(
                    Text("Play again!"),
                    action: {
                        // Reset
                        withAnimation(
                            Animation.easeIn(
                                duration: 0.5
                            )
                        ) {
                            moves.removeAll()
                            moves = Array(repeating: "", count: 9)
                            isPlayingX = true
                        }
                    })
            )
        })
    }
    
    // Calculate size
    func getSize()->CGFloat {
        // Horizontal padding is 30
        // Spacing is 30
        let width = UIScreen.main.bounds.width - (30 + 30)
        return width / 3
    }
    
    // Check winner
    func checkWinner() {
        if checkMoves(player: "X") {
            msg = "Player X Won!"
            gameOver.toggle()
        } else if checkMoves(player: "0") {
            msg = "Player 0 Won!"
            gameOver.toggle()
        } else {
            // No more moves
            let status = moves.contains { (value) -> Bool in
                return value == ""
            }
            if !status {
                msg = "Game Over. Tied!"
                gameOver.toggle()
            }
        }
    }
    func checkMoves(player: String)->Bool {
        
        // Horizontal
        for i in stride(from: 0, to: 9, by: 3) {
            if moves[i] == player && moves[i + 1] == player && moves[i + 2] == player {
                return true
            }
        }
        
        // Vertical
        for i in 0...2 {
            if moves[i] == player && moves[i + 3] == player && moves[i + 6] == player {
                return true
            }
        }
        
        // Diagonal
        if moves[0] == player && moves[4] == player && moves[8] == player {
            return true
        }
        if moves[2] == player && moves[4] == player && moves[6] == player {
            return true
        }
        
        return false
    }
}
