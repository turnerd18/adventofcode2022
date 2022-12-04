struct Day3 {
    static func main() {
        let input = try! String(contentsOfFile: "/Users/dturner/code/adventofcode2022/adventofcode2022/day3.txt");
        
        let lines = input.components(separatedBy: "\n").filter {
            !$0.isEmpty
        };
        let sackValues = lines.map { line in
            let bag1 = line[0..<line.count/2];
            let bag2 = line[line.count/2..<line.count];
            let shared = Set(bag1).intersection(Set(bag2)).first!;
            let value = scoreCharacter(shared);
            return Int(value);
        };
        
        print("Part 1: \(sackValues.reduce(0, +))")
                
        var groupLines = [String]();
        var part2Score = 0;
        for (index, line) in lines.enumerated() {
            groupLines.append(line);
            if (index + 1) % 3 == 0 {
                let badge = groupLines.map { Set($0) }.reduce(Set<Character>()) { result, next in
                    return result.isEmpty ? next : result.intersection(next)
                }.first
                part2Score += scoreCharacter(badge!);
                groupLines = [String]();
            }
        }
        
        print("Part 2: \(part2Score)")
    }
    
    static func scoreCharacter(_ character: Character) -> Int {
        return Int(character.isUppercase
            ? character.unicodeScalarCodePoint() - 64 + 26
            : character.unicodeScalarCodePoint() - 96);
    }
}

