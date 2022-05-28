//
//  Localizer.swift
//  Localization
//
//  Created by octree on 2022/5/28.
//
//  Copyright (c) 2022 Octree <fouljz@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Combine
import Foundation

/// Declares that a type can produce a localized artifacts
///
/// Essentially it seems like a `Reader Monad` without environment.
public struct Localizer<Output> {
    var thunk: () -> Output
    init(_ thunk: @escaping () -> Output) {
        self.thunk = thunk
    }

    public func callAsFunction() -> Output {
        thunk()
    }
}

// MARK: - Pure
public extension Localizer where Output == String {
    /// A ``Localizer`` that produces a localized string from a table that Xcode generates.
    /// - Parameters:
    ///   - key: The key for a string in the specified table.
    ///   - tableName: The name of the table containing the key-value pairs. Also, the suffix for the strings file (a file with the.strings extension) to store the localized string. This defaults to the table in Localizable.strings when tableName is nil or an empty string.
    ///   - bundle: The bundle containing the table’s strings file. The main bundle is used if one isn’t specified.
    /// - Returns: A ``Localizer``
    static func pure(_ key: String, tableName: String? = nil, bundle: Bundle? = nil) -> Self {
        Localizer {
            key.localized(tableName: tableName, bundle: bundle ?? .main)
        }
    }
}

// MARK: - Functor
public extension Localizer {
    /// Return a localizer producing the result of mapping the given closure over the localizer's output.
    /// - Parameter transform: A mapping closure. transform accepts output of this localizer as its parameter and returns a transformed value of the same or of a different type.
    /// - Returns: A localizer producing a transformed output
    func map<U>(_ transform: @escaping (Output) -> U) -> Localizer<U> {
        Localizer<U> {
            transform(self())
        }
    }
}

// MARK: - Monad
public extension Localizer {
    /// Transforms the output from a upstream localizer into a new localizer
    /// - Parameter transform: A closure that takes the output as a parameter and returns a localizer that produces output of that type
    /// - Returns: A localizer that transforms output from an upstream localizer into a localizer of that output’s type.
    func flatMap<U>(_ transform: @escaping (Output) -> Localizer<U>) -> Localizer<U> {
        Localizer<U> {
            transform(self())()
        }
    }
}

// MARK: - Combine
public extension Localizer {
    /// Combine with an additional localizer and produces a tuple upon output from either localizer
    /// - Parameter other: Another localizer to combine with this one.
    /// - Returns: A localizer
    func combine<T>(_ other: Localizer<T>) -> Localizer<(Output, T)> {
        Localizer<(Output, T)> {
            (self(), other())
        }
    }

    /// Combine with two additional localizer and produces a tuple upon output from any of the localizers
    /// - Parameters:
    ///   - localize1: A second localizer to combine with the first localizer
    ///   - localize2: A third localizer to combine with the first localizer
    /// - Returns: A localizer
    func combine<T, U>(_ localize1: Localizer<T>, _ localize2: Localizer<U>) -> Localizer<(Output, T, U)> {
        Localizer<(Output, T, U)> {
            (self(), localize1(), localize2())
        }
    }
}

// MARK: - Combine List
public extension Localizer {
    /// Combine a list of localizers and produces a list of output from any of the localizers
    /// - Parameter list: A list of localizers to combine
    /// - Returns: A localizer
    static func combine(_ list: [Localizer<Output>]) -> Localizer<[Output]> {
        Localizer<[Output]> {
            list.map { $0() }
        }
    }
}
