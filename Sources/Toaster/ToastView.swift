//
//  ToastView.swift
//  
//
//  Created by Stas Kirichok on 16.06.2023.
//

import SwiftUI

extension ToastStyle {
    var backgroundColor: Color {
        switch self {
        case .error:
            return .red
        case .success:
            return .green
        case .warning:
            return .yellow
        }
    }
    
    var title: String {
        switch self {
        case .error:
            return "Error"
        case .success:
            return "Success"
        case .warning:
            return "Warning"
        }
    }
}

struct ToastView: View {
    let toast: Toast
    
    var body: some View {
        HStack {
            VStack {
                Text(toast.title)
                    .bold()
                    .foregroundColor(.white)
                if let message = toast.message {
                    Text(message)
                        .lineLimit(nil)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(toast.style.backgroundColor)
            )
            .padding(.horizontal, 15)
        }
    }
}
