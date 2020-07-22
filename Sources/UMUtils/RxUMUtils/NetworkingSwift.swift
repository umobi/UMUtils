//
//  File.swift
//
//
//  Created by brennobemoura on 07/07/20.
//

import Foundation
import Network
import RxCocoa
import RxSwift

public func positive<Number>(_ x: Number) -> Number where Number: Comparable & Numeric {
    x <= 0 ? 0 : x - 1
}

@available(iOS 12, *)
public struct Networking {
    private let box: Box

    public var isConnected: Observable<Bool> {
        self.box.startMonitoring()

        return self.box.isConnected.asObservable().do(onCompleted: {
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

@available(iOS 12, *)
extension Networking {
    private class Box {
        let isConnected: BehaviorRelay<Bool> = .init(value: false)

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
            self.listenerCount = positive(self.listenerCount - 1)

            if self.listenerCount == 0 {
                self.monitor.cancel()
                self.isMonitoring = false
            }
        }

        func pathChanged(_ path: NWPath) {
            DispatchQueue.main.async {
                self.isConnected.accept(path.status == .satisfied)
            }
        }

        deinit {
            self.monitor.cancel()
        }
    }
}

@available(iOS 12, *)
public extension Networking {
    static let shared: Networking = .init()
}
