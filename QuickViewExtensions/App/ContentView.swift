import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.accentColor)

            Text("QuickViewExtensions")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Quick Look preview extensions for macOS")
                .font(.title3)
                .foregroundStyle(.secondary)

            Divider()
                .padding(.horizontal, 40)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ExtensionRow(
                        icon: "doc.richtext",
                        name: "easyMDView",
                        description: "Markdown files with Mermaid diagrams",
                        fileTypes: ".md"
                    )
                    ExtensionRow(
                        icon: "curlybraces",
                        name: "easyJSONView",
                        description: "JSON with collapsible tree and syntax highlighting",
                        fileTypes: ".json"
                    )
                    ExtensionRow(
                        icon: "chevron.left.forwardslash.chevron.right",
                        name: "easyCodeView",
                        description: "Source code with syntax highlighting (40+ languages)",
                        fileTypes: ".swift .py .js .cs .sql ..."
                    )
                    ExtensionRow(
                        icon: "text.alignleft",
                        name: "easyYAMLView",
                        description: "YAML files with syntax highlighting",
                        fileTypes: ".yaml .yml"
                    )
                    ExtensionRow(
                        icon: "lock.shield",
                        name: "easyDotEnvView",
                        description: "Environment files with masked secrets",
                        fileTypes: ".env"
                    )
                    ExtensionRow(
                        icon: "list.bullet.rectangle",
                        name: "easyLogView",
                        description: "Log files with color-coded severity levels",
                        fileTypes: ".log"
                    )
                }
                .padding(.horizontal, 20)
            }

            Divider()
                .padding(.horizontal, 40)

            VStack(spacing: 8) {
                Text("How to use")
                    .font(.headline)

                Text("Select any supported file in Finder and press **Space** to see the formatted preview.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    Text("Manage extensions in")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Button("System Settings") {
                        NSWorkspace.shared.open(
                            URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension")!
                        )
                    }
                    .font(.caption)
                    .buttonStyle(.link)
                }
            }
        }
        .padding(32)
        .frame(width: 500, height: 620)
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
