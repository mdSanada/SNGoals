//
//  Registering.swift
//  Template
//
//  Created by Matheus D Sanada on 22/09/21.
//

import Foundation
import Resolver
import Moya

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { AppLauncher() as Launcher }
    }
}
