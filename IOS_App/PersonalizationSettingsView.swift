import SwiftUI

struct PersonalizationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @AppStorage("preferredTopicsJSON") private var preferredTopicsJSON: String = "[]"
    @AppStorage("feedMode") private var feedModeRaw: String = FeedMode.personalized.rawValue
    @AppStorage("hasSeenPersonalizationOnboarding") private var hasSeenPersonalizationOnboarding: Bool = true

    @State private var selectedTopics: Set<String> = []

    private let topics: [String] = [
        "Bitcoin", "Ethereum", "DeFi", "Layer2", "Security", "Regulation", "NFT", "Markets"
    ]

    var body: some View {
        Form {
            Section("Feed Mode") {
                Picker("Default Feed", selection: $feedModeRaw) {
                    Text("For You").tag(FeedMode.personalized.rawValue)
                    Text("Latest").tag(FeedMode.latest.rawValue)
                }
                .pickerStyle(.segmented)
            }

            Section("Topics") {
                Text("Pick topics to shape your For You feed.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], spacing: 8) {
                    ForEach(topics, id: \.self) { topic in
                        Button {
                            if selectedTopics.contains(topic) {
                                selectedTopics.remove(topic)
                            } else {
                                selectedTopics.insert(topic)
                            }
                        } label: {
                            Text(topic)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(selectedTopics.contains(topic) ? Color.blue : Color(.systemGray5))
                                .foregroundStyle(selectedTopics.contains(topic) ? .white : .primary)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }

            Section {
                Button("Reset Personalization") {
                    selectedTopics.removeAll()
                    feedModeRaw = FeedMode.personalized.rawValue
                    hasSeenPersonalizationOnboarding = false
                    persistAndSync()
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("Personalization")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    persistAndSync()
                    dismiss()
                }
            }
        }
        .onAppear {
            selectedTopics = Set(Self.decodeTopics(from: preferredTopicsJSON))
        }
        .onChange(of: selectedTopics) { _, _ in
            persistAndSync()
        }
        .onChange(of: feedModeRaw) { _, _ in
            persistAndSync()
        }
    }

    private func persistAndSync() {
        let topics = Array(selectedTopics).sorted()
        preferredTopicsJSON = Self.encodeTopics(topics)

        guard let userId = authManager.currentUser?.id else { return }
        Task {
            await SupabaseService.shared.syncPersonalization(
                userId: userId,
                preferredTopics: topics,
                feedMode: feedModeRaw
            )
        }
    }

    static func decodeTopics(from json: String) -> [String] {
        guard let data = json.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return decoded
    }

    static func encodeTopics(_ topics: [String]) -> String {
        guard let data = try? JSONEncoder().encode(topics),
              let json = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return json
    }
}

enum FeedMode: String {
    case personalized
    case latest
}

struct PersonalizationOnboardingView: View {
    let initialTopics: [String]
    let onContinue: (_ topics: [String], _ mode: FeedMode) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedTopics: Set<String> = []
    @State private var selectedMode: FeedMode = .personalized

    private let topics: [String] = [
        "Bitcoin", "Ethereum", "DeFi", "Layer2", "Security", "Regulation", "NFT", "Markets"
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Build your For You feed")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Choose a few topics to personalize article ranking. You can edit this anytime in Settings.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Picker("Feed Mode", selection: $selectedMode) {
                    Text("For You").tag(FeedMode.personalized)
                    Text("Latest").tag(FeedMode.latest)
                }
                .pickerStyle(.segmented)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], spacing: 8) {
                        ForEach(topics, id: \.self) { topic in
                            Button {
                                if selectedTopics.contains(topic) {
                                    selectedTopics.remove(topic)
                                } else {
                                    selectedTopics.insert(topic)
                                }
                            } label: {
                                Text(topic)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedTopics.contains(topic) ? Color.blue : Color(.systemGray5))
                                    .foregroundStyle(selectedTopics.contains(topic) ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Button {
                    onContinue(Array(selectedTopics).sorted(), selectedMode)
                    dismiss()
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, 8)
            }
            .padding()
            .navigationTitle("Personalization")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                selectedTopics = Set(initialTopics)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PersonalizationSettingsView()
            .environmentObject(AuthenticationManager())
    }
}
