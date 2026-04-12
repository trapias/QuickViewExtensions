import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExtensionsTab()
                .tabItem {
                    Label("Extensions", systemImage: "puzzlepiece.extension")
                }

            AboutTab()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 580)
    }
}

// MARK: - Extensions Tab

struct ExtensionsTab: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("AppIcon")
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(14)

            Text("QuickViewExtensions")
                .font(.title2)
                .fontWeight(.bold)

            Text("Quick Look preview extensions for macOS")
                .font(.callout)
                .foregroundStyle(.secondary)

            Divider()
                .padding(.horizontal, 40)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
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
                        fileTypes: ".swift .py .js .cs ..."
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

            VStack(spacing: 6) {
                Text("Select any supported file in Finder and press **Space** to preview.")
                    .font(.caption)
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
        .padding(24)
    }
}

// MARK: - Settings Tab

struct SettingsTab: View {
    private let bundleID = "it.trapias.easyQuickView"

    private let extensions: [(id: String, name: String, icon: String, fileTypes: String)] = [
        ("easyMDView", "Markdown Viewer", "doc.richtext", ".md"),
        ("easyJSONView", "JSON Viewer", "curlybraces", ".json"),
        ("easyCodeView", "Code Viewer", "chevron.left.forwardslash.chevron.right", ".swift .py .js .cs ..."),
        ("easyYAMLView", "YAML Viewer", "text.alignleft", ".yaml .yml"),
        ("easyDotEnvView", "DotEnv Viewer", "lock.shield", ".env"),
        ("easyLogView", "Log Viewer", "list.bullet.rectangle", ".log"),
    ]

    @State private var statuses: [String: Bool] = [:]

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 4) {
                Image(systemName: "gearshape")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                Text("Extension Management")
                    .font(.title3.weight(.semibold))
                Text("Extensions are managed by macOS.\nUse System Settings to enable or disable them.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Divider()
                .padding(.horizontal, 40)

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(extensions, id: \.id) { ext in
                        HStack(spacing: 12) {
                            Image(systemName: ext.icon)
                                .font(.title3)
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 1) {
                                Text(ext.name)
                                    .font(.system(size: 13, weight: .medium))
                                Text(ext.fileTypes)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if statuses[ext.id] == true {
                                Label("Enabled", systemImage: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            } else {
                                Label("Disabled", systemImage: "xmark.circle")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.horizontal, 20)
            }

            Divider()
                .padding(.horizontal, 40)

            VStack(spacing: 10) {
                Button {
                    NSWorkspace.shared.open(
                        URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension")!
                    )
                } label: {
                    Label("Open System Settings", systemImage: "arrow.up.forward.app")
                }
                .controlSize(.regular)

                Button("Refresh Status") {
                    refreshStatuses()
                }
                .buttonStyle(.link)
                .font(.caption)
            }
        }
        .padding(24)
        .onAppear {
            refreshStatuses()
        }
    }

    private func refreshStatuses() {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pluginkit")
        task.arguments = ["-m", "-p", "com.apple.quicklook.preview", "-A", "-D"]
        let pipe = Pipe()
        task.standardOutput = pipe
        try? task.run()
        task.waitUntilExit()

        let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
        var newStatuses: [String: Bool] = [:]
        for ext in extensions {
            let fullID = "\(bundleID).\(ext.id)"
            // + prefix means enabled in pluginkit output
            newStatuses[ext.id] = output.contains("+    \(fullID)")
        }
        statuses = newStatuses
    }
}

// MARK: - About Tab

struct AboutTab: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("AppIcon")
                .resizable()
                .frame(width: 96, height: 96)
                .cornerRadius(20)

            VStack(spacing: 4) {
                Text("QuickViewExtensions")
                    .font(.title2.weight(.semibold))

                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text("Quick Look preview extensions for Markdown, JSON, source code, YAML, .env, and log files.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Divider()
                .padding(.horizontal, 60)

            // Links
            VStack(spacing: 12) {
                SupportLinkButton(
                    title: "Buy me a coffee",
                    subtitle: "Support development",
                    icon: "cup.and.saucer.fill",
                    color: .yellow,
                    url: "https://buymeacoffee.com/trapias"
                )

                SupportLinkButton(
                    title: "PayPal",
                    subtitle: "One-time or recurring donation",
                    icon: "creditcard.fill",
                    color: .blue,
                    url: "https://www.paypal.com/paypalme/AlbertoVelo"
                )

                SupportLinkButton(
                    title: "Website",
                    subtitle: "mac.trapias.it",
                    icon: "globe",
                    color: .purple,
                    url: "https://mac.trapias.it"
                )
            }
            .padding(.horizontal, 40)

            Spacer()

            Text("Made with care by trapias")
                .font(.caption2)
                .foregroundStyle(.quaternary)
        }
        .padding(24)
    }
}

// MARK: - Support Link Button

private struct SupportLinkButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let url: String

    @State private var isHovered = false

    var body: some View {
        Button {
            if let url = URL(string: url) {
                NSWorkspace.shared.open(url)
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(color)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 7))

                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isHovered ? color.opacity(0.4) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Extension Row

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
