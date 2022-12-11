import Foundation

struct Day7 {
    
    static func main() {
        let root = parseInput()
        print("root size: \(root.size)")
        
        let available = 70000000 - root.size
        let minimum = 30000000 - available
        print("minimum to free: \(minimum)")
        
        let deleteDir = findSmallestToDelete(from: root, target: minimum)
        
        root.size = 0 // root doesn't count
        let sum = sumSizesRec(of: root, maximumSize: 100000)
        
        print("Part 1: \(sum)")
        print("Part 2: \(deleteDir!.size)")
    }
    
    private static func sumSizesRec(of directory: Directory, maximumSize: Int64) -> Int64 {
        let childrenSize = directory.directories.map {
            sumSizesRec(of: $0, maximumSize: maximumSize)
        }.reduce(0, +)
        
        return childrenSize + (directory.size <= maximumSize ? directory.size : 0)
    }
    
    private static func findSmallestToDelete(from directory: Directory, target: Int64) -> Directory? {
        
        if directory.size < target {
            return nil
        }
        let smallestChild = directory.directories.compactMap { findSmallestToDelete(from: $0, target: target) }.min { $0.size < $1.size }
        
        guard let smallestChild = smallestChild else {
            return directory
        }
        
        return smallestChild.size < directory.size ? smallestChild : directory
    }
    
    private struct File {
        let name: String
        let size: Int64
    }
    
    private class Directory {
        let name: String
        var files = [File]()
        var directories = [Directory]()
        let parent: Any?
        var size: Int64 = 0
        
        init(name: String, parent: Any?) {
            self.name = name
            self.parent = parent
        }
    }
    
    private struct Command {
        init(text: String) {
            
        }
    }
    
    private static func parseInput() -> Directory {
        let input = try! String(contentsOfFile: "/Users/dturner/code/adventofcode2022/adventofcode2022/day7.txt")
        
        let inputLines = input.components(separatedBy: "\n")
        var iter = inputLines.makeIterator()
        let root = Directory(name:"ROOT", parent: nil)
        var current = root
        
        _ = iter.next()
        var nextCommand = iter.next()
        while nextCommand != nil {
            guard let command = nextCommand else {
                break
            }
            
//            print(command)
            
            if command.starts(with: "$ cd") {
                let nextDir = command.replacingOccurrences(of: "$ cd ", with: "")
                if nextDir == ".." {
                    if let parent = current.parent as? Directory {
                        current = parent
                    }
                } else {
                    current = current.directories.first(where: {$0.name.compare(nextDir) == ComparisonResult.orderedSame})!
                }
                nextCommand = iter.next()
            } else if command.starts(with: "$ ls") {
                // read lines until we get a command
                while true {
                    guard let entry = iter.next() else {
                        return root // no more lines
                    }
                    
                    if entry.starts(with: "$") {
                        nextCommand = entry
                        break
                    } else if entry.starts(with: "dir") {
                        let dirName = entry.replacingOccurrences(of: "dir ", with: "")
                        current.directories.append(Directory(name: dirName, parent: current))
                    } else {
                        let split = entry.components(separatedBy: " ")
                        let size = Int64(split.first!)!
                        let fileName = split.last!
                        current.files.append(File(name: fileName, size: size))
                        current.size += size
                        var parent = current.parent as? Directory
                        while parent != nil {
                            parent!.size += size
                            parent = parent!.parent as? Directory
                        }
                    }
                }
            }
        }
        
        return root
    }
}
