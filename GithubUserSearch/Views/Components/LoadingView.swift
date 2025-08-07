//
//  LoadingView.swift
//  GithubUserSearch
//
//  Created by Ankit on 08/08/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 18) {
            ProgressView()
                .scaleEffect(1.3)
            Text("searching github")
                .foregroundColor(.secondary)
                .font(.headline)
        }
    }
}

#Preview {
    LoadingView()
}
