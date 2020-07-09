//
//  File.swift
//  
//
//  Created by brennobemoura on 07/07/20.
//

import Foundation
import Network
import Combine

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
    private class Box {
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
            self.listenerCount = abs(self.listenerCount - 1)

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
