import Foundation

/// Maps file extensions to highlight.js language identifiers.
enum LanguageMap {

    static func language(for ext: String) -> String {
        return map[ext] ?? "plaintext"
    }

    static func displayName(for ext: String) -> String {
        return names[ext] ?? ext.uppercased()
    }

    private static let map: [String: String] = [
        // Systems
        "swift": "swift",
        "m": "objectivec",
        "mm": "objectivec",
        "h": "objectivec",
        "c": "c",
        "cpp": "cpp",
        "cc": "cpp",
        "cxx": "cpp",
        "hpp": "cpp",
        "rs": "rust",
        "go": "go",
        "zig": "zig",

        // Web
        "js": "javascript",
        "mjs": "javascript",
        "cjs": "javascript",
        "jsx": "javascript",
        "ts": "typescript",
        "tsx": "typescript",
        "html": "html",
        "htm": "html",
        "css": "css",
        "scss": "scss",
        "less": "less",
        "vue": "html",
        "svelte": "html",

        // Scripting
        "py": "python",
        "rb": "ruby",
        "php": "php",
        "pl": "perl",
        "lua": "lua",
        "r": "r",
        "R": "r",
        "jl": "julia",

        // JVM
        "java": "java",
        "kt": "kotlin",
        "kts": "kotlin",
        "scala": "scala",
        "groovy": "groovy",
        "gradle": "groovy",
        "clj": "clojure",

        // .NET
        "cs": "csharp",
        "fs": "fsharp",
        "vb": "vbnet",

        // Shell
        "sh": "bash",
        "bash": "bash",
        "zsh": "bash",
        "fish": "bash",
        "ps1": "powershell",
        "bat": "dos",
        "cmd": "dos",

        // Data / Config
        "xml": "xml",
        "toml": "ini",
        "ini": "ini",
        "cfg": "ini",
        "conf": "nginx",
        "nginx": "nginx",
        "dockerfile": "dockerfile",
        "cmake": "cmake",
        "make": "makefile",
        "makefile": "makefile",

        // Functional
        "hs": "haskell",
        "erl": "erlang",
        "ex": "elixir",
        "exs": "elixir",
        "elm": "elm",
        "ml": "ocaml",
        "mli": "ocaml",

        // Other
        "dart": "dart",
        "tf": "hcl",
        "hcl": "hcl",
        "proto": "protobuf",
        "graphql": "graphql",
        "gql": "graphql",
        "v": "verilog",
        "vhdl": "vhdl",
        "asm": "x86asm",
        "s": "x86asm",
        "tex": "latex",
        "latex": "latex",
        "diff": "diff",
        "patch": "diff",
    ]

    private static let names: [String: String] = [
        "swift": "Swift",
        "js": "JavaScript",
        "mjs": "JavaScript",
        "jsx": "JSX",
        "ts": "TypeScript",
        "tsx": "TSX",
        "py": "Python",
        "rb": "Ruby",
        "rs": "Rust",
        "go": "Go",
        "java": "Java",
        "kt": "Kotlin",
        "cs": "C#",
        "cpp": "C++",
        "cc": "C++",
        "c": "C",
        "h": "C/ObjC Header",
        "m": "Objective-C",
        "php": "PHP",
        "sh": "Shell",
        "bash": "Bash",
        "zsh": "Zsh",
        "html": "HTML",
        "css": "CSS",
        "scss": "SCSS",
        "dart": "Dart",
        "scala": "Scala",
        "lua": "Lua",
        "r": "R",
        "jl": "Julia",
        "ex": "Elixir",
        "hs": "Haskell",
        "ml": "OCaml",
        "tf": "Terraform",
        "proto": "Protocol Buffers",
        "graphql": "GraphQL",
    ]
}
