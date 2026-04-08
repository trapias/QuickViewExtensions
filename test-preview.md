# Test easyMDView

Questo file testa la preview Markdown formattata.

## Formattazione testo

Testo **bold**, *italic*, ~~barrato~~ e `codice inline`.

Un [link a Google](https://google.com) e del testo normale.

## Blockquote

> Questa è una citazione con **formattazione** interna.
> Può avere più righe.

## Lista

- Primo elemento
- Secondo elemento
  - Sotto-elemento
  - Altro sotto-elemento
- Terzo elemento

## Tabella

| Servizio | URL | Stato |
|----------|-----|-------|
| **Web App** | https://localhost:8090 | Attivo |
| **Database** | localhost:5433 | Attivo |
| **Cache** | localhost:6379 | Attivo |

## Blocco di codice

```swift
struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .padding()
    }
}
```

## Diagramma Mermaid

```mermaid
graph TD
    A[File .md] --> B[MarkdownParser]
    B --> C[HTML]
    C --> D[HTMLTemplate + CSS]
    D --> E[Quick Look Preview]
    E --> F{Mermaid?}
    F -->|Sì| G[mermaid.js rendering]
    F -->|No| H[Visualizzazione diretta]
```

## Sequence Diagram

```mermaid
sequenceDiagram
    participant U as Utente
    participant F as Finder
    participant QL as Quick Look
    participant E as easyMDView

    U->>F: Seleziona file .md
    U->>F: Preme Spazio
    F->>QL: Richiede preview
    QL->>E: providePreview()
    E->>E: Parse Markdown → HTML
    E-->>QL: QLPreviewReply (HTML)
    QL-->>F: Mostra preview
```

---

*Fine del test.*
