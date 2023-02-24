//
//  LocalizationPreference.swift
//  UIKitLab
//
//  Created by Octree on 2022/5/28.
//

import Combine
import Foundation

/// In app language preference
public enum LocalizationPreference {
    /// Dependent on the system preferences
    case followSystem
    /// The in app language preference
    case specified(Language)
}

public extension LocalizationPreference {
    /// The in app preferred language
    private static var specifiedLanguage: Language? = UserDefaults.standard.string(forKey: "SpecifiedCurrentLanguageKey")
        .map { Language(rawValue: $0) }
    {
        didSet {
            UserDefaults.standard.set(specifiedLanguage?.rawValue, forKey: "SpecifiedCurrentLanguageKey")
            UserDefaults.standard.synchronize()
        }
    }

    private static var languageChangeSubject: PassthroughSubject<Void, Never> = .init()
    /// A publisher that emits event while changing the language preference.
    static var languageChangePublisher: AnyPublisher<Void, Never> { languageChangeSubject.eraseToAnyPublisher() }

    /// Current language preference
    static var current: Self {
        get {
            specifiedLanguage.map { .specified($0) } ?? .followSystem
        }
        set {
            defer { languageChangeSubject.send() }
            guard case let .specified(lang) = newValue else {
                specifiedLanguage = nil
                return
            }
            specifiedLanguage = lang
        }
    }
}
