//
//  ArticleHeroView.swift
//  TestNews
//
//

import SwiftUI
import Kingfisher

struct ArticleHeroView: View {
    let article: Article

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Background Image
                KFImage(URL(string: article.imageUrl ?? ""))
                    .placeholder {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .frame(width: geometry.size.width - 16)
                            .frame(height: 300)
                            .background(Color.gray.opacity(0.2))
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 16)
                    .frame(height: 300)
                    .clipped()

                // Gradient Overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: geometry.size.width - 16)

                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)

                    Text(article.description)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .opacity(0.9)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Text(article.formattedDate)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                .frame(width: geometry.size.width - 48, alignment: .leading)
                .padding(16)

                // Featured Badge
                VStack {
                    HStack {
                        Text("FEATURED")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .cornerRadius(4)

                        Spacer()
                    }
                    .padding(16)

                    Spacer()
                }
                .frame(width: geometry.size.width - 16)
            }
            .frame(height: 300)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .frame(height: 300)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}
