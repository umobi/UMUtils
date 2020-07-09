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

import SwiftUI

#if os(iOS) || os(tvOS)
public struct UMAlert: View {

    private let titles: [AnyView]
    private let subtitles: [AnyView]
    private let descriptions: [AnyView]
    private let buttons: [AnyView]

    @State private var contentHeight: CGFloat = 0

    public init() {
        self.titles = []
        self.subtitles = []
        self.descriptions = []
        self.buttons = []
    }

    private init(_ original: UMAlert, editable: Editable) {
        self._contentHeight = original._contentHeight
        self.titles = editable.titles
        self.subtitles = editable.subtitles
        self.descriptions = editable.descriptions
        self.buttons = editable.buttons
    }

    public var body: some View {
        ZStack {
            Color.black
                .opacity(0.35)
                .edgesIgnoringSafeArea(.all)

            ZStack {
                UMBlur(style: .extraLight)

                VStack(spacing: 15) {

                    self.content {
                        VStack(spacing: 7.5) {
                            if !self.titles.isEmpty {
                                VStack(spacing: 3.75) {
                                    ForEach(Array(self.titles.enumerated()), id: \.offset) {
                                        $0.1
                                    }
                                }.frame(maxWidth: .infinity)
                            }

                            if !self.subtitles.isEmpty {
                                VStack(spacing: 3.75) {
                                    ForEach(Array(self.subtitles.enumerated()), id: \.offset) {
                                        $0.1
                                    }
                                }.frame(maxWidth: .infinity)
                            }

                            if !self.descriptions.isEmpty {
                                VStack(spacing: 3.75) {
                                    ForEach(Array(self.descriptions.enumerated()), id: \.offset) {
                                        $0.1
                                    }
                                }.frame(maxWidth: .infinity)
                            }
                        }
                    }

                    if !self.buttons.isEmpty {
                        VStack(spacing: 7.5) {
                            ForEach(Array(self.buttons.enumerated()), id: \.offset) {
                                $0.1.frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
                .frame(width: 300)
                .layoutPriority(2)
            }
            .cornerRadius(7.5)
        }
    }
}

private extension UMAlert {
    private func content<Content: View>(_ content: @escaping () -> Content) -> AnyView {
        guard [self.titles, self.descriptions,  self.subtitles].contains(where: { !$0.isEmpty }) else {
            return AnyView(content())
        }

        return AnyView(
            ScrollView {
                content()
                    .background(GeometryReader { geometry -> AnyView in
                        OperationQueue.main.addOperation {
                            self.contentHeight = geometry.size.height
                        }

                        return AnyView(Rectangle().fill(Color.clear))
                    })
            }
            .frame(maxHeight: self.contentHeight)
        )
    }
}

private extension UMAlert {

    class Editable {
        var titles: [AnyView]
        var subtitles: [AnyView]
        var descriptions: [AnyView]
        var buttons: [AnyView]

        init(_ original: UMAlert) {
            self.titles = original.titles
            self.subtitles = original.subtitles
            self.descriptions = original.descriptions
            self.buttons = original.buttons
        }
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

public extension UMAlert {

    func addButton<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.buttons = $0.buttons + [AnyView(content())]
        }
    }

    func addTitle<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.titles = $0.titles + [AnyView(content())]
        }
    }

    func addSubtitle<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.subtitles = $0.subtitles + [AnyView(content())]
        }
    }

    func addDescription<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.descriptions = $0.descriptions + [AnyView(content())]
        }
    }
}

public extension UMAlert {
    func title<Title>(_ title: Title, color: Color = .black, font: Font = .title) -> Self where Title: StringProtocol {
        self.addTitle {
            Text(title)
                .foregroundColor(color)
                .font(font)
                .multilineTextAlignment(.center)
        }
    }

    func subtitle<Subtitle>(_ subtitle: Subtitle, color: Color = .gray, font: Font = .callout) -> Self where Subtitle: StringProtocol {
        self.addSubtitle {
            Text(subtitle)
                .foregroundColor(color)
                .font(font)
                .multilineTextAlignment(.center)
        }
    }

    func description<Description>(_ description: Description, color: Color = .black, font: Font = .callout) -> Self where Description: StringProtocol {
            self.addDescription {
                Text(description)
                    .foregroundColor(color)
                    .font(font)
                    .multilineTextAlignment(.center)
            }
    }
}

public extension UMAlert {
    func cancelButton<Title>(title: Title, tintColor: Color = .blue, onTap: @escaping () -> Void) -> Self where Title: StringProtocol {
        self.addButton {
            Button(action: onTap) {
                Text(title)
                    .foregroundColor(Color.white)
                    .font(.body)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.all, 15)
                    .frame(maxWidth: .infinity)
                    .background(tintColor)
                    .cornerRadius(5)
            }
        }
    }

    func destructiveButton<Title>(title: Title, onTap: @escaping () -> Void) -> Self where Title: StringProtocol {
        self.addButton {
            Button(action: onTap) {
                Text(title)
                    .foregroundColor(Color.red)
                    .font(.body)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.all, 15)
                    .frame(maxWidth: .infinity)
                    .background(UMBlur(style: .extraLight))
                    .cornerRadius(5)
            }
        }
    }

    func otherButton<Title>(title: Title, onTap: @escaping () -> Void) -> Self where Title: StringProtocol {
        self.addButton {
            Button(action: onTap) {
                Text(title)
                    .foregroundColor(Color.black)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.all, 15)
                    .frame(maxWidth: .infinity)
                    .background(UMBlur(style: .extraLight))
                    .cornerRadius(5)
            }
        }
    }
}
#endif
