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
