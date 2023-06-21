# Toaster

![workflow](https://github.com/DarthRumata/Toaster/actions/workflows/swift.yml/badge.svg)
[![codecov](https://codecov.io/gh/DarthRumata/Toaster/branch/main/graph/badge.svg?token=UNACNI5GTO)](https://codecov.io/gh/DarthRumata/Toaster)

Toaster is a lightweight SwiftUI library for presenting toast messages in your iOS apps. It provides a simple and customizable way to display temporary notifications to the user.

## Features

- Predefined toast styles (error, success, warning)
- Customizable toast views
- Flexible presentation options

## Installation

To use Toaster in your SwiftUI project, simply add the Toaster package as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/DarthRumata/Toaster.git", from: "0.4.0")
]
```

## Usage

To present a toast message, you can use the ``toastView`` modifier on your SwiftUI views. Toaster provides multiple variants of the toastView modifier depending on your use case.

### Predefined Toast
You can show a predefined toast using the toastView(toast:) modifier. It takes a binding to a Toast object as input.

```swift
struct ContentView: View {
    @State var error: Error?
    
    var body: some View {
        let errorBinding = Binding<Toast?>(get: {
            if error != nil {
                return Toast(message: "An error occurred", style: .error)
            }
            return nil
        }, set: { newValue in
            if newValue == nil {
                error = nil
            }
        })
        
        VStack {
            // Your view content
            
            Button("Show Error Toast") {
                error = MyCustomError()
            }
        }
        .toastView(toast: errorBinding)
    }
}
```

### Custom Toast
If you want to present a custom toast view, you can use the ``toastView(isPresented:view:)`` modifier. It takes a binding to a boolean value indicating the toast presentation state and a closure that returns the custom toast view.

```swift
struct ContentView: View {
    @State var isToastPresented = false
    
    var body: some View {
        VStack {
            // Your view content
            
            Button("Show Custom Toast") {
                isToastPresented = true
            }
        }
        .toastView(isPresented: $isToastPresented) {
            CustomToastView()
        }
    }
}
```

### Scheduler
To control the presentation of toast messages manually, you can use the ToastScheduler class. You can create an instance of the scheduler and pass it to the ``toastView(scheduler:)`` modifier.

```swift
class ViewModel: ObservableObject {
    private(set) var toastScheduler = ToastScheduler()
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            // Your view content
            
            Button("Schedule Toast") {
                viewModel.toastScheduler.present(CustomToastView(), dismissDelay: 3)
            }
        }
        .toastView(scheduler: viewModel.toastScheduler)
    }
}
```

<img src="https://github.com/DarthRumata/Toaster/assets/3137314/c39c1079-8488-474d-8dde-c23a24444558" width="300">
