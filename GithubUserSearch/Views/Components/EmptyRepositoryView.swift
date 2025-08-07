//
//  EmptyRepositoryView.swift
//  GithubUserSearch
//
//  Created by Ankit on 08/08/25.
//

import SwiftUI

struct EmptyRepositoryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder.badge.questionmark")
                .font(.system(size: 44))
                .foregroundColor(.secondary)
            
            Text("No repositories yet")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("This developer hasn't created any public repositories")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    EmptyRepositoryView()
}
