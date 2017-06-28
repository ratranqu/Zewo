struct MapStack<T> {
    private(set) var stack: [T] = []
    
    init() {}
    
    var count: Int {
        return stack.count
    }
    
    var top: T {
        precondition(stack.count > 0, "Empty container stack.")
        return stack.last!
    }
    
    mutating func push(_ map: T) {
        stack.append(map)
    }
    
    @discardableResult mutating func pop() -> T {
        precondition(stack.count > 0, "Empty map stack.")
        return stack.popLast()!
    }
    
    mutating func pushing<R>(_ map: T, body: () throws -> R) rethrows -> R {
        push(map)
        let result: R = try body()
        pop()
        return result
    }
}
