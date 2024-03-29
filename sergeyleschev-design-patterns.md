# S.Leschev Design Patterns (Swift 5+)

<img itemprop="image" alt="Sergey Leschev" src="https://sergeyleschev.github.io/sergeyleschev.png" width=250/>

Google Engineering Level: L6+

## 🏆 Awards

### Ranking #Dev: Global TOP 200 ([Certificate](https://leetcode.com/sergeyleschev/))

<a href="https://leetcode.com/sergeyleschev/"><img itemprop="image" alt="Sergey Leschev" src="https://github.com/sergeyleschev/sergeyleschev/blob/main/leetcode-ranking.png?raw=true" width="410"/></a>

<a href="https://leetcode.com/sergeyleschev/"><img itemprop="image" alt="Sergey Leschev" src="https://github.com/sergeyleschev/sergeyleschev/blob/main/leetcode-medals.png?raw=true" width="280"/></a>

**Languages**: Swift, Shell, Database (T-SQL, PL/SQL, MySQL), Concurrency (Python3).

**Algorithms**: linked lists, binary search, hash table, queue/stack, dfs/bfs, sort, heap/hash, two pointers, sliding window, tree, greedy problems etc.

---

<div style="page-break-after: always;"></div>

### Golden Award Muad'Dib's Challenge

<a href="https://app.codility.com/cert/view/cert5YT6JA-Y9ZKFEFXEZWGTR3G/"><img itemprop="image" alt="Sergey Leschev" src="https://github.com/sergeyleschev/sergeyleschev/blob/main/codility-ranking-muaddibs.png?raw=true" width="410"/></a>

**Languages**: Swift.

**Algorithmic skills**: Dynamic programming, Greedy algorithms, Binary search, Stack and Queues, Sorting, Time Complexity.

**Contest**: Algorithms, Data Structures.

---

<div style="page-break-after: always;"></div>

## Table of Contents

