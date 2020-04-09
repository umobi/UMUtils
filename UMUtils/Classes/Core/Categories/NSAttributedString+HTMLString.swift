//
//  NSAttributedString+HTMLString.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import UIKit

enum HTMLStringError: Error {
    case invalidData
    case underlying(Error)
}

public extension NSAttributedString {
    convenience init(
        htmlString: String,
        fontFamily: String = "-apple-system",
        fontSize: CGFloat = UIFont.systemFontSize
    ) throws {
        let styleTagString = NSAttributedString.styleForFont(family: fontFamily, size: fontSize)
        let htmlString = styleTagString + htmlString
        guard let data = htmlString.data(using: .utf8) else { throw HTMLStringError.invalidData }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            try self.init(data: data, options: options, documentAttributes: nil)
        } catch let error {
            throw HTMLStringError.underlying(error)
        }
    }

    private class func styleForFont(family: String, size: CGFloat) -> String {
        return "<style>body{font-family: '\(family)';font-size: \(size)px;}</style>"
    }
}

public class AttributedStringCache {
    var cache: OrderedArray<Item> = .init(.orderedAscending)

    public static var shared: AttributedStringCache = {
        return .init()
    }()

    var deleteQueue: DispatchQueue? = nil

    public func append(_ string: String, attributed: NSAttributedString) {
        self.cache.append(.init(string, attributed, Date().addingTimeInterval(15 * 60)))
        self.invalidate()
    }

    public subscript(_ string: String) -> NSAttributedString? {
        guard let cached = self.cache.enumerated().first(where: { $0.element.string == string }) else {
            return nil
        }

        if cached.element.date.compare(.init()) == .orderedAscending {
            self.cache.remove(at: cached.offset)
            self.invalidate()
            return nil
        }

        return cached.element.attributed
    }

    func invalidate() {
        guard self.deleteQueue == nil, let first = self.cache.first else {
            return
        }

        self.deleteQueue = DispatchQueue.global(qos: .background)
        self.deleteQueue?.asyncAfter(deadline: .now() + first.date.timeIntervalSinceNow) { [weak self] in
            guard let self = self else {
                return
            }

            self.deleteQueue = nil
            if self.cache[0] == first {
                self.cache.remove(at: 0)
            }

            self.invalidate()
        }
    }
}

extension AttributedStringCache {
    class Item: Comparable {
        static func < (lhs: AttributedStringCache.Item, rhs: AttributedStringCache.Item) -> Bool {
            lhs.date.compare(rhs.date) == .orderedAscending
        }

        static func == (lhs: AttributedStringCache.Item, rhs: AttributedStringCache.Item) -> Bool {
            lhs.date.compare(rhs.date) == .orderedSame
        }

        static func > (lhs: AttributedStringCache.Item, rhs: AttributedStringCache.Item) -> Bool {
            lhs.date.compare(rhs.date) == .orderedDescending
        }

        let string: String
        let attributed: NSAttributedString
        let date: Date

        init(_ string: String,_ attributed: NSAttributedString,_ date: Date) {
            self.string = string
            self.attributed = attributed
            self.date = date
        }
    }
}

struct HTMLText {
    let attributed: NSAttributedString

    init(_ string: String, font: UIFont? = nil) {
        if let attributed = AttributedStringCache.shared[string] {
            guard let font = font else {
                self.attributed = attributed
                return
            }

            let mutable = NSMutableAttributedString(attributedString: attributed)
            mutable.addAttribute(.font, value: font, range: attributed.string.nsrange)
            self.attributed = mutable
            return
        }

        guard let html = try? NSAttributedString(htmlString: string) else {
            if let font = font {
                let attributed = NSAttributedString(
                    string: string,
                    attributes: [.font: font]
                )

                AttributedStringCache.shared.append(string, attributed: attributed)
                self.attributed = attributed
                return
            }

            let attributed = NSAttributedString(string: string)
            AttributedStringCache.shared.append(string, attributed: attributed)
            self.attributed = attributed
            return
        }

        AttributedStringCache.shared.append(string, attributed: html)
        self.attributed = html
    }
}

extension HTMLText {
    struct Item {
        let string: String
        let attributed: NSAttributedString
    }
}

public extension String {
    func asHTMLText(font: UIFont? = nil) -> NSAttributedString {
        HTMLText(self, font: font).attributed
    }
}

public extension String {
    func nsrange(of string: String) -> NSRange {
        (self as NSString).range(of: string)
    }

    var nsrange: NSRange {
        return self.nsrange(of: self)
    }
}

