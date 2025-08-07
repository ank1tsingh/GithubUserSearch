//
//  SwiftUIView.swift
//  GithubUserSearch
//
//  Created by Ankit on 07/08/25.
//

import SwiftUI

struct RepositoryRowView: View {
    let repository: GitHubRepository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(repository.repositoryName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !repository.isPrivateRepo {
                    Image(systemName: "eye")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            
            if let description = repository.repoDescription, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            HStack(spacing: 20) {
                if let language = repository.primaryLanguage {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                        Text(language)
                    }
                    .foregroundColor(.blue)
                }
                
                Label("\(repository.starCount)", systemImage: "star.fill")
                    .foregroundColor(.yellow)
                
                Label("\(repository.forkCount)", systemImage: "arrow.triangle.branch")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .font(.caption)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}


//
//#Preview {
//    SwiftUIView()
//}
