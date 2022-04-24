//
//  File.swift
//  
//
//  Created by Karthik on 24/04/22.
//

import Foundation
import Swinject

extension ObjectScope {
    
    /// An instance provided by the ``Container`` is shared within the ``Container`` and its child `Containers`.
    public static let singleton = ObjectScope.container
    
    /// Instances are shared only when an object graph is being created,
    /// otherwise a new instance is created by the ``Container``. This is the default scope.
    public static let new = ObjectScope.transient
}
