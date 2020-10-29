//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UICreator
import UIKit

@frozen
public struct UMAlert: UICView {
    private let titles: [UICAnyView]
    private let subtitles: [UICAnyView]
    private let descriptions: [UICAnyView]
    private let buttons: [UICAnyView]

    public init() {
        self.titles = []
        self.subtitles = []
        self.descriptions = []
        self.buttons = []
    }

    private init(_ original: UMAlert, editable: Editable) {
        self.titles = editable.titles
        self.subtitles = editable.subtitles
        self.descriptions = editable.descriptions
        self.buttons = editable.buttons
    }

    public var body: ViewCreator {
        UICZStack {
            UICSpacer()
                .backgroundColor(.black)
                .alpha(0.35)
                .insets()

            UICCenter {
                UICRounder(radius: 7.5) {
                    UICZStack {
                        UICBlur(.extraLight)

                        UICVStack(spacing: 15) {
                            self.content {
                                UICVStack(spacing: 7.5) {
                                    if !self.titles.isEmpty {
                                        UICVStack(spacing: 3.75) {
                                            UICForEach(self.titles) { $0 }
                                        }
                                    }

                                    if !self.subtitles.isEmpty {
                                        UICVStack(spacing: 3.75) {
                                            UICForEach(self.subtitles) { $0 }
                                        }
                                    }

                                    if !self.descriptions.isEmpty {
                                        UICVStack(spacing: 3.75) {
                                            UICForEach(self.descriptions) { $0 }
                                        }
                                    }
                                }
                            }

                            if !self.buttons.isEmpty {
                                UICVStack(spacing: 7.5) {
                                    UICForEach(self.buttons) { $0 }
                                }
                            }
                        }
                        .padding(15, /*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .width(equalTo: 300)
                    }
                }
            }
            .insets()
        }
    }
}

private extension UMAlert {
    private func content(_ content: @escaping () -> ViewCreator) -> UICAnyView {
        guard [self.titles, self.descriptions,  self.subtitles].contains(where: { !$0.isEmpty }) else {
            return UICAnyView(content())
        }

        return UICAnyView(
            UICVScroll {
                content()
            }
        )
    }
}

extension UMAlert {

    @usableFromInline
    class Editable {
        @usableFromInline
        var titles: [UICAnyView]

        @usableFromInline
        var subtitles: [UICAnyView]

        @usableFromInline
        var descriptions: [UICAnyView]
        
        @usableFromInline
        var buttons: [UICAnyView]

        init(_ original: UMAlert) {
            self.titles = original.titles
            self.subtitles = original.subtitles
            self.descriptions = original.descriptions
            self.buttons = original.buttons
        }
    }

    @inline(__always) @usableFromInline
    func edit(_ edit: (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

public extension UMAlert {

    @inlinable
    func addButton(_ content: @escaping () -> ViewCreator) -> Self {
        self.edit {
            $0.buttons = $0.buttons + [UICAnyView(content())]
        }
    }

    @inlinable
    func addTitle(_ content: @escaping () -> ViewCreator) -> Self {
        self.edit {
            $0.titles = $0.titles + [UICAnyView(content())]
        }
    }

    @inlinable
    func addSubtitle(_ content: @escaping () -> ViewCreator) -> Self {
        self.edit {
            $0.subtitles = $0.subtitles + [UICAnyView(content())]
        }
    }

    func addDescription(_ content: @escaping () -> ViewCreator) -> Self {
        self.edit {
            $0.descriptions = $0.descriptions + [UICAnyView(content())]
        }
    }
}

public extension UMAlert {
    @inlinable
    func title(_ title: String, color: UIColor = .black, font: UIFont = .title3) -> Self {
        self.addTitle {
            UICLabel(title)
                .textColor(color)
                .font(font)
                .textAlignment(.center)
                .horizontal(hugging: .required, compression: .required)
        }
    }

    @inlinable
    func subtitle(_ subtitle: String, color: UIColor = .gray, font: UIFont = .callout) -> Self {
        self.addSubtitle {
            UICLabel(subtitle)
                .textColor(color)
                .font(font)
                .textAlignment(.center)
                .horizontal(hugging: .required, compression: .required)
        }
    }

    @inlinable
    func description(_ description: String, color: UIColor = .black, font: UIFont = .callout) -> Self {
        self.addDescription {
            UICLabel(description)
                .textColor(color)
                .font(font)
                .textAlignment(.center)
                .horizontal(hugging: .required, compression: .required)
        }
    }
}

public extension UMAlert {
    @inlinable
    func cancelButton(title: String, tintColor: UIColor = .blue, onTap: @escaping () -> Void) -> Self {
        self.addButton {
            UICButton {
                UICRounder(radius: 5) {
                    UICLabel(title)
                        .textColor(.white)
                        .font(.body(weight: .bold))
                        .textAlignment(.center)
                        .backgroundColor(tintColor)
                        .padding(15, .all)
                        .horizontal(hugging: .required, compression: .required)
                }
            }
            .onTap { _ in onTap() }
        }
    }

    @inlinable
    func destructiveButton(title: String, onTap: @escaping () -> Void) -> Self {
        self.addButton {
            UICButton {
                UICRounder(radius: 5) {
                    UICZStack {
                        UICBlur(.extraLight)

                        UICLabel(title)
                            .textColor(.red)
                            .font(.body(weight: .bold))
                            .textAlignment(.center)
                            .padding(15, .all)
                            .insets()
                            .horizontal(hugging: .required, compression: .required)
                    }
                }
            }
            .onTap { _ in onTap() }
        }
    }

    @inlinable
    func otherButton(title: String, onTap: @escaping () -> Void) -> Self {
        self.addButton {
            UICButton {
                UICRounder(radius: 5) {
                    UICZStack {
                        UICBlur(.extraLight)

                        UICLabel(title)
                            .textColor(.black)
                            .font(.body(weight: .bold))
                            .textAlignment(.center)
                            .padding(15, .all)
                            .horizontal(hugging: .required, compression: .required)
                    }
                }
            }
            .onTap { _ in onTap() }
        }
    }
}
