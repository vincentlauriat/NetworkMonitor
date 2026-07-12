# TODOS

## Fait
- [x] Cible de déploiement → macOS 26.0 (Debug + Release)
- [x] Boutons flottants (Save/Preferences/Logo/Expand/Collapse) → `NSBezelStyleGlass` + SF Symbols, suppression du hack `alphaValue`
- [x] Overlay HUD (spinner de scan) → vrai `NSGlassEffectView` au lieu d'un `CALayer` gris plat
- [x] `CustomRow` → sélection en couleurs système dynamiques (`selectedContentBackgroundColor`) au lieu du branchement manuel `isDarkMode()`
- [x] Build + run + screenshot réel de vérification

## Fait (suite)
- [x] Wordmark "NetIQuette" (asset `niqText`) remplacé par un vrai `NSTextField` "NetworkMonitor" (Menlo-Bold) dans MainMenu/AboutWindow/Preferences/UpdateWindow — plus de dépendance à une image bitmap pour le nom du produit
- [x] Bouton "Logo" (ouvre `PRODUCT_URL`) : logo Objective-See ("apple-eye") retiré du xib, remplacé par le pictogramme signpost (`niqLogo`, même asset que l'AppIcon) en fallback statique + SF Symbol "globe" à l'exécution
- [x] Imagesets `niqText`, `Logo`, `LogoBG` supprimés du projet (plus référencés)
- [x] Build + run + screenshot de vérification après rebrand

- [x] Page de documentation NetworkMonitor (`docs/index.html`, structure inspirée de la page Netiquette d'Objective-See, contenu/branding propres, capture d'écran réelle embarquée) + lien depuis `README.md`

## Fait (Phase 2 — dashboard UX)
- [x] **Bug critique corrigé** : `self.window` (hérité de `NSOutlineView`, jamais nil-checké) était toujours `nil` car `TableViewController` n'est jamais inséré dans la hiérarchie de vues → les 5 boutons flottants n'avaient en réalité jamais reçu le style Liquid Glass de la Phase 1. Toutes les résolutions de fenêtre passent maintenant par `self.outlineView.window`. Vérifié par `NSLog`+`log show`, puis par capture d'écran ciblée sur le `CGWindowID` réel.
- [x] Bande de statistiques "at a glance" (Connections/Established/Listening/Bytes Up/Bytes Down) au-dessus du tableau, cartes en matériau translucide, inspirée de MacInside/ClaudeCodeUsage
- [x] Badges d'état colorés dans la colonne "State" (point + texte, vert/bleu/jaune/gris/orange selon l'état TCP)
- [x] Build + run + capture d'écran de vérification (boutons glass + bande de stats + badges, confirmés visuellement)

## Fait (Phase 3 — typographie, retour "Menlo trop présente")
- [x] Polices Menlo (partout : table, wordmark, boutons, fenêtres secondaires) remplacées par **Geist** (chrome/UI) et **Geist Mono** (données tabulaires de la table de connexions), inspiration RTKInfos — fichiers embarqués (`NetworkMonitor/Fonts/Geist.ttf`, `GeistMono.ttf`, licence OFL), enregistrés au lancement via `registerCustomFonts()` dans `main.m` (avant `NSApplicationMain`)
- [x] Ajout du groupe `Fonts` au projet Xcode (via le gem `xcodeproj`, diff minimal) — piège rencontré : le groupe créé sans `path` faisait pointer Xcode vers `NetworkMonitor/Geist.ttf` au lieu de `NetworkMonitor/Fonts/Geist.ttf`, corrigé en fixant `path = Fonts` sur le groupe
- [x] Bande de stats (cartes construites en code) basculée sur `Geist-Medium`/`Geist-SemiBold` avec repli sur la police système si la police n'est pas enregistrée
- [x] Build + run + capture d'écran de vérification (table + fenêtre Préférences)

## Fait (Phase 4 — allègement des boutons flottants)
- [x] Les 5 boutons flottants (Save/Preferences/Logo/Expand/Collapse) sont passés du bezel `NSBezelStyleGlass` à un style **borderless** (icône SF Symbol seule, `contentTintColor = secondaryLabelColor`, image en template) — le SDK 26 n'expose qu'un seul style de glass bezel (pas de variante plus légère), et ces boutons reposent sur le fond plat de la fenêtre (pas sur le contenu défilant), donc le style plat (inspiration RTKInfos) reste lisible sans plaque de fond
- [x] Build + run + capture d'écran de vérification

## En attente d'arbitrage
- Refonte du header/toolbar (inspiration `HeaderView` de ClaudeCodeUsage) — jugée moins prioritaire, pas encore traitée.

## Hors périmètre (voir PLAN.md)
- Pas de `NSGlassEffectContainerView` pour fusionner les boutons flottants (pas de bénéfice visible ici).
- Pas de retouche des fenêtres secondaires au-delà de l'héritage automatique du glass via le SDK 26.
