//
//  ArticlesView.swift
//  TestNews
//
//

import SwiftUI

struct ArticlesView: View {
    @StateObject private var viewModel = ArticleViewModel()
    @State private var showError = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(viewModel.articles.enumerated()), id: \.element.id) { index, article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                if index == 0 {
                                    ArticleHeroView(article: article)
                                } else {
                                    ArticleRowView(article: article)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .onAppear {
                                // Load more when reaching near the end
                                if index == viewModel.articles.count - 5 {
                                    Task {
                                        await viewModel.loadMore()
                                    }
                                }
                            }
                        }

                        // Loading indicator at bottom
                        if viewModel.isLoading && !viewModel.articles.isEmpty {
                            ProgressView()
                                .padding()
                        }
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }

                // Initial loading indicator
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView()
                }
            }
            .navigationTitle("Articles")
            .alert("Error", isPresented: $showError) {
                Button("OK") {
                    showError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .onChange(of: viewModel.errorMessage) { newValue in
                if newValue != nil {
                    showError = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
