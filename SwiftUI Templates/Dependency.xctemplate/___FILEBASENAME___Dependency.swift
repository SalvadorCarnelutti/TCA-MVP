//
//  ___FILEHEADER___
//

import Foundation

struct ___VARIABLE_moduleName:identifier___Dependency {
    // YOUR IMPLEMENTATION
}

private struct ___VARIABLE_moduleName:identifier___Key: DependencyKey {    
    static var currentValue: ___VARIABLE_moduleName:identifier___Dependency = ___VARIABLE_moduleName:identifier___Dependency()
}

extension DependencyValues {
    var ___VARIABLE_moduleNameFirstLetterLowercased:identifier___: ___VARIABLE_moduleName:identifier___Dependency {
        get { DependencyValues[___VARIABLE_moduleName:identifier___Key.self] }
        set { DependencyValues[___VARIABLE_moduleName:identifier___Key.self] = newValue }
    }
}
