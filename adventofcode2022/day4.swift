struct Day4 {
    private struct CleanUp {
        let start: Int
        let end: Int
        
        func envelops(other: CleanUp) -> Bool {
            return start <= other.start
                && other.start <= end
                && start <= other.end
                && other.end <= end;
        }
        
        func overlaps(other: CleanUp) -> Bool {
            return (start <= other.start
                && other.start <= end)
                || (start <= other.end
                && other.end <= end)
        }
    }
    
    static func main() {
        let input = try! String(contentsOfFile: "/Users/dturner/code/adventofcode2022/adventofcode2022/day4.txt")
        
        let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        var envelopsCount = 0
        var overlapsCount = 0
        for line in lines {
            let lineSplit = line.components(separatedBy: ",")
            let elf1Split = lineSplit[0].components(separatedBy: "-")
            let elf2Split = lineSplit[1].components(separatedBy: "-")
            let elf1 = CleanUp(start: Int(elf1Split[0])!, end: Int(elf1Split[1])!)
            let elf2 = CleanUp(start: Int(elf2Split[0])!, end: Int(elf2Split[1])!)

            if elf1.envelops(other: elf2) || elf2.envelops(other: elf1) {
                envelopsCount += 1
                overlapsCount += 1
            } else if elf1.overlaps(other: elf2) || elf2.overlaps(other: elf1) {
                overlapsCount += 1
            }
        }

        print("Part 1: \(envelopsCount)")
        print("Part 2: \(overlapsCount)")
    }
}
