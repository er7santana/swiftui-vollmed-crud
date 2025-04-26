//
//  SkeletonView.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 25/04/25.
//

import SwiftUI

struct SkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            ForEach(0..<5) { _ in
                SkeletonRow()
            }
        }
        .padding()
    }
}

#Preview {
    SkeletonView()
}

struct SkeletonRow: View {
    private var placeholderString = "*******************************"
    var body: some View {
        HStack(spacing: 8) {
            
            LinearGradient(gradient: Gradient(colors: [
                .gray, .gray.opacity(0.3)
            ]), startPoint: .leading, endPoint: .trailing)
            .mask(
                Circle()
                    .frame(width: 60, height: 60, alignment: .leading)
            )
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<2) { _ in
                    LinearGradient(gradient: Gradient(colors: [
                        .gray, .gray.opacity(0.3)
                    ]), startPoint: .leading, endPoint: .trailing)
                    .mask(
                        Text(placeholderString)
                            .redacted(reason: .placeholder)
                    )
                }
            }
            
            Spacer()
        }
        .frame(height: 60)
        .redactedAnimation()
    }
}
