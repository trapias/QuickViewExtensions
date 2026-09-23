# QuickViewExtensions - Installazione

## Installazione

1. Trascina **easyQuickView.app** nella cartella **Applications**.
2. Apri **easyQuickView** da Applications una volta per registrare le estensioni Quick Look.
3. Se macOS blocca l'apertura, vai in **Impostazioni di Sistema → Privacy e sicurezza** e scegli **Apri comunque** per easyQuickView, poi conferma. Il pulsante compare dopo un tentativo di apertura e resta disponibile per circa un'ora.
4. Chiudi l'app, seleziona un file supportato nel Finder e premi **Spazio**.

Il DMG non è autenticato da Apple (notarizzato). Solo se ti fidi della copia ricevuta e macOS continua a bloccarla, puoi rimuovere l'attributo di quarantena dall'app installata nel Terminale e riprovare ad aprirla:

       xattr -dr com.apple.quarantine /Applications/easyQuickView.app

Rimuovere la quarantena non corregge una firma non valida o un'app danneggiata.

## Utilizzo

Seleziona un file **.md** nel Finder e premi **Spazio** per vedere la preview formattata.

Supporta: headings, tabelle, code blocks, blockquote, liste, link, immagini e diagrammi Mermaid.

## Disinstallazione

Sposta easyQuickView.app da Applications nel Cestino.
