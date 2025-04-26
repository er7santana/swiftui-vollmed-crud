//
//  SnackBarView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import SwiftUI

struct SnackBarView: View {
    
    @Binding var isShowing: Bool
    var message: String
    var duration: Double = 3.0
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if isShowing {
                Text(message)
                    .padding()
                    .multilineTextAlignment(.center)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .animation(.easeInOut(duration: 1.5), value: isShowing)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
        }
        .transition(.move(edge: .bottom))
        .padding(.horizontal)
        .padding(.bottom, 100)
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isShowing = false
    ZStack {
        VStack {
            Button {
                withAnimation {
                    isShowing = true
                }
            } label: {
                ButtonView(text: "Show SnackBar")
            }
        }
        SnackBarView(isShowing: $isShowing, message: "Minha mensagem para ser exibida")
            .transition(.move(edge: .bottom))
    }
    .padding()
}
