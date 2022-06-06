# S.Leschev Design Patterns (Swift 5+)
Google Engineering Level: L6+

## 🏆 Awards
### Ranking #Dev: Global TOP 300 ([Certificate](https://leetcode.com/sergeyleschev/))
<a href="https://leetcode.com/sergeyleschev/"><img itemprop="image" alt="Sergey Leschev" src="https://github.com/sergeyleschev/sergeyleschev/blob/main/leetcode-ranking.png?raw=true" width="410"/></a>

**Languages**: Swift, Shell, Database (T-SQL, PL/SQL, MySQL), Concurrency (Python3).

**Algorithms**: linked lists, binary search, hash table, queue/stack, dfs/bfs, sort, heap/hash, two pointers, sliding window, tree, greedy problems etc.

 🔂 Monostate
 ------------

 The monostate pattern is another way to achieve singularity. It works through a completely different mechanism, it enforces the behavior of singularity without imposing structural constraints. 
 So in that case, monostate saves the state as static instead of the entire instance as a singleton.
 [SINGLETON and MONOSTATE - Robert C. Martin](http://staff.cs.utu.fi/~jounsmed/doos_06/material/SingletonAndMonostate.pdf)

### Example:

```swift
class Settings {

    enum Theme {
        case `default`
        case old
        case new
    }

    private static var theme: Theme?

    var currentTheme: Theme {
        get { Settings.theme ?? .default }
        set(newTheme) { Settings.theme = newTheme }
    }
}
```

### Usage:

```swift

import SwiftUI

// When change the theme
let settings = Settings() // Starts using theme .old
settings.currentTheme = .new // Change theme to .new

// On screen 1
let screenColor: Color = Settings().currentTheme == .old ? .gray : .white

// On screen 2
let screenTitle: String = Settings().currentTheme == .old ? "Itunes Connect" : "App Store Connect"
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