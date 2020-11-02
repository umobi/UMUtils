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

import Foundation
import Network
import Combine

@frozen
public struct Networking {
    private let box: Box

    public var isConnected: Publishers.HandleEvents<Published<Bool>.Publisher> {
        self.box.startMonitoring()

        return self.box.$isConnected.handleEvents(receiveCompletion: { _ in
            self.box.stopMonitoring()
        }, receiveCancel: {
            self.box.stopMonitoring()
        })
    }

    private init() {
        self.box = .init()
    }

    private init(observeInterfaceType: NWInterface.InterfaceType) {
        self.box = .init(observeInterfaceType: observeInterfaceType)
    }
}

extension Networking {
    @usableFromInline
    class Box {
        @Published var isConnected: Bool = false

        let monitor: NWPathMonitor

        var isMonitoring: Bool = false
        var listenerCount: Int = 0

        init() {
            self.monitor = .init()
        }

        init(observeInterfaceType: NWInterface.InterfaceType) {
            self.monitor = .init(requiredInterfaceType: observeInterfaceType)
        }

        func startMonitoring(in queue: DispatchQueue? = nil) {
            self.listenerCount += 1

            guard !self.isMonitoring else {
                return
            }

            self.isMonitoring = true
            self.monitor.pathUpdateHandler = { [weak self] in
                self?.pathChanged($0)
            }

            self.monitor.start(queue: queue ?? .init(label: "com.umobi.networking"))
        }

        func stopMonitoring() {
            self.listenerCount = positiveOrZero(self.listenerCount - 1)

            if self.listenerCount == 0 {
                self.monitor.cancel()
                self.isMonitoring = false
            }
        }

        func pathChanged(_ path: NWPath) {
            self.isConnected = path.status == .satisfied
        }

        deinit {
            self.monitor.cancel()
        }
    }
}

public extension Networking {
    static let shared: Networking = .init()
}
