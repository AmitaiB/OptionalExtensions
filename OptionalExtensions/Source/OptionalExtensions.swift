//
//  OptionalExtensions.swift
//  OptionalExtensions
//
//  Created by Rui Peres on 30/12/2015.
//  Copyright © 2015 Rui Peres. All rights reserved.
//

public extension Optional {

    /** ```
    let number: Int? = 3
    let biggerThan2 = number.filter { $0 > 2 } // .Some(3)
    let biggerThan3 = number.filter { $0 > 3 } // .None */
    func filter(_ predicate: (Wrapped) -> Bool) -> Optional {
        return map(predicate) == .some(true) ? self : .none
    }

    /** ```
    let number: Int? = 3
    number.mapNil { 2 } // .Some(3)
     
    let nilledNumber: Int? = nil
    nilledNumber.mapNil { 2 } // .Some(2) */
    func mapNil(_ predicate: () -> Wrapped) -> Optional {
        return self ?? .some(predicate())
    }

    /** ```
     let number: Int? = 3
     number.flatMapNil { .Some(2) } // .Some(3)
     
     let nilledNumber: Int? = nil
     nilledNumber.flatMapNil { .Some(2) } // .Some(2) */
    @available(iOS 9.3, *)
    func compactMapNil(_ predicate: () -> Optional) -> Optional {
        return self ?? predicate()
    }
    
    /// Meet the old boss, same as the new boss.
    @available(iOS, deprecated: 9.0)
    func flatMapNil(_ predicate: () -> Optional) -> Optional {
        return self ?? predicate()
    }

    /**
     Similar to `[T]`'s `forEach`.
     ```
    let number: Int? = 3
    number.then { print($0) } // prints "3"
    
    let nilledNumber: Int? = nil
    nilledNumber.then { print($0) } // print won't be called */
    func then(_ f: (Wrapped) -> Void) {
        if let wrapped = self { f(wrapped) }
    }

    /**
    Similar to Haskell's `maybe`.
    
    ```
    let number: Int? = 3
    number.maybe(100) { $0 + 1 } // 4
    
    let nilledNumber: Int? = nil
    nilledNumber.maybe(100) { $0 + 1 } // 100 */
    func maybe<U>(_ defaultValue: U, f: (Wrapped) -> U) -> U {
        return map(f) ?? defaultValue
    }

    /**
    Injects a side effect in the `.Some` branch.
    
    ```
    let number: Int? = 3
    let sameNumber = number.onSome { print($0) } // prints "3" & returns .Some(3)
    
    let nilledNumber: Int? = nil
    let sameNilledNumber = nilledNumber.onSome { print($0) } // .None */
    func onSome(_ f: (Wrapped) -> Void) -> Optional {
        then(f)
        return self
    }

    /**
    Injects a side effect in the `.None` branch.
    
    ```
    let number: Int? = 3
    let sameNumber = number.onNone { print("Hello World") } // .Some(3)
    
    let nilledNumber: Int? = nil
    let sameNilledNumber = nilledNumber.onNone { print("Hello World") } // prints "Hello World" & returns .None */
    func onNone(_ f: () -> Void) -> Optional {
        if isNone { f() }
        return self
    }

    /**
    Plain English sugar for `!= nil`.
    ```
    let number: Int? = 3
    let isSome = number.isSome // true
    
    let nilledNumber: Int? = nil
    let isSome = nilledNumber.isSome // false */
    var isSome: Bool {
        return self != nil
    }

    /**
    Plain English sugar for `== nil`.
    ```
    let number: Int? = 3
    let isSome = number.isNone // false
    
    let nilledNumber: Int? = nil
    let isSome = nilledNumber.isNone // true */
    var isNone: Bool {
        return !isSome
    }
}
