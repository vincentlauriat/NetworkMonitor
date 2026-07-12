# PLAN — Liquid Glass UX + nouvelle page de doc

## Contexte
- Suite au renommage Netiquette → NetworkMonitor, deux demandes :
  1. Construire une nouvelle page de documentation produit, en utilisant https://objective-see.org/products/netiquette.html comme référence de structure (pas de copie de branding/contenu Objective-See).
  2. Adopter le langage visuel **Liquid Glass** d'Apple (macOS 26 "Tahoe") pour l'UX de l'app.
- Décision utilisateur : on **bascule la cible de déploiement sur macOS 26+** (abandon du support < 26) plutôt que de maintenir deux chemins visuels avec `#available`.

## Vérifications faites avant d'écrire du code
- SDK réel inspecté (`MacOSX27.0.sdk` fourni par Xcode-beta) : `NSGlassEffectView`, `NSGlassEffectContainerView` (`NSGlassEffectView.h`, macos(26.0)+), `NSBezelStyleGlass` (`NSButtonCell.h`, macos(26.0)+) confirmés — pas de reconstruction depuis la mémoire d'entraînement.
- Inventaire de l'UI existante (AppKit/XIB pur, pas de SwiftUI) :
  - `MainMenu.xib` : fenêtre avec `NSToolbar` standard (logo + recherche) → adoption automatique du glass en rebuildant contre le SDK 26, pas de changement nécessaire côté toolbar/titlebar.
  - 5 boutons flottants custom au-dessus du contenu (Logo/Save/Preferences/Expand/Contract) : bezel "regularSquare"/"rounded" + bitmaps clair/sombre faites main + `alphaValue` 0.7-0.8 pour simuler la transparence → candidats directs au vrai bezel `NSBezelStyleGlass` + SF Symbols.
  - `overlay` (HUD du spinner "Enumerating Network Connections...") : fond `CALayer` gris plat (`NSColor.lightGrayColor`) avec coins arrondis → candidat direct à `NSGlassEffectView`.
  - `CustomRow.m` : dessin de sélection avec branchement manuel `isDarkMode()` et gris calibrés en dur → à remplacer par des couleurs système dynamiques (plus la peine de gérer le light/dark à la main).

## Plan d'exécution
1. **Build** : `MACOSX_DEPLOYMENT_TARGET` → `26.0` (Debug + Release) dans `project.pbxproj`.
2. **Boutons flottants** (`TableViewController.m`) : localisation par tag dans `self.window.contentView.subviews` (pas de nouvel IBOutlet, pas d'édition XML du xib — trop risqué à la main), passage en `NSBezelStyleGlass`, remplacement des bitmaps par des SF Symbols, suppression du hack `alphaValue`.
3. **Overlay HUD** : remplacement du fond `CALayer` par un vrai `NSGlassEffectView` (style `Regular`, `cornerRadius` conservé à 20).
4. **CustomRow** : sélection redessinée avec des couleurs système dynamiques au lieu du branchement `isDarkMode()` manuel.
5. **Build + run + screenshot** réel pour vérification visuelle (pas de claim sans preuve).
6. **Page de doc** : nouvelle page HTML (Artifact), structure inspirée de la page Netiquette (fonctionnalités, système requis, usage CLI/GUI) mais contenu et branding propres à NetworkMonitor, captures d'écran réelles une fois le redesign vérifié.

## Hors périmètre (assumé, à confirmer si besoin)
- Pas de fusion des boutons dans un `NSGlassEffectContainerView` (optimisation de perf/rendu quand plusieurs vues glass sont proches) — chaque bouton en `NSBezelStyleGlass` individuel est déjà une adoption légitime, le container ajoute de la complexité de re-parenting dans le xib sans bénéfice visible ici.
- Pas de retouche des fenêtres secondaires (About/Prefs/Update) au-delà du bump de cible — leur chrome standard hérite du glass automatiquement.

## Phase 2 — UX dashboard (retour "pas au rendez-vous", inspiration MacInside / ClaudeCodeUsage)

### Bug critique trouvé en cours de route
`TableViewController` hérite de `NSOutlineView` mais n'est **jamais inséré dans la hiérarchie de vues** (c'est un `customObject` pur dans le xib, seulement utilisé comme delegate/datasource — le vrai outline visible est `self.outlineView`, un outlet séparé). Conséquence : `self.window` (hérité de `NSView`) était **toujours `nil`**, donc `applyGlassStyleToFloatingButtons` ne faisait **rien** depuis le début — les 5 boutons flottants n'ont jamais reçu le style glass, malgré la vérification (visuelle, mais insuffisante) de la Phase 1. Vérifié empiriquement via un `NSLog` temporaire + `log show` : `self.window = (null)` / `self.outlineView.window` non-nil. C'est très probablement la vraie cause du "l'UX n'est pas au rendez-vous".
- **Fix** : toutes les résolutions de fenêtre dans `TableViewController.m` passent maintenant par `self.outlineView.window` (ou `self.scrollView.superview` quand seul le conteneur est nécessaire), jamais par `self.window`.
- Revérifié par capture d'écran ciblée sur le `CGWindowID` réel de l'app (`screencapture -l<id>`, robuste à l'occlusion par d'autres fenêtres — contrairement à `-R<geometry>` qui capture une zone d'écran et peut inclure une fenêtre superposée d'une autre session).

### Inspiration retenue (MacInside, ClaudeCodeUsage — SwiftUI, traduite en AppKit pur/frames manuels)
- **Bande de stats "at a glance"** au-dessus du tableau : 5 cartes (`Connections`, `Established`, `Listening`, `Bytes Up`, `Bytes Down`), matériau translucide (`NSVisualEffectView` + bordure hairline 8% + coins 10pt), légende en petites majuscules + gros chiffre arrondi en dessous — inspiré de `StatCardView` (ClaudeCodeUsage) / `MetricCard` (MacInside). Recalculée à chaque `-update:` à partir de `self.processedItems` (donc reflète le filtre actif).
- **Badge d'état coloré** dans la colonne "State" : point coloré + texte (vert=Established, bleu=Listen, jaune=Syn*, gris=Closed, orange=autres états de fermeture) — inspiré du pattern `LegendRow` de MacInside. Les lignes UDP (sans `tcpState`) restent sans badge, comme avant.
- Construction en frames manuels + `autoresizingMask` (pas d'Auto Layout/`NSStackView`) pour rester cohérent avec le reste du fichier, qui est entièrement en layout par frame. La bande se reflow via une notification `NSViewFrameDidChangeNotification` sur son propre frame (redimensionnement fenêtre).
- Hors scope pour l'instant : refonte du header/toolbar (jugée moins prioritaire que la bande de stats et les badges).
