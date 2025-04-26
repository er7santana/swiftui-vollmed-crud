//
//  RedactedAnimadionModifier.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import SwiftUI

struct RedactedAnimationModifier: ViewModifier {
    @State private var isRedacted = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isRedacted ? 0 : 1)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                    isRedacted.toggle()
                }
            }
    }
}

extension View {
    func redactedAnimation() -> some View {
        self.modifier(RedactedAnimationModifier())
    }
}
