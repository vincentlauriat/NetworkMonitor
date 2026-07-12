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

## En attente d'arbitrage
- Aucun point ouvert pour l'instant.

## Hors périmètre (voir PLAN.md)
- Pas de `NSGlassEffectContainerView` pour fusionner les boutons flottants (pas de bénéfice visible ici).
- Pas de retouche des fenêtres secondaires au-delà de l'héritage automatique du glass via le SDK 26.
