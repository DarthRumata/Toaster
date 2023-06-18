//
//  ContentView.swift
//  ToastDemo
//
//  Created by Stas Kirichok on 18.06.2023.
//

import SwiftUI
import Toaster

struct ContentView: View {
    @State var error: Error?
    
    var body: some View {
        let errorBinding = Binding<Toast?>(get: {
            if error != nil {
                return Toast(message: "Toasted!!!", style: .error)
            }
            return nil
        }, set: { newValue in
            if newValue == nil {
                error = nil
            }
        })
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("Show Toast") {
                error = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))
            }
        }
        .padding()
        .toastView(toast: errorBinding)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
