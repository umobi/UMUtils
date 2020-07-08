//
//  SwiftUIView.swift
//  
//
//  Created by brennobemoura on 08/07/20.
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
                        Text(title)
                            .foregroundColor(self.titleColor ?? .black)
                            .font(self.titleFont ?? .body)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 150)
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
