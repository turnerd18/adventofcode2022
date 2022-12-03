func day1() {
    let input = try! String(contentsOfFile: "/Users/dturner/code/adventofcode2022/adventofcode2022/day1.txt");
    
    let elfCalories = input.components(separatedBy: "\n\n").map { elf in
        return elf.components(separatedBy: "\n").map { intStr in
            Int(intStr) ?? 0
        }.reduce(0, +);
    }.sorted()
    
    print("Part 1: \(elfCalories.last!)")
    print("Part 2: \(elfCalories.suffix(3).reduce(0, +))")
}