| [Behavioral](#behavioral)                               | [Creational](#creational)                 | [Structural](#structural)                 |
| ---------------------------------------------------- | -------------------------------------- | -------------------------------------- |
| [🐝 Chain Of Responsibility](#-chain-of-responsibility) | [🌰 Abstract Factory](#-abstract-factory) | [🔌 Adapter](#-adapter)                   |
| [👫 Command](#-command)                                 | [👷 Builder](#-builder)                   | [🌉 Bridge](#-bridge)                     |
| [🎶 Interpreter](#-interpreter)                         | [🏭 Factory Method](#-factory-method)     | [🌿 Composite](#-composite)               |
| [🍫 Iterator](#-iterator)                               | [🔂 Monostate](#-monostate)               | [🍧 Decorator](#-decorator)               |
| [💐 Mediator](#-mediator)                               | [🃏 Prototype](#-prototype)               | [🎁 Facade](#-facade)                     |
| [💾 Memento](#-memento)                                 | [💍 Singleton](#-singleton)               | [🍃 Flyweight](#-flyweight)               |
| [👓 Observer](#-observer)                               |                                        | [☔ Protection Proxy](#-protection-proxy) |
| [🐉 State](#-state)                                     |                                        | [🍬 Virtual Proxy](#-virtual-proxy)       |
| [💡 Strategy](#-strategy)                               |                                        |                                        |
| [🏃 Visitor](#-visitor)                                 |                                        |                                        |
| [📝 Template Method](#-template-method)                 |                                        |                                        |

<div style="page-break-after: always;"></div>

Behavioral
----------

> In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
>
> **Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Behavioral_pattern)

🐝 Chain Of Responsibility
--------------------------

The chain of responsibility pattern is used to process varied requests, each of which may be dealt with by a different handler.

### Example:

```swift
protocol Withdrawing {
    func withdraw(amount: Int) -> Bool
}

final class MoneyPile: Withdrawing {
    let value: Int
    var quantity: Int
    var next: Withdrawing?

    init(value: Int, quantity: Int, next: Withdrawing?) {
        self.value = value
        self.quantity = quantity
        self.next = next
    }


    func withdraw(amount: Int) -> Bool {
        var amount = amount

        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }

        var quantity = self.quantity

        while canTakeSomeBill(want: amount) {

            if quantity == 0 {
                break
            }

            amount -= self.value
            quantity -= 1
        }

        guard amount > 0 else {
            return true
        }

        if let next = self.next {
            return next.withdraw(amount: amount)
        }

        return false
    }
}

final class ATM: Withdrawing {

    private var hundred: Withdrawing
    private var fifty: Withdrawing
    private var twenty: Withdrawing
    private var ten: Withdrawing

    private var startPile: Withdrawing {
        return self.hundred
    }

    init(hundred: Withdrawing,
           fifty: Withdrawing,
          twenty: Withdrawing,
             ten: Withdrawing) {

        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }

    func withdraw(amount: Int) -> Bool {
        return startPile.withdraw(amount: amount)
    }
}
```

### Usage

```swift
// Create piles of money and link them together 10 < 20 < 50 < 100.**
let ten = MoneyPile(value: 10, quantity: 6, next: nil)
let twenty = MoneyPile(value: 20, quantity: 2, next: ten)
let fifty = MoneyPile(value: 50, quantity: 2, next: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, next: fifty)

// Build ATM.
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.withdraw(amount: 310) // Cannot because ATM has only 300
atm.withdraw(amount: 100) // Can withdraw - 1x100
```

<div style="page-break-after: always;"></div>

👫 Command
----------

The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.

### Example:

```swift
protocol DoorCommand {
    func execute() -> String
}

final class OpenCommand: DoorCommand {
    let doors:String
    required init(doors: String) {
        self.doors = doors
    }
    func execute() -> String {
        return "Opened \(doors)"
    }
}

final class CloseCommand: DoorCommand {
    let doors:String

    required init(doors: String) {
        self.doors = doors
    }
    func execute() -> String {
        return "Closed \(doors)"
    }
}


final class HAL9000DoorsOperations {
    let openCommand: DoorCommand
    let closeCommand: DoorCommand
  
    init(doors: String) {
        self.openCommand = OpenCommand(doors:doors)
        self.closeCommand = CloseCommand(doors:doors)
    }

    func close() -> String {
        return closeCommand.execute()
    }
  
    func open() -> String {
        return openCommand.execute()
    }
}
```

### Usage:

```swift
let podBayDoors = "Pod Bay Doors"
let doorModule = HAL9000DoorsOperations(doors:podBayDoors)

doorModule.open()
doorModule.close()
```

<div style="page-break-after: always;"></div>

🎶 Interpreter
--------------

The interpreter pattern is used to evaluate sentences in a language.

### Example

```swift
protocol IntegerExpression {
    func evaluate(_ context: IntegerContext) -> Int
    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression
    func copied() -> IntegerExpression
}

final class IntegerContext {
    private var data: [Character:Int] = [:]

    func lookup(name: Character) -> Int {
        return self.data[name]!
    }

    func assign(expression: IntegerVariableExpression, value: Int) {
        self.data[expression.name] = value
    }
}

final class IntegerVariableExpression: IntegerExpression {
    let name: Character

    init(name: Character) {
        self.name = name
    }

    func evaluate(_ context: IntegerContext) -> Int {
        return context.lookup(name: self.name)
    }

    func replace(character name: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        if name == self.name {
            return integerExpression.copied()
        } else {
            return IntegerVariableExpression(name: self.name)
        }
    }

    func copied() -> IntegerExpression {
        return IntegerVariableExpression(name: self.name)
    }
}

final class AddExpression: IntegerExpression {
    private var operand1: IntegerExpression
    private var operand2: IntegerExpression

    init(op1: IntegerExpression, op2: IntegerExpression) {
        self.operand1 = op1
        self.operand2 = op2
    }

    func evaluate(_ context: IntegerContext) -> Int {
        return self.operand1.evaluate(context) + self.operand2.evaluate(context)
    }

    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        return AddExpression(op1: operand1.replace(character: character, integerExpression: integerExpression),
                             op2: operand2.replace(character: character, integerExpression: integerExpression))
    }

    func copied() -> IntegerExpression {
        return AddExpression(op1: self.operand1, op2: self.operand2)
    }
}
```

### Usage

```swift
var context = IntegerContext()

var a = IntegerVariableExpression(name: "A")
var b = IntegerVariableExpression(name: "B")
var c = IntegerVariableExpression(name: "C")

var expression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c)) // a + (b + c)

context.assign(expression: a, value: 2)
context.assign(expression: b, value: 1)
context.assign(expression: c, value: 3)

var result = expression.evaluate(context)
```

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

<div style="page-break-after: always;"></div>

💐 Mediator
-----------

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

### Example

```swift
protocol Receiver {
    associatedtype MessageType
    func receive(message: MessageType)
}

protocol Sender {
    associatedtype MessageType
    associatedtype ReceiverType: Receiver
  
    var recipients: [ReceiverType] { get }
  
    func send(message: MessageType)
}

struct Programmer: Receiver {
    let name: String
  
    init(name: String) {
        self.name = name
    }
  
    func receive(message: String) {
        print("\(name) received: \(message)")
    }
}

final class MessageMediator: Sender {
    internal var recipients: [Programmer] = []
  
    func add(recipient: Programmer) {
        recipients.append(recipient)
    }
  
    func send(message: String) {
        for recipient in recipients {
            recipient.receive(message: message)
        }
    }
}

```

### Usage

```swift
func spamMonster(message: String, worker: MessageMediator) {
    worker.send(message: message)
}

let messagesMediator = MessageMediator()

let user0 = Programmer(name: "Linus Torvalds")
let user1 = Programmer(name: "Avadis 'Avie' Tevanian")
messagesMediator.add(recipient: user0)
messagesMediator.add(recipient: user1)

spamMonster(message: "I'd Like to Add you to My Professional Network", worker: messagesMediator)

```

<div style="page-break-after: always;"></div>

💾 Memento
----------

The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.

### Example

```swift
typealias Memento = [String: String]
```

Originator

```swift
protocol MementoConvertible {
    var memento: Memento { get }
    init?(memento: Memento)
}

struct GameState: MementoConvertible {

    private enum Keys {
        static let chapter = "com.valve.halflife.chapter"
        static let weapon = "com.valve.halflife.weapon"
    }

    var chapter: String
    var weapon: String

    init(chapter: String, weapon: String) {
        self.chapter = chapter
        self.weapon = weapon
    }

    init?(memento: Memento) {
        guard let mementoChapter = memento[Keys.chapter],
              let mementoWeapon = memento[Keys.weapon] else {
            return nil
        }

        chapter = mementoChapter
        weapon = mementoWeapon
    }


    var memento: Memento {
        return [ Keys.chapter: chapter, Keys.weapon: weapon ]
    }
}
```

Caretaker

```swift
enum CheckPoint {

    private static let defaults = UserDefaults.standard

    static func save(_ state: MementoConvertible, saveName: String) {
        defaults.set(state.memento, forKey: saveName)
        defaults.synchronize()
    }

    static func restore(saveName: String) -> Any? {
        return defaults.object(forKey: saveName)
    }
}
```

<div style="page-break-after: always;"></div>

### Usage

```swift
var gameState = GameState(chapter: "Black Mesa Inbound", weapon: "Crowbar")

gameState.chapter = "Anomalous Materials"
gameState.weapon = "Glock 17"
CheckPoint.save(gameState, saveName: "gameState1")

gameState.chapter = "Unforeseen Consequences"
gameState.weapon = "MP5"
CheckPoint.save(gameState, saveName: "gameState2")

gameState.chapter = "Office Complex"
gameState.weapon = "Crossbow"
CheckPoint.save(gameState, saveName: "gameState3")

if let memento = CheckPoint.restore(saveName: "gameState1") as? Memento {
    let finalState = GameState(memento: memento)
    dump(finalState)
}
```

<div style="page-break-after: always;"></div>

👓 Observer
-----------

The observer pattern is used to allow an object to publish changes to its state.
Other objects subscribe to be immediately notified of any changes.

### Example

```swift
protocol PropertyObserver : class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}

final class TestChambers {
    weak var observer:PropertyObserver?

    private let testChamberNumberName = "testChamberNumber"

    var testChamberNumber: Int = 0 {
        willSet(newValue) {
            observer?.willChange(propertyName: testChamberNumberName, newPropertyValue: newValue)
        }
        didSet {
            observer?.didChange(propertyName: testChamberNumberName, oldPropertyValue: oldValue)
        }
    }
}

final class Observer : PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if newPropertyValue as? Int == 1 {
            print("Okay. Look.")
        }
    }

    func didChange(propertyName: String, oldPropertyValue: Any?) {
        if oldPropertyValue as? Int == 0 {
            print("Sorry about the mess.")
        }
    }
}
```

### Usage

```swift
var observerInstance = Observer()
var testChambers = TestChambers()
testChambers.observer = observerInstance
testChambers.testChamberNumber += 1
```

🐉 State
--------

The state pattern is used to alter the behaviour of an object as its internal state changes.
The pattern allows the class for an object to apparently change at run-time.

### Example

```swift
final class Context {
    private var state: State = UnauthorizedState()

    var isAuthorized: Bool {
        get { return state.isAuthorized(context: self) }
    }

    var userId: String? {
        get { return state.userId(context: self) }
    }

    func changeStateToAuthorized(userId: String) {
        state = AuthorizedState(userId: userId)
    }

    func changeStateToUnauthorized() {
        state = UnauthorizedState()
    }
}

protocol State {
    func isAuthorized(context: Context) -> Bool
    func userId(context: Context) -> String?
}

class UnauthorizedState: State {
    func isAuthorized(context: Context) -> Bool { return false }
    func userId(context: Context) -> String? { return nil }
}

class AuthorizedState: State {
    let userId: String
    init(userId: String) { self.userId = userId }
    func isAuthorized(context: Context) -> Bool { return true }
    func userId(context: Context) -> String? { return userId }
}
```

### Usage

```swift
let userContext = Context()
(userContext.isAuthorized, userContext.userId)
userContext.changeStateToAuthorized(userId: "admin")
(userContext.isAuthorized, userContext.userId) // now logged in as "admin"
userContext.changeStateToUnauthorized()
(userContext.isAuthorized, userContext.userId)
```

💡 Strategy
-----------

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

### Example

```swift
struct TestSubject {
    let pupilDiameter: Double
    let blushResponse: Double
    let isOrganic: Bool
}

protocol RealnessTesting: AnyObject {
    func testRealness(_ testSubject: TestSubject) -> Bool
}

final class VoightKampffTest: RealnessTesting {
    func testRealness(_ testSubject: TestSubject) -> Bool {
        return testSubject.pupilDiameter < 30.0 || testSubject.blushResponse == 0.0
    }
}
final class GeneticTest: RealnessTesting {
    func testRealness(_ testSubject: TestSubject) -> Bool {
        return testSubject.isOrganic
    }
}
final class BladeRunner {
    private let strategy: RealnessTesting
    init(test: RealnessTesting) { self.strategy = test }
    func testIfAndroid(_ testSubject: TestSubject) -> Bool {
        return !strategy.testRealness(testSubject)
    }
}
```

### Usage

```swift
let rachel = TestSubject(pupilDiameter: 30.2,
                         blushResponse: 0.3,
                         isOrganic: false)

// Deckard is using a traditional test
let deckard = BladeRunner(test: VoightKampffTest())
let isRachelAndroid = deckard.testIfAndroid(rachel)

// Gaff is using a very precise method
let gaff = BladeRunner(test: GeneticTest())
let isDeckardAndroid = gaff.testIfAndroid(rachel)
```

📝 Template Method
------------------

 The template method pattern defines the steps of an algorithm and allows the redefinition of one or more of these steps. In this way, the template method protects the algorithm, the order of execution and provides abstract methods that can be implemented by concrete types.

### Example

```swift

protocol Garden {
    func prepareSoil()
    func plantSeeds()
    func waterPlants()
    func prepareGarden()
}



extension Garden {
    func prepareGarden() {
        prepareSoil()
        plantSeeds()
        waterPlants()
    }
}

final class RoseGarden: Garden {

    func prepare() {
        prepareGarden()
    }

    func prepareSoil() {
        print ("prepare soil for rose garden")
    }

    func plantSeeds() {
        print ("plant seeds for rose garden")
    }

    func waterPlants() {
       print ("water the rose garden")
    }
}
```

### Usage

```swift
let roseGarden = RoseGarden()
roseGarden.prepare()
```

<div style="page-break-after: always;"></div>

🏃 Visitor
----------

The visitor pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold.

### Example

```swift
protocol PlanetVisitor {
    func visit(planet: PlanetAlderaan)
    func visit(planet: PlanetCoruscant)
    func visit(planet: PlanetTatooine)
    func visit(planet: MoonJedha)
}

protocol Planet {
    func accept(visitor: PlanetVisitor)
}

final class MoonJedha: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

final class PlanetAlderaan: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

final class PlanetCoruscant: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

final class PlanetTatooine: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

final class NameVisitor: PlanetVisitor {
    var name = ""

    func visit(planet: PlanetAlderaan)  { name = "Alderaan" }
    func visit(planet: PlanetCoruscant) { name = "Coruscant" }
    func visit(planet: PlanetTatooine)  { name = "Tatooine" }
    func visit(planet: MoonJedha)       { name = "Jedha" }
}

```

### Usage

```swift
let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine(), MoonJedha()]

let names = planets.map { (planet: Planet) -> String in
    let visitor = NameVisitor()
    planet.accept(visitor: visitor)

    return visitor.name
}

names
```

Creational
----------

> In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
>
> **Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Creational_pattern)

🌰 Abstract Factory
-------------------

The abstract factory pattern is used to provide a client with a set of related or dependant objects.
The "family" of objects created by the factory are determined at run-time.

### Example

Protocols

```swift
protocol BurgerDescribing {
    var ingredients: [String] { get }
}

struct CheeseBurger: BurgerDescribing {
    let ingredients: [String]
}

protocol BurgerMaking {
    func make() -> BurgerDescribing
}

// Number implementations with factory methods
final class BigKahunaBurger: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Lettuce", "Tomato"])
    }
}

final class JackInTheBox: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Tomato", "Onions"])
    }
}

```

Abstract factory

```swift

enum BurgerFactoryType: BurgerMaking {

    case bigKahuna
    case jackInTheBox

    func make() -> BurgerDescribing {
        switch self {
        case .bigKahuna:
            return BigKahunaBurger().make()
        case .jackInTheBox:
            return JackInTheBox().make()
        }
    }
}
```

### Usage

```swift
let bigKahuna = BurgerFactoryType.bigKahuna.make()
let jackInTheBox = BurgerFactoryType.jackInTheBox.make()
```

👷 Builder
----------

The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm.
An external class controls the construction algorithm.

### Example

```swift
final class DeathStarBuilder {
    var x: Double?
    var y: Double?
    var z: Double?

    typealias BuilderClosure = (DeathStarBuilder) -> ()

    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

struct DeathStar : CustomStringConvertible {
    let x: Double
    let y: Double
    let z: Double

    init?(builder: DeathStarBuilder) {
        if let x = builder.x, let y = builder.y, let z = builder.z {
            self.x = x
            self.y = y
            self.z = z
        } else {
            return nil
        }
    }

    var description:String {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}
```

### Usage

```swift
let empire = DeathStarBuilder { builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}

let deathStar = DeathStar(builder:empire)
```

🏭 Factory Method
-----------------

The factory pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.

### Example

```swift
protocol CurrencyDescribing {
    var symbol: String { get }
    var code: String { get }
}

final class Euro: CurrencyDescribing {
    var symbol: String { return "€" }
    var code: String { return "EUR" }
}

final class UnitedStatesDolar: CurrencyDescribing {
    var symbol: String { return "$" }
    var code: String { return "USD" }
}

enum Country {
    case unitedStates
    case spain
    case uk
    case greece
}

enum CurrencyFactory {
    static func currency(for country: Country) -> CurrencyDescribing? {
        switch country {
            case .spain, .greece:
                return Euro()
            case .unitedStates:
                return UnitedStatesDolar()
            default:
                return nil
        }
    }
}
```

### Usage

```swift
let noCurrencyCode = "No Currency Code Available"
CurrencyFactory.currency(for: .greece)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .spain)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .unitedStates)?.code ?? noCurrencyCode
CurrencyFactory.currency(for: .uk)?.code ?? noCurrencyCode
```

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

🃏 Prototype
------------

The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone.
This practise is particularly useful when the construction of a new object is inefficient.

### Example

```swift

class MoonWorker {

    let name: String
    var health: Int = 100

    init(name: String) {
        self.name = name
    }

    func clone() -> MoonWorker {
        return MoonWorker(name: name)
    }
}
```

### Usage

```swift
let prototype = MoonWorker(name: "Sam Bell")
var bell1 = prototype.clone()
bell1.health = 12
var bell2 = prototype.clone()
bell2.health = 23
var bell3 = prototype.clone()
bell3.health = 0
```

💍 Singleton
------------

The singleton pattern ensures that only one object of a particular class is ever created.
All further references to objects of the singleton class refer to the same underlying instance.
There are very few applications, do not overuse this pattern!

### Example:

```swift
final class ElonMusk {

    static let shared = ElonMusk()

    private init() {
        // Private initialization to ensure just one instance is created.
    }
}
```

### Usage:

```swift
let elon = ElonMusk.shared // There is only one Elon Musk folks.
```

<div style="page-break-after: always;"></div>

Structural
----------

> In software engineering, structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
> **Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Structural_pattern)

🔌 Adapter
----------

The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.

### Example

```swift
protocol NewDeathStarSuperLaserAiming {
    var angleV: Double { get }
    var angleH: Double { get }
}
```

**Adaptee**

```swift
struct OldDeathStarSuperlaserTarget {
    let angleHorizontal: Float
    let angleVertical: Float
    init(angleHorizontal: Float, angleVertical: Float) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
```

**Adapter**

```swift
struct NewDeathStarSuperlaserTarget: NewDeathStarSuperLaserAiming {

    private let target: OldDeathStarSuperlaserTarget

    var angleV: Double {
        return Double(target.angleVertical)
    }

    var angleH: Double {
        return Double(target.angleHorizontal)
    }

    init(_ target: OldDeathStarSuperlaserTarget) {
        self.target = target
    }
}
```

### Usage

```swift
let target = OldDeathStarSuperlaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let newFormat = NewDeathStarSuperlaserTarget(target)

newFormat.angleH
newFormat.angleV
```

🌉 Bridge
---------

The bridge pattern is used to separate the abstract elements of a class from the implementation details, providing the means to replace the implementation details without modifying the abstraction.

### Example

```swift
protocol Switch {
    var appliance: Appliance { get set }
    func turnOn()
}

protocol Appliance {
    func run()
}

final class RemoteControl: Switch {
    var appliance: Appliance
    func turnOn() {
        self.appliance.run()
    }
    init(appliance: Appliance) {
        self.appliance = appliance
    }
}

final class TV: Appliance {
    func run() {
        print("tv turned on");
    }
}

final class VacuumCleaner: Appliance {
    func run() {
        print("vacuum cleaner turned on")
    }
}
```

<div style="page-break-after: always;"></div>

### Usage

```swift
let tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

let fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()
```

🌿 Composite
------------

The composite pattern is used to create hierarchical, recursive tree structures of related objects where any element of the structure may be accessed and utilised in a standard manner.

### Example

Component

```swift
protocol Shape {
    func draw(fillColor: String)
}
```

Leafs

```swift
final class Square: Shape {
    func draw(fillColor: String) {
        print("Drawing a Square with color \(fillColor)")
    }
}


final class Circle: Shape {
    func draw(fillColor: String) {
        print("Drawing a circle with color \(fillColor)")
    }
}

```

Composite

```swift
final class Whiteboard: Shape {
    private lazy var shapes = [Shape]()

    init(_ shapes: Shape...) {
        self.shapes = shapes
    }

    func draw(fillColor: String) {
        for shape in self.shapes {
            shape.draw(fillColor: fillColor)
        }
    }
}
```

### Usage:

```swift
var whiteboard = Whiteboard(Circle(), Square())
whiteboard.draw(fillColor: "Red")
```

<div style="page-break-after: always;"></div>

🍧 Decorator
------------

The decorator pattern is used to extend or alter the functionality of objects at run- time by wrapping them in an object of a decorator class.
This provides a flexible alternative to using inheritance to modify behaviour.

### Example

```swift
protocol CostHaving {
    var cost: Double { get }
}
protocol IngredientsHaving {
    var ingredients: [String] { get }
}

typealias BeverageDataHaving = CostHaving & IngredientsHaving
struct SimpleCoffee: BeverageDataHaving {
    let cost: Double = 1.0
    let ingredients = ["Water", "Coffee"]
}

protocol BeverageHaving: BeverageDataHaving {
    var beverage: BeverageDataHaving { get }
}

struct Milk: BeverageHaving {
    let beverage: BeverageDataHaving
    var cost: Double {
        return beverage.cost + 0.5
    }
    var ingredients: [String] {
        return beverage.ingredients + ["Milk"]
    }
}

struct WhipCoffee: BeverageHaving {

    let beverage: BeverageDataHaving

    var cost: Double {
        return beverage.cost + 0.5
    }

    var ingredients: [String] {
        return beverage.ingredients + ["Whip"]
    }
}
```

### Usage:

```swift
var someCoffee: BeverageDataHaving = SimpleCoffee()
print("Cost: \(someCoffee.cost); Ingredients: \(someCoffee.ingredients)")
someCoffee = Milk(beverage: someCoffee)
print("Cost: \(someCoffee.cost); Ingredients: \(someCoffee.ingredients)")
someCoffee = WhipCoffee(beverage: someCoffee)
print("Cost: \(someCoffee.cost); Ingredients: \(someCoffee.ingredients)")
```

<div style="page-break-after: always;"></div>

🎁 Facade
---------

The facade pattern is used to define a simplified interface to a more complex subsystem.

### Example

```swift
final class Defaults {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    subscript(key: String) -> String? {
        get {
            return defaults.string(forKey: key)
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
```

### Usage

```swift
let storage = Defaults()
// Store
storage["Bishop"] = "Disconnect me. I’d rather be nothing"
// Read
storage["Bishop"]
```

## 🍃 Flyweight

The flyweight pattern is used to minimize memory usage or computational expenses by sharing as much as possible with other similar objects.

### Example

```swift
// Instances of SpecialityCoffee will be the Flyweights
struct SpecialityCoffee {
    let origin: String
}

protocol CoffeeSearching {
    func search(origin: String) -> SpecialityCoffee?
}

// Menu acts as a factory and cache for SpecialityCoffee flyweight objects
final class Menu: CoffeeSearching {

    private var coffeeAvailable: [String: SpecialityCoffee] = [:]

    func search(origin: String) -> SpecialityCoffee? {
        if coffeeAvailable.index(forKey: origin) == nil {
            coffeeAvailable[origin] = SpecialityCoffee(origin: origin)
        }

        return coffeeAvailable[origin]
    }
}

final class CoffeeShop {

    private var orders: [Int: SpecialityCoffee] = [:]
    private let menu: CoffeeSearching

    init(menu: CoffeeSearching) {
        self.menu = menu
    }

    func takeOrder(origin: String, table: Int) {
        orders[table] = menu.search(origin: origin)
    }

    func serve() {
        for (table, origin) in orders {
            print("Serving \(origin) to table \(table)")
        }
    }
}
```

### Usage

```swift
let coffeeShop = CoffeeShop(menu: Menu())

coffeeShop.takeOrder(origin: "Yirgacheffe, Ethiopia", table: 1)
coffeeShop.takeOrder(origin: "Buziraguhindwa, Burundi", table: 3)

coffeeShop.serve()
```

<div style="page-break-after: always;"></div>

☔ Protection Proxy
-------------------

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object.
Protection proxy is restricting access.

### Example

```swift
protocol DoorOpening {
    func open(doors: String) -> String
}

final class HAL9000: DoorOpening {
    func open(doors: String) -> String {
        return ("HAL9000: Affirmative, Dave. I read you. Opened \(doors).")
    }
}
final class CurrentComputer: DoorOpening {
    private var computer: HAL9000!
    func authenticate(password: String) -> Bool {
        guard password == "pass" else {
            return false
        }
        computer = HAL9000()
        return true
    }

    func open(doors: String) -> String {
        guard computer != nil else {
            return "Access Denied. I'm afraid I can't do that."
        }
        return computer.open(doors: doors)
    }
}
```

### Usage

```swift
let computer = CurrentComputer()
let podBay = "Pod Bay Doors"

computer.open(doors: podBay)

computer.authenticate(password: "pass")
computer.open(doors: podBay)
```

<div style="page-break-after: always;"></div>

🍬 Virtual Proxy
----------------

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object.
Virtual proxy is used for loading object on demand.

### Example

```swift
protocol HEVSuitMedicalAid {
    func administerMorphine() -> String
}
final class HEVSuit: HEVSuitMedicalAid {
    func administerMorphine() -> String {
        return "Morphine administered."
    }
}
final class HEVSuitHumanInterface: HEVSuitMedicalAid {
    lazy private var physicalSuit: HEVSuit = HEVSuit()
    func administerMorphine() -> String {
        return physicalSuit.administerMorphine()
    }
}
```

### Usage

```swift
let humanInterface = HEVSuitHumanInterface()
humanInterface.administerMorphine()
```

<div style="page-break-after: always;"></div>

## Project Guidelines (L6+)

A set of best practices in my projects.

- [X] [Git](https://github.com/sergeyleschev/sergeyleschev/blob/main/sergeyleschev-fullstack-project-guidelines.md#git)
- [X] [Documentation](https://github.com/sergeyleschev/sergeyleschev/blob/main/sergeyleschev-fullstack-project-guidelines.md#documentation)
- [X] [Environments](https://github.com/sergeyleschev/sergeyleschev/blob/main/sergeyleschev-fullstack-project-guidelines.md#environments)
- [X] [Code Style](https://github.com/sergeyleschev/sergeyleschev/blob/main/sergeyleschev-fullstack-project-guidelines.md#code-style)
- [X] [Logging](https://github.com/sergeyleschev/sergeyleschev/blob/main/sergeyleschev-fullstack-project-guidelines.md#logging)
- [X] [API](https://github.com/sergeyleschev/sergeyleschev/blob/main/sergeyleschev-fullstack-project-guidelines.md#api)

<div style="page-break-after: always;"></div>

## Licenses & certifications

- 🏆 LeetCode Global TOP 200 (Swift: [Certificate](https://leetcode.com/sergeyleschev/), Sources: [Swift](https://github.com/sergeyleschev/leetcode-swift)).
- 🏆 Golden Award Muad'Dib's Challenge (Swift: [Certificate](https://app.codility.com/cert/view/cert5YT6JA-Y9ZKFEFXEZWGTR3G/), Sources: [Swift](https://github.com/sergeyleschev/codility-swift)).
- 2022 Oct LeetCode Challenge ([2022-10-31](https://leetcode.com/sergeyleschev)).
- 2022 Sep LeetCode Challenge ([2022-09-30](https://leetcode.com/sergeyleschev)).
- 2022 Aug LeetCode Challenge ([2022-08-31](https://leetcode.com/sergeyleschev)).
- 2022 July LeetCode Challenge ([2022-07-31](https://leetcode.com/sergeyleschev)).
- 2022 June LeetCode Challenge ([2022-06-30](https://leetcode.com/sergeyleschev)).
- 2022 May LeetCode Challenge ([2022-05-31](https://leetcode.com/sergeyleschev)).
- 2022 Apr LeetCode Challenge ([2022-04-30](https://leetcode.com/sergeyleschev)).
- LeetCode Dynamic Programming ([2022-05-07](https://leetcode.com/sergeyleschev)).
- Graph Theory ([2022-04-30](https://leetcode.com/sergeyleschev)).
- SQL ([2022-04-26](https://leetcode.com/sergeyleschev)).
- Algorithm I ([2022-04-30](https://leetcode.com/sergeyleschev)), Algorithm II ([2022-05-21](https://leetcode.com/sergeyleschev)).
- Data Structure I ([2022-04-30](https://leetcode.com/sergeyleschev)), Data Structure II ([2022-05-21](https://leetcode.com/sergeyleschev)).
- Binary Search I ([2022-04-28](https://leetcode.com/sergeyleschev)), Binary Search II ([2022-05-18](https://leetcode.com/sergeyleschev)).
- Programming Skills I ([2022-04-28](https://leetcode.com/sergeyleschev)), Programming Skills II ([2022-05-18](https://leetcode.com/sergeyleschev)).
- LinkedIn Skill Asessment (Mobile): [Swift (Programming Language)](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Swift/report/), [Object-Oriented Programming (OOP)](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Object-Oriented%20Programming%20(OOP)/report/), [Objective-C](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Objective-C/report/), [C++](https://www.linkedin.com/in/sergeyleschev/detail/assessments/C++/report/), [Ionic](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Angular/report/), [JSON](https://www.linkedin.com/in/sergeyleschev/detail/assessments/JSON/report/), [XML](https://www.linkedin.com/in/sergeyleschev/detail/assessments/XML/report/), [Android](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Android/report/), [Kotlin](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Kotlin/report/), [Maven](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Maven/report/), [Java](https://www.linkedin.com/in/sergeyleschev/detail/assessments/Java/report/), [REST APIs](https://www.linkedin.com/in/sergeyleschev/detail/assessments/REST%20APIs/report/).
-  Health & Fitness iOS App / [Fitness Motivation](https://github.com/sergeyleschev/motivation) / AppStore (Sources: [SwiftUI](https://github.com/sergeyleschev/motivation)) @ S. Leschev.
-  Utility MacOS App / Calc-It / Core (Sources: [Swift](https://github.com/sergeyleschev/calc-it)) @ S. Leschev.

<div style="page-break-after: always;"></div>

## Latest Projects

### [ iOS] Live Stream & Video Chat is the best streaming and video chatting tool. (L6+)

Role: Senior iOS Developer, Team Lead. Development architecture and new features.

Tech Stack:

- Swift 5+.
- VIPER (Dependency Injection, Assembly, Services, Interactor, Presenter, State, Adapter) + MVVM (Combine, PromiseKit).
- Alomofire, Decodable, Combine.
- GCD/Operations.
- Agora Video SDK, Chat SDK, Beautification SDK. WebRTC. GRPC.
- Modular architecture (Frameworks, Development Pods).
- SwiftGen (Localization, Image, Colors).
- SwiftLint.
- Auth: Facebook, Google, Apple ID.
- Firebase, Crashlytics, Amplitude, AppsFlyer.
- Push-notifications (Firebase).
- UIKit, Autolayout, Core Animations, Skeleton, Lottie.
- Git (Flow, CodeReview), Figma.

<div style="page-break-after: always;"></div>

### [ iOS] Health & Fitness iOS App  (L6+)

Role: Senior iOS Developer, Team Lead. Development architecture and new features.

Tech Stack:

- Swift 5+.
- Clean Swift Architecture.
- Alamofire, ObjectMapper.
- GCD/Operations.
- AVFoundation, Streaming: HLS (Cloudflare/nginx).
- AirPlay [Composition (video+audio), Secondary Display].
- Realm.
- Modular architecture (Frameworks, Development Pods).
- SwiftGen (Localization, Image, Colors).
- SwiftLint.
- Auth: Facebook, Google, Apple ID, Fitbit.
- Amplitude, Crashlytics, AppsFlyer (+OneLink).
- Analytics: Facebook (SKAd + Conversions API).
- Push-notifications (OneSignal).
- UIKit, Autolayout, Core Animations, Lottie.
- Git (Flow, CodeReview), Zeplin, Figma, Sketch.

<div style="page-break-after: always;"></div>

### [ iOS] Health & Fitness iOS App (Motivations Coach, Pet Project) (L6+)

Role: iOS Developer.

Tech Stack:

- SwiftUI.
- Watch Extension (WatchOS).
- AppClip Extension.
- Widget (iOS 14).
- ObjectMapper.
- URLSession.
- Keychain.
- Lottie.
- Push Notifications.
- GCD/Operations.
- Git, Figma, Sketch.

Website: [motivations.coach](https://sergeyleschev.github.io/motivations.coach/)

Sources: [SwiftUI](https://github.com/sergeyleschev/Motivation)

<div style="page-break-after: always;"></div>

## Contacts

I have a clear focus on time-to-market and don't prioritize technical debt. And I took part in the Pre-Sale/RFX activity as a System Architect, assessment efforts for Mobile (iOS-Swift, Android-Kotlin), Frontend (React-TypeScript) and Backend (NodeJS-.NET-PHP-Kafka-SQL-NoSQL). And I also formed the work of Pre-Sale as a CTO from Opportunity to Proposal via knowledge transfer to Successful Delivery.

🛩️ #startups #management #cto #swift #typescript #database

📧 Email: [sergey.leschev@gmail.com](mailto:sergey.leschev@gmail.com)

👋 LinkedIn: [https://linkedin.com/in/sergeyleschev](https://www.linkedin.com/in/sergeyleschev/)

👋 Twitter: [https://twitter.com/sergeyleschev](https://twitter.com/sergeyleschev)

👋 Github: [https://github.com/sergeyleschev](https://github.com/sergeyleschev)

🌎 Website: [https://sergeyleschev.github.io](https://sergeyleschev.github.io)

🌎 DEV Community: [https://dev.to/sergeyleschev](https://dev.to/sergeyleschev)

🌎 Reddit: [https://reddit.com/user/sergeyleschev](https://reddit.com/user/sergeyleschev)

🌎 Quora: [https://quora.com/sergey-leschev](https://quora.com/sergey-leschev)

🌎 Medium: [https://medium.com/@sergeyleschev](https://medium.com/@sergeyleschev)

🖨️ PDF: [Download](https://sergeyleschev.github.io/sergeyleschev-design-patterns.pdf)

ALT: SIARHEI LIASHCHOU

<footer>
  <p style="font-size: 10px">
  <a href="https://sergeyleschev.github.io">leader</a>, <a href="https://sergeyleschev.github.io">knowledge</a>, <a href="https://sergeyleschev.github.io">qualifications</a>, <a href="https://sergeyleschev.github.io">education</a>, <a href="https://sergeyleschev.github.io">tips</a>, <a href="https://sergeyleschev.github.io">skills</a>, <a href="https://sergeyleschev.github.io">multitasking</a>, <a href="https://sergeyleschev.github.io">references</a>, <a href="https://sergeyleschev.github.io">success</a>, <a href="https://sergeyleschev.github.io">work</a>, <a href="https://sergeyleschev.github.io">job</a>, <a href="https://sergeyleschev.github.io">tie</a>, <a href="https://sergeyleschev.github.io">challenges</a>, <a href="https://sergeyleschev.github.io">abilities</a>, <a href="https://sergeyleschev.github.io">impress</a>, <a href="https://sergeyleschev.github.io">responsibility</a>, <a href="https://sergeyleschev.github.io">future</a>, <a href="https://sergeyleschev.github.io">weeknesses</a>, <a href="https://sergeyleschev.github.io">benefits</a>, <a href="https://sergeyleschev.github.io">results</a>, <a href="https://sergeyleschev.github.io">team player</a>, <a href="https://sergeyleschev.github.io">strengths</a>, <a href="https://sergeyleschev.github.io">interview</a>, <a href="https://sergeyleschev.github.io">degress</a>, <a href="https://sergeyleschev.github.io">examples</a>, <a href="https://sergeyleschev.github.io">strengths</a>, <a href="https://sergeyleschev.github.io">experienced</a>, <a href="https://sergeyleschev.github.io">problem solver</a>, <a href="https://sergeyleschev.github.io">candidate</a>, <a href="https://sergeyleschev.github.io">agency</a>, <a href="https://sergeyleschev.github.io">objective</a>, <a href="https://sergeyleschev.github.io">initiative</a>, <a href="https://sergeyleschev.github.io">team</a>, <a href="https://sergeyleschev.github.io">dreams</a>, <a href="https://sergeyleschev.github.io">conflict</a>, <a href="https://sergeyleschev.github.io">can-do</a>, <a href="https://sergeyleschev.github.io">training</a>, <a href="https://sergeyleschev.github.io">questions</a>, <a href="https://sergeyleschev.github.io">job</a>, <a href="https://sergeyleschev.github.io">work</a>, <a href="https://sergeyleschev.github.io">career</a>, <a href="https://sergeyleschev.github.io">created</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">swift</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">typescript</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">javascript</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">sql</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">nosql</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">postgresql</a>, <a href="https://sergeyleschev.github.io">oracle</a>, <a href="https://sergeyleschev.github.io">sql server</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">react</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">redux</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">swiftui</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">objective-c</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">devops</a>, <a href="https://sergeyleschev.github.io">aws</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">mongodb</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">pl/sql</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">angular</a>, <a href="https://sergeyleschev.github.io">project management</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">nodejs</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">nextjs</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">nestjs</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">api</a>, <a href="https://sergeyleschev.github.io">agile</a>, <a href="https://sergeyleschev.github.io">amplitude</a>, <a href="https://sergeyleschev.github.io">analytics</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">appclip</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">appstore</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">bash</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">css</a>, <a href="https://sergeyleschev.github.io">jira</a>, <a href="https://sergeyleschev.github.io">confluence</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">git</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">graphql</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">html</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">html5</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">mvp</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">mvvm</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">nginx</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">ssh</a>, <a href="https://sergeyleschev.github.io">prime react</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">rest</a>, <a href="https://sergeyleschev.github.io">teamcity</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-fullstack-roadmap.html">typeorm</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">uikit</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">uml</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">viper</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">widgets</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">xcode</a>, <a href="https://sergeyleschev.github.io">json</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">linux</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">docker</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-system-architect-roadmap.html">mobx</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">tvOS</a>, <a href="https://sergeyleschev.github.io/sergeyleschev-ios-roadmap.html">watchOS</a>
  </p>
</footer>
