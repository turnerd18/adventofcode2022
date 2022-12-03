struct Day2 {
    enum Move: Int {
        case rock = 1
        case paper = 2
        case scissors = 3
    }
    
    enum Outcome: Int {
        case lose = 0
        case draw = 3
        case win = 6
    }
    
    static let opponentMoves = [
        "A": Move.rock,
        "B": Move.paper,
        "C": Move.scissors
    ];
    
    static let playerMoves = [
        "X": Move.rock,
        "Y": Move.paper,
        "Z": Move.scissors
    ];
    
    static let playerOutcomes : Dictionary<String, Outcome> = [
        "X": .lose,
        "Y": .draw,
        "Z": .win
    ];
    
    static let winningMoves : Dictionary<Move, Move> = [
        .rock: .scissors,
        .scissors: .paper,
        .paper: .rock
    ];
    static let reverseWinningMoves : Dictionary<Move, Move> = [
        .scissors: .rock,
        .paper: .scissors,
        .rock: .paper
    ];
    
    static func main() {
        let input = try! String(contentsOfFile: "/Users/dturner/code/adventofcode2022/adventofcode2022/day2.txt");
        
        let part1Scores = input.components(separatedBy: "\n").filter { line in
            !line.isEmpty
        }.map { line in
            let round = line.components(separatedBy: " ");
            return (opponentMoves[round[0]]!, playerMoves[round[1]]!)
        }.map(scorePart1);
        
        print("Part 1: \(part1Scores.reduce(0, +))")
        
        let part2Scores = input.components(separatedBy: "\n").filter { line in
            !line.isEmpty
        }.map { line in
            let round = line.components(separatedBy: " ");
            return (opponentMoves[round[0]]!, playerOutcomes[round[1]]!)
        }.map { (roundTuple: (Move, Outcome)) in
            scorePart2(opponentMove: roundTuple.0, outcome: roundTuple.1)
        };
        
        print("Part 2: \(part2Scores.reduce(0, +))")
    }
    
    static func scorePart1(moveTuple: (Move, Move)) -> Int {
        let opponentMove = moveTuple.0;
        let playerMove = moveTuple.1;
        
        if opponentMove == playerMove {
            return playerMove.rawValue + Outcome.draw.rawValue;
        } else if winningMoves[playerMove] == opponentMove {
            return playerMove.rawValue + Outcome.win.rawValue;
        } else {
            return playerMove.rawValue + Outcome.lose.rawValue;
        }
    }
    
    static func scorePart2(opponentMove: Move, outcome: Outcome) -> Int {
        switch outcome {
        case .draw:
            return opponentMove.rawValue + Outcome.draw.rawValue;
        case .win:
            return reverseWinningMoves[opponentMove]!.rawValue + Outcome.win.rawValue;
        case .lose:
            let allMoves: Set<Move> = [.rock, .paper, .scissors];
            let wrongMoves: Set<Move> = [opponentMove, reverseWinningMoves[opponentMove]!];
            return allMoves.subtracting(wrongMoves).first!.rawValue + Outcome.lose.rawValue;
        }
    }
}
