//
//  File.swift
//  
//
//  Created by brennobemoura on 15/07/20.
//

import Foundation
import SwiftUI
import Combine

public protocol APILoadingState: ObservableObject {
    associatedtype Body : View

    func render<Content>(_ content: Content) -> Body where Content: View
}

private struct APIView<LoadingState, Content>: View where Content: View, LoadingState: APILoadingState {
    let content: () -> Content
    @ObservedObject var state: LoadingState

    init(_ state: LoadingState, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.state = state
    }

    var body: some View {
        state.render(self.content())
    }
}

#if os(iOS) || os(tvOS)
import UIKit

public class APIBooleanLoadingState: APILoadingState {
    public typealias Body = AnyView

    public let activityPublisher: ActivityPublisher = .init()
    @Published var isLoading: Bool = false

    private var cancellables: [AnyCancellable] = []
    private let style: UIActivityIndicatorView.Style

    init(style: UIActivityIndicatorView.Style) {
        self.style = style

        self.activityPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.isLoading = $0
            }.store(in: &self.cancellables)
    }

    private static var loadingStates: [APIBooleanLoadingState] = []
    public static func shared(_ style: UIActivityIndicatorView.Style) -> APIBooleanLoadingState {
        if let state = self.loadingStates.first(where: { $0.style == style }) {
            return state
        }

        let state = APIBooleanLoadingState(style: style)
        self.loadingStates.append(state)
        return state
    }

    public func render<Content>(_ content: Content) -> AnyView where Content : View {
        if self.isLoading {
            return AnyView(
                ZStack {
                    content

                    ActivityView(style: self.style)
                        .edgesIgnoringSafeArea(.all)
                }
            )
        }

        return AnyView(content)
    }
}

#endif

public extension View {
    func apiLoadingView<LoadingState: APILoadingState>(_ loadingState: LoadingState) -> AnyView {
        AnyView(
            APIView(
                loadingState,
                content: { self }
            )
        )
    }
}
