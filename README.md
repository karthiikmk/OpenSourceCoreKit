# CoreKit

A description of this package.

## DI 

```Swift

@main
struct YourApp: App {
    init() { 
        // Put your DI setup here. 
    }
}

// SetupDI
SwiftDI.shared.setup(
    assemblies: [
        ServiceAssembly(),
        ViewModelAssembly()
    ],
    inContainer: Container()
)
 
class ServiceAssembly: Assembly { 
    func assemble(container: Container) { 
        // put you reusable service here 
    }
}

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        // Put you view models here 
        container.autoregister(SomeViewModel.self, initializer: SomeViewModel.init)
        container.register(SomeViewModel.self) { r in
            // initialization goes here
            return SomeViewMode()
        }
    }
}

@Inject - Use this inside viewModel for object lookup 
@ObservedInject - Use this in swiftUI for the object lookup
```
