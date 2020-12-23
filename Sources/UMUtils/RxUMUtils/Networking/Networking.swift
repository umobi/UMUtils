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

import Network
import Combine
import SwiftUI

@frozen @propertyWrapper
public struct Networking: DynamicProperty {
    @ObservedObject private var service: Service

    public init() {
        service = .shared
    }

    public init(monitor: NWPathMonitor, queue: DispatchQueue) {
        service = .init(
            monitor: monitor,
            queue: queue
        )
    }

    public var wrappedValue: Bool {
        service.isConnected
    }

    public var projectedValue: Published<Bool>.Publisher {
        service.$isConnected
    }
}

private extension Networking {
    class Service: ObservableObject {
        static let shared = Service()

        @Published var isConnected: Bool = false

        private let monitor: NWPathMonitor
        private let queue: DispatchQueue

        init() {
            monitor = .init()
            queue = .init(label: "com.umobi.networking")
            load()
        }

        init(monitor: NWPathMonitor, queue: DispatchQueue) {
            self.monitor = monitor
            self.queue = queue
            load()
        }

        private func load() {
            monitor.pathUpdateHandler = { [weak self] in
                self?.isConnected = $0.status == .satisfied
            }

            monitor.start(queue: queue)
        }

        deinit {
            monitor.cancel()
        }
    }
}
