# TODOS

## Fait
- [x] Cible de déploiement → macOS 26.0 (Debug + Release)
- [x] Boutons flottants (Save/Preferences/Logo/Expand/Collapse) → `NSBezelStyleGlass` + SF Symbols, suppression du hack `alphaValue`
- [x] Overlay HUD (spinner de scan) → vrai `NSGlassEffectView` au lieu d'un `CALayer` gris plat
- [x] `CustomRow` → sélection en couleurs système dynamiques (`selectedContentBackgroundColor`) au lieu du branchement manuel `isDarkMode()`
- [x] Build + run + screenshot réel de vérification

## En attente d'arbitrage
- [ ] Assets bitmap `niqText`/`niqLogo` (Assets.xcassets) : toujours le logo texte "NetIQuette" en dur dans une image PNG — visible dans le toolbar et les fenêtres About/Update/Preferences. Sans lien direct avec Liquid Glass, mais incohérent avec le rebrand NetworkMonitor. À refaire (texte réel ou nouvel asset) si voulu.
- [ ] Page de documentation NetworkMonitor (structure inspirée de la page Netiquette d'Objective-See, contenu/branding propres) — pas commencée, en attente de screenshots définitifs de l'UI.

## Hors périmètre (voir PLAN.md)
- Pas de `NSGlassEffectContainerView` pour fusionner les boutons flottants (pas de bénéfice visible ici).
- Pas de retouche des fenêtres secondaires au-delà de l'héritage automatique du glass via le SDK 26.
