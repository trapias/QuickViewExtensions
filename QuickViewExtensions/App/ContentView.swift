import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "eye.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.accentColor)

            Text("QuickViewExtensions")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Quick Look preview extensions for macOS")
                .font(.title3)
                .foregroundStyle(.secondary)

            Divider()
                .padding(.horizontal, 40)

            VStack(alignment: .leading, spacing: 16) {
                ExtensionRow(
                    icon: "doc.richtext",
                    name: "easyMDView",
                    description: "Renders Markdown files as formatted HTML",
                    fileTypes: ".md"
                )
            }
            .padding(.horizontal, 20)

            Divider()
                .padding(.horizontal, 40)

            VStack(spacing: 8) {
                Text("How to use")
                    .font(.headline)

                Text("Select any supported file in Finder and press **Space** to see the formatted preview.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Text("Extensions activate automatically after first launch.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(40)
        .frame(width: 480, height: 420)
    }
}

struct ExtensionRow: View {
    let icon: String
    let name: String
    let description: String
    let fileTypes: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name).fontWeight(.semibold)
                    Text(fileTypes)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary)
                        .clipShape(Capsule())
                }
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
    }
}

#Preview {
    ContentView()
}
