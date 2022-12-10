import Foundation

struct Day5 {
    
    static func main() {
        let stacks = parseInput()
        for (key, stack) in stacks {
            print("\(key) : \(stack.joined(separator:" "))")
        }
        let result = stacks.sorted(by: { pair1, pair2 in
            return Int(pair1.key)! < Int(pair2.key)!
        }).map { (_, stack) in
            stack.last!
        }.joined(separator: "")

        print(result)
    }
    
    private static func parseInput() -> [String: [String]] {
        let input = try! String(contentsOfFile: "/Users/dturner/code/adventofcode2022/adventofcode2022/day5.txt")
        
        var stackLines: [String] = []
        var stacks: [String: [String]] = [:]
        let regex = try! NSRegularExpression(pattern: #"move (?<amount>\d+) from (?<stack1>\d+) to (?<stack2>\d+)"#, options: [])

        for line in input.components(separatedBy: "\n") {
            if line.starts(with: "[") {
                stackLines.insert(line, at: 0)
            } else if line.trimmingCharacters(in: .whitespaces).starts(with: "1") {
                let numbers = line.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "   ", with: " ").components(separatedBy: " ")
                for number in numbers {
                    if stacks[number] == nil {
                        stacks[number] = [String]()
                    }
                    
                    let index = (Int(number)! - 1) * 4
                    for stackLine in stackLines {
                        let crate = String(stackLine[index+1]).trimmingCharacters(in: .whitespaces)
                        if !crate.isEmpty {
                            stacks[number]!.append(String(stackLine[index+1]))
                        }
                    }
                }
            } else if line.trimmingCharacters(in: .whitespaces).starts(with: "move") {
                let nsrange = NSRange(line.startIndex..<line.endIndex, in: line)
                if let match = regex.firstMatch(in: line, options: [], range: nsrange) {
                    let amount = Int(line[Range(match.range(withName: "amount"))!])!
                    let stack1 = String(line[Range(match.range(withName: "stack1"))!])
                    let stack2 = String(line[Range(match.range(withName: "stack2"))!])
                    
                    // Part 1
//                    while amount > 0 {
//                        if let crate = stacks[stack1]!.last {
//                            stacks[stack1] = Array(stacks[stack1]!.dropLast(1))
//                            stacks[stack2]!.append(crate)
//                        }
//                        amount -= 1
//                    }
                    
                    // Part 2
                    let stack1List = stacks[stack1]!
                    let crates = stack1List.suffix(amount)
//                    print("STACK1 \(amount): \(stack1List.joined(separator: ", ")) => \(crates.joined(separator: ", "))")
                    stacks[stack1] = Array(stack1List.prefix(stack1List.count-amount))
//                    print("STACK2 \(amount): \(stacks[stack2]!.joined(separator: ", ")) => \((stacks[stack2]! + crates).joined(separator: ", "))")
                    stacks[stack2] = stacks[stack2]! + crates
                }
            }
        }
        return stacks
    }
}
