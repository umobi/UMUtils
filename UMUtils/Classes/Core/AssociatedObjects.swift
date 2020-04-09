//
//  AssociatedObjects.swift
//  Pods
//
//  Created by Ramon Vicente on 16/03/17.
//
//

public var AssociatedKey: UInt = 0

public final class ObjectAssociation<T> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {

        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {

        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

public extension ObjectAssociation {
    func lazy(_ object: AnyObject, load handler: () -> T) -> T {
        if let t = self[object] {
            return t
        }

        let t = handler()
        self[object] = t
        return t
    }
}
