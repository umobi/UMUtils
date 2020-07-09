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

    private func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    public func addButton<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.buttons = $0.buttons + [AnyView(content())]
        }
    }

    public func addTitle<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.titles = $0.titles + [AnyView(content())]
        }
    }

    public func addSubtitle<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.subtitles = $0.subtitles + [AnyView(content())]
        }
    }

    public func addDescription<Content: View>(_ content: @escaping () -> Content) -> Self {
        self.edit {
            $0.descriptions = $0.descriptions + [AnyView(content())]
        }
    }

    private class Editable {
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

    public var body: some View {
        ZStack {
            Color.black
                .opacity(0.35)
                .edgesIgnoringSafeArea(.all)

            ZStack {
                UMBlur(style: .extraLight)

                VStack(spacing: 15) {

                    self.content {
                        VStack {
                            if !self.titles.isEmpty {
                                VStack {
                                    ForEach(self.titles.enumerated().reversed(), id: \.offset) {
                                        $0.1
                                    }
                                }.frame(maxWidth: .infinity)
                            }

                            if !self.subtitles.isEmpty {
                                VStack {
                                    ForEach(self.subtitles.enumerated().reversed(), id: \.offset) {
                                        $0.1
                                    }
                                }.frame(maxWidth: .infinity)
                            }

                            if !self.descriptions.isEmpty {
                                VStack {
                                    ForEach(self.descriptions.enumerated().reversed(), id: \.offset) {
                                        $0.1
                                    }
                                }.frame(maxWidth: .infinity)
                            }
                        }
                    }

                    if !self.buttons.isEmpty {
                        VStack {
                            ForEach(self.buttons.enumerated().reversed(), id: \.offset) {
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
