//
//  LocalizerBuilder.swift
//  Localization
//
//  Created by octree on 2022/6/1.
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

import Foundation

public protocol LocalizerGroup {
    associatedtype MapArg
    func localizer<Z>(_ transform: @escaping (MapArg) -> Z) -> Localizer<Z>
}

extension Localizer: LocalizerGroup {
    public typealias MapArg = Output
    public func localizer<Z>(_ transform: @escaping (Output) -> Z) -> Localizer<Z> {
        map(transform)
    }
}

public struct LocalizerTuple2<A0, A1>: LocalizerGroup {
    public typealias MapArg = (A0, A1)
    var value: (Localizer<A0>, Localizer<A1>)
    public func localizer<Z>(_ transform: @escaping (MapArg) -> Z) -> Localizer<Z> {
        value.0.combine(value.1).map(transform)
    }
}

public struct LocalizerTuple3<A0, A1, A2>: LocalizerGroup {
    public typealias MapArg = (A0, A1, A2)
    var value: (Localizer<A0>, Localizer<A1>, Localizer<A2>)
    public func localizer<Z>(_ transform: @escaping (MapArg) -> Z) -> Localizer<Z> {
        value.0.combine(value.1, value.2).map(transform)
    }
}

@resultBuilder
public enum LocalizerBuilder {
    public static func buildExpression(_ expression: String) -> Localizer<String> {
        Localizer.pure(expression)
    }

    public static func buildBlock<A>(_ c1: Localizer<A>) -> Localizer<A> {
        c1
    }

    public static func buildBlock<A0, A1>(_ c1: Localizer<A0>, _ c2: Localizer<A1>) -> LocalizerTuple2<A0, A1> {
        LocalizerTuple2(value: (c1, c2))
    }

    public static func buildBlock<A0, A1, A2>(_ c1: Localizer<A0>, _ c2: Localizer<A1>, _ c3: Localizer<A2>) -> LocalizerTuple3<A0, A1, A2> {
        LocalizerTuple3(value: (c1, c2, c3))
    }
}

public extension Localizer {
    init<G: LocalizerGroup>(@LocalizerBuilder group: () -> G, transform: @escaping (G.MapArg) -> Output) {
        let localizer = group().localizer(transform)
        thunk = { localizer() }
    }
}
