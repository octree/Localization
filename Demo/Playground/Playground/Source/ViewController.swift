//
//  ViewController.swift
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

import Localization
import UIKit

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet var languageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.l10n.text.bind(.pure("Hello"))
        languageButton.l10n.title(for: .normal).bind(key: "Language")
        label.l10n.text.bind(.pure("Hello"))
        let localizer = Localizer.pure("Part 1")
            .combine(.pure("Part 2"))
            .map { $0 + " " + $1 }
            .map { NSAttributedString(string: $0, attributes: [.foregroundColor: UIColor.systemPink]) }
        label2.l10n.attributedText.bind(localizer)
    }

    @IBAction func selectLanguage(_ sender: Any) {
        let avc = UIAlertController(title: "Language".localized(), message: nil, preferredStyle: .actionSheet)
        let languages = Language.availableLanguages()
        avc.addAction(UIAlertAction(title: "System", style: .default, handler: { _ in
            LocalizationPreference.current = .followSystem
        }))

        languages.forEach { lang in
            let title = Locale(identifier: lang.rawValue).localizedString(forLanguageCode: lang.rawValue)
            avc.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                LocalizationPreference.current = .specified(lang)
            }))
        }

        present(avc, animated: true)
    }
}
