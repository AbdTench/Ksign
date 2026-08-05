//
//  SourceAppsCellView.swift
//  Feather
//
//  Created by samara on 3.05.2025.
//

import SwiftUI
import AltSourceKit
import NimbleViews
import Combine
import NukeUI

// thats a whole pharaghraph of codes
struct SourceAppsCellView: View {
    @AppStorage("Feather.storeCellAppearance") private var _storeCellAppearance: Int = 0
    
    var source: ASRepository
    var app: ASRepository.App
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // App Icon with Corner Radius
                if let iconURL = app.iconURL {
                    LazyImage(url: iconURL) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        } else {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(uiColor: .tertiarySystemFill))
                                .frame(width: 60, height: 60)
                        }
                    }
                } else {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(uiColor: .tertiarySystemFill))
                        .frame(width: 60, height: 60)
                }
                
                // App Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(app.currentName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    // Rating and Size
                    HStack(spacing: 8) {
                        // Star Rating (if available)
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundStyle(.yellow)
                            Text("4.8")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        // App Size
                        if let size = app.size {
                            Text(size.formattedByteCount)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // App Description
                    Text(app.currentDescription ?? .localized("An awesome application"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Download Button
                DownloadButtonView(app: app)
            }
            
            // Full Description (if enabled)
            if
                _storeCellAppearance != 0,
                let desc = app.localizedDescription
            {
                Text(desc)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 8)
    }
    
    static func appDescription(app: ASRepository.App) -> String {
        let optionalComponents: [String?] = [
            app.currentVersion,
            app.currentDescription ?? .localized("An awesome application")
        ]
        
        let components: [String] = optionalComponents.compactMap { value in
            guard
                let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
                !trimmed.isEmpty
            else {
                return nil
            }
            
            return trimmed
        }
        
        return components.joined(separator: " • ")
    }
}
