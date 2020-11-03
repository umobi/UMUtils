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
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS) || os(tvOS) || os(macOS)
public struct UMAlert<Title, Subtitle, Description, Button>: View where Title: View, Subtitle: View, Description: View, Button: View {

    private let titles: () -> Title
    private let subtitles: () -> Subtitle
    private let descriptions: () -> Description
    private let buttons: () -> Button

    @State private var contentHeight: CGFloat = 0

    init(
        @ViewBuilder titles: @escaping () -> Title,
        @ViewBuilder subtitles: @escaping () -> Subtitle,
        @ViewBuilder descriptions: @escaping () -> Description,
        @ViewBuilder buttons: @escaping () -> Button) {

        self.titles = titles
        self.subtitles = subtitles
        self.descriptions = descriptions
        self.buttons = buttons
    }

    public var body: some View {
        ZStack {
            Color.black
                .opacity(0.35)
                .edgesIgnoringSafeArea(.all)

            ZStack {
                Color.white
                    .opacity(0.75)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 20)

                VStack(spacing: 15) {
                    self.content {
                        VStack(spacing: 7.5) {
                            if !(Title.self is Never.Type) {
                                VStack(spacing: 3.75) {
                                    titles()
                                }
                                .frame(maxWidth: .infinity)
                            }

                            if !(Subtitle.self is Never.Type) {
                                VStack(spacing: 3.75) {
                                    subtitles()
                                }
                                .frame(maxWidth: .infinity)
                            }

                            if !(Description.self is Never.Type) {
                                VStack(spacing: 3.75) {
                                    descriptions()
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }

                    if !(Button.self is Never.Type) {
                        VStack(spacing: 7.5) {
                            buttons()
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
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

extension UMAlert where Title == Never, Subtitle == Never, Description == Never, Button == Never {
    public init() {
        self.titles = { fatalError() }
        self.subtitles = { fatalError() }
        self.descriptions = { fatalError() }
        self.buttons = { fatalError() }
    }
}

public extension UMAlert {
    func title<Content>(@ViewBuilder content: @escaping () -> Content) -> UMAlert<TupleView<(Title?, Content)>, Subtitle, Description, Button> where Content: View {
        .init(titles: {
            if !(Title.self is Never.Type) {
                titles()
            }

            content()
        }, subtitles: subtitles, descriptions: descriptions, buttons: buttons)
    }
}

public extension UMAlert {
    func subtitle<Content>(@ViewBuilder content: @escaping () -> Content) -> UMAlert<Title, TupleView<(Subtitle?, Content)>, Description, Button> where Content: View {
        .init(titles: titles, subtitles: {
            if !(Subtitle.self is Never.Type) {
                subtitles()
            }

            content()
        }, descriptions: descriptions, buttons: buttons)
    }
}

public extension UMAlert {
    func description<Content>(@ViewBuilder content: @escaping () -> Content) -> UMAlert<Title, Subtitle, TupleView<(Description?, Content)>, Button> where Content: View {
        .init(titles: titles, subtitles: subtitles, descriptions: {
            if !(Description.self is Never.Type) {
                descriptions()
            }

            content()
        }, buttons: buttons)
    }
}

public extension UMAlert {
    func button<Content>(@ViewBuilder content: @escaping () -> Content) -> UMAlert<Title, Subtitle, Description, TupleView<(Button?, Content)>> where Content: View {
        .init(titles: titles, subtitles: subtitles, descriptions: descriptions, buttons: {
            if !(Button.self is Never.Type) {
                buttons()
            }

            content()
        })
    }
}

private extension UMAlert {
    private func content<Content: View>(_ content: @escaping () -> Content) -> AnyView {
        guard [Title.self is Never.Type, Description.self is Never.Type, Subtitle.self is Never.Type].contains(where: { !$0 }) else {
            return AnyView(content())
        }

        return AnyView(ScrollView {
            content()
                .background(GeometryReader { geometry -> AnyView in
                    OperationQueue.main.addOperation {
                        self.contentHeight = geometry.size.height
                    }

                    return AnyView(Rectangle().fill(Color.clear))
                })
        }
        .frame(maxHeight: self.contentHeight))
    }
}

public extension UMAlert {
    func title<TitleString>(
        _ title: TitleString,
        color: Color = .black,
        font: Font = .title
    ) -> UMAlert<TupleView<(Title?, AnyView)>, Subtitle, Description, Button> where TitleString: StringProtocol {

        self.title {
            AnyView(
                Text(title)
                    .foregroundColor(color)
                    .font(font)
                    .multilineTextAlignment(.center)
            )
        }
    }

    func subtitle<SubtitleString>(
        _ subtitle: SubtitleString,
        color: Color = .gray,
        font: Font = .callout
    ) -> UMAlert<Title, TupleView<(Subtitle?, AnyView)>, Description, Button> where SubtitleString: StringProtocol {

        self.subtitle {
            AnyView(
                Text(subtitle)
                    .foregroundColor(color)
                    .font(font)
                    .multilineTextAlignment(.center)
            )
        }
    }

    func description<DescriptionString>(
        _ description: DescriptionString,
        color: Color = .black,
        font: Font = .callout
    ) -> UMAlert<Title, Subtitle, TupleView<(Description?, AnyView)>, Button> where DescriptionString: StringProtocol {

            self.description {
                AnyView(
                    Text(description)
                        .foregroundColor(color)
                        .font(font)
                        .multilineTextAlignment(.center)
                )
            }
    }
}

public extension UMAlert {
    func cancelButton<String>(
        title: String,
        tintColor: Color = .blue,
        onTap: @escaping () -> Void
    ) -> UMAlert<Title, Subtitle, Description, TupleView<(Button?, AnyView)>> where String: StringProtocol {

        self.button {
            AnyView(
                SwiftUI.Button(action: onTap) {
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
            )
        }
    }

    func destructiveButton<String>(
        title: String,
        onTap: @escaping () -> Void
    ) -> UMAlert<Title, Subtitle, Description, TupleView<(Button?, AnyView)>> where String: StringProtocol {

        self.button {
            AnyView(
                SwiftUI.Button(action: onTap) {
                    Text(title)
                        .foregroundColor(Color.red)
                        .font(.body)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.all, 15)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white
                                .opacity(0.75)
                                .edgesIgnoringSafeArea(.all)
                                .blur(radius: 20)
                        )
                        .cornerRadius(5)
                }
            )
        }
    }

    func otherButton<String>(
        title: String,
        onTap: @escaping () -> Void
    ) -> UMAlert<Title, Subtitle, Description, TupleView<(Button?, AnyView)>> where String: StringProtocol {

        self.button {

            AnyView(
                SwiftUI.Button(action: onTap) {
                    Text(title)
                        .foregroundColor(Color.black)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.all, 15)
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white
                                .opacity(0.75)
                                .edgesIgnoringSafeArea(.all)
                                .blur(radius: 20)
                        )
                        .cornerRadius(5)
                }
            )
        }
    }
}
#endif
