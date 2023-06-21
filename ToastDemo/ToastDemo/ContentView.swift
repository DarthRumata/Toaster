//
//  ContentView.swift
//  ToastDemo
//
//  Created by Stas Kirichok on 18.06.2023.
//

import SwiftUI
import Toaster

class ViewModel: ObservableObject {
    private(set) var toastScheduler = ToastScheduler()
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var error: Error?
    @State var isToastPresented = false
    
    var body: some View {
        let errorBinding = Binding<Toast?>(get: {
            if error != nil {
                print("toast generated")
                return Toast(message: "Toasted!!! \(Int.random(in: 0...100))", style: .error, dismissDelay: 3)
            }
            return nil
        }, set: { newValue in
            if newValue == nil {
                print("Error cleared")
                error = nil
            }
        })
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("Show Predefined Toast") {
                error = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
            }
            Button("Show Custom Toast") {
                print("isToastPresented \(isToastPresented)")
                isToastPresented = true
            }
            Button("Schedule Toast") {
                viewModel.toastScheduler.present(ErrorView(), dismissDelay: 3)
            }
        }
        .padding()
        .toastView(toast: errorBinding)
        .toastView(scheduler: viewModel.toastScheduler)
        .toastView(isPresented: $isToastPresented) {
            ErrorView()
        }
    }
}

struct ErrorView: View {
    var body: some View {
        Text("AAAAA")
            .frame(height: 100)
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).fill(.green))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
