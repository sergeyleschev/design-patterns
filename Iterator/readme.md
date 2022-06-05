# S.Leschev Design Patterns (Swift 5+)
Google Engineering Level: L6+

## 🏆 Awards
### Ranking #Dev: Global TOP 300 ([Certificate](https://leetcode.com/sergeyleschev/))
<a href="https://leetcode.com/sergeyleschev/"><img itemprop="image" alt="Sergey Leschev" src="https://github.com/sergeyleschev/sergeyleschev/blob/main/leetcode-ranking.png?raw=true" width="410"/></a>

**Languages**: Swift, Shell, Database (T-SQL, PL/SQL, MySQL), Concurrency (Python3).

**Algorithms**: linked lists, binary search, hash table, queue/stack, dfs/bfs, sort, heap/hash, two pointers, sliding window, tree, greedy problems etc.

🍫 Iterator
-----------

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

### Example:

```swift
struct Novella {
    let name: String
}

struct Novellas {
    let novellas: [Novella]
}

struct NovellasIterator: IteratorProtocol {

    private var current = 0
    private let novellas: [Novella]

    init(novellas: [Novella]) {
        self.novellas = novellas
    }

    mutating func next() -> Novella? {
        defer { current += 1 }
        return novellas.count > current ? novellas[current] : nil
    }
}

extension Novellas: Sequence {
    func makeIterator() -> NovellasIterator {
        return NovellasIterator(novellas: novellas)
    }
}
```

### Usage

```swift
let greatNovellas = Novellas(novellas: [Novella(name: "The Mist")] )

for novella in greatNovellas {
    print("I've read: \(novella)")
}
```


## Contacts

I have a clear focus on time-to-market and don't prioritize technical debt.
 
🛩️ #startups #management #cto #swift #typescript #database

📧 Email: [sergey.leschev@gmail.com](mailto:sergey.leschev@gmail.com)

👋 LinkedIn: [https://linkedin.com/in/sergeyleschev](https://www.linkedin.com/in/sergeyleschev/)

👋 Twitter: [https://twitter.com/sergeyleschev](https://twitter.com/sergeyleschev)

👋 Github: [https://github.com/sergeyleschev](https://github.com/sergeyleschev)

🌎 Website: [https://sergeyleschev.github.io](https://sergeyleschev.github.io)

🖨️ PDF: [Download](https://sergeyleschev.github.io/sergeyleschev-design-patterns.pdf)

ALT: SIARHEI LIASHCHOU