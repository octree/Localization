//
//  LocalizerBinder.swift
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

import Foundation

/// The binder calls  the setter after the language preference was changed
/// The output of the localizer will passed as the argument
public struct LocalizerBinder<Base: AnyObject, Value> {
    unowned let host: ReactiveLocalization<Base>
    var identifier: AnyHashable
    var setter: (Value) -> Void

    /// Binding with a specified localizer
    /// - Parameter localizer: A localizer to bind
    public func bind(_ localizer: Localizer<Value>) {
        setter(localizer())
        host.performAfterLanguageChange(identifier: identifier) {
            setter(localizer())
        }
    }
}

public extension LocalizerBinder where Value == String {
    /// Binding with a specified key from a table that Xcode generates.
    /// - Parameters:
    ///   - key: The key for a string in the specified table.
    ///   - tableName: The name of the table containing the key-value pairs. Also, the suffix for the strings file (a file with the.strings extension) to store the localized string. This defaults to the table in Localizable.strings when tableName is nil or an empty string.
    ///   - bundle: The bundle containing the table’s strings file. The main bundle is used if one isn’t specified.
    func bind(key: String, tableName: String? = nil, bundle: Bundle? = nil) {
        bind(.pure(key, tableName: tableName, bundle: bundle))
    }
}
