//
//  ___FILEHEADER___
//

import Foundation

struct ___VARIABLE_moduleName:identifier___Dependency {
    var client: Client
    
    struct Client {
        // var getModel: () async throws -> Model
    }
}

private struct ___VARIABLE_moduleName:identifier___Key: DependencyKey {
    private static var currentClient: ___VARIABLE_moduleName:identifier___Dependency.Client {
        ___VARIABLE_moduleName:identifier___Dependency.Client(/*getModel: { try await ... }*/)
    }
    
    static var currentValue: ___VARIABLE_moduleName:identifier___Dependency = ___VARIABLE_moduleName:identifier___Dependency(client: Self.currentClient)
}

extension DependencyValues {
    var ___VARIABLE_moduleNameFirstLetterLowercased:identifier___: ___VARIABLE_moduleName:identifier___Dependency {
        get { DependencyValues[___VARIABLE_moduleName:identifier___Key.self] }
        set { DependencyValues[___VARIABLE_moduleName:identifier___Key.self] = newValue }
    }
}
