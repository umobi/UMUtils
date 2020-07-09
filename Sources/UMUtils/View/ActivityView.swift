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

public struct ActivityView: View {
    private let style: UIActivityIndicatorView.Style
    private let color: UIColor
    private let title: String?
    private let titleColor: Color?
    private let titleFont: Font?

    public init(style: UIActivityIndicatorView.Style) {
        self.style = style
        self.color = .black
        self.title = nil
        self.titleColor = nil
        self.titleFont = nil
    }

    private init(_ original: ActivityView, editable: Editable) {
        self.style = original.style
        self.color = editable.color
        self.title = editable.title
        self.titleColor = editable.titleColor
        self.titleFont = editable.titleFont
    }

    @State private var height: CGFloat = 0

    public var body: some View {
        ZStack {
            Color.black
                .opacity(0.15)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            ZStack {
                VStack(spacing: 7.5) {
                    UMActivity(style: self.style)
                        .color(self.color)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)

                    if let title = self.title {
                        ScrollView {
                            Text(title)
                                .foregroundColor(self.titleColor ?? .black)
                                .font(self.titleFont ?? .body)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 150)
                                .background(GeometryReader { geometry -> AnyView in
                                    OperationQueue.main.addOperation {
                                        self.height = geometry.size.height
                                    }

                                    return AnyView(Rectangle().fill(Color.clear))
                                })
                        }
                        .frame(maxHeight: self.height)
                    }
                }
                .layoutPriority(2)
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 15)
            .background(UMBlur())
            .cornerRadius(7.5)
            .shadow(
                color: Color.black.opacity(0.15),
                radius: 5,
                x: 2, y: 3
            )
        }
    }
}

private extension ActivityView {
    class Editable {
        var color: UIColor
        var title: String?
        var titleColor: Color?
        var titleFont: Font?

        init(_ original: ActivityView) {
            self.color = original.color
            self.title = original.title
            self.titleColor = original.titleColor
            self.titleFont = original.titleFont
        }
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

public extension ActivityView {

    func color(_ color: UIColor) -> Self {
        self.edit {
            $0.color = color
        }
    }

    func title(_ title: String) -> Self {
        self.edit {
            $0.title = title
        }
    }

    func titleColor(_ color: Color) -> Self {
        self.edit {
            $0.titleColor = color
        }
    }

    func titleFont(_ font: Font) -> Self {
        self.edit {
            $0.titleFont = font
        }
    }
}

#if DEBUG
struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(style: .large)
    }
}
#endif
