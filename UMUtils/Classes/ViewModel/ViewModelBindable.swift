//
//  ViewModelBindable.swift
//  Pods
//
//  Created by Ramon Vicente on 16/03/17.
//
//

import Foundation

public protocol ViewModelBindable: class {
    
    associatedtype ViewModel: UMUtils.ViewModel
    
    var viewModel: ViewModel! { get set }
    
    func bindViewModel(viewModel: ViewModel)
}

private let viewModelAssociated = ObjectAssociation<ViewModel>(policy: .OBJC_ASSOCIATION_RETAIN)

extension ViewModelBindable {

    public var viewModel: ViewModel! {
        
        get {
            return viewModelAssociated[self] as? ViewModel
        }
        
        set(newViewModel) {
            guard self.viewModel == nil else {
                fatalError("[ViewModel] don't reset view models")
            }

            guard let viewModel = newViewModel else {
                fatalError("[ViewModel] don't init view model with nil values")
            }

            viewModelAssociated[self] = viewModel
            registerBinding(viewModel: viewModel)
        }
    }
    
    private func registerBinding(viewModel: ViewModel) {
        bindViewModel(viewModel: viewModel)
    }
    
}
