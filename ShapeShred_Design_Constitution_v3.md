# 🏛️ **ShapeShred Enterprise UX/UI & Design System Constitution v3.0**

> **"We engineer digital discipline. Every pixel is a promise."**

---

## 📋 **Part 1: Product Design Philosophy**

### **Vision Statement**
ShapeShred is not a workout tracker. It is a **monochromatic sanctuary of physical mastery** — where discipline meets digital refinement. Every interaction is an act of intentional design. Every screen breathes with the confidence of a world-class fitness experience.

### **Core Design Principles**

| Principle | Definition | Manifestation |
| :--- | :--- | :--- |
| **Discipline** | Absolute restraint in visual language. | No decorative elements. No arbitrary colors. No visual noise. |
| **Power** | Authority through contrast and hierarchy. | Bold typography against negative space. Confident scale relationships. |
| **Luxury** | Refined minimalism that feels expensive. | Generous whitespace. Subtle micro-interactions. Premium material metaphors. |
| **Minimalism** | Every element earns its existence. | If it doesn't serve the user, it doesn't exist. |
| **Focus** | Surgical attention guidance. | One primary action per view. Clear information hierarchy. |
| **Precision** | Mathematical consistency. | 8-point grid. Tokenized everything. Zero magic numbers. |
| **Confidence** | Unapologetic design decisions. | Strong typographic hierarchy. Decisive spacing. No hesitation. |
| **Trust** | Professional execution at every touchpoint. | Predictable patterns. Polished states. Reliable feedback. |
| **Professionalism** | No amateur compromises. | Custom components only. Zero generic Flutter defaults. |
| **Technology** | Forward-thinking platform mastery. | Native capabilities embraced. Performance-first architecture. |

---

### **Design Psychology Framework**

| Psychological Principle | UX Application | UI Manifestation |
| :--- | :--- | :--- |
| **Motivation** | Immediate reward feedback, clear progress visualization. | Animated progress rings. Streak counters with haptic celebration. |
| **Habit Formation** | Daily streaks, consistent triggers, contextual nudges. | Smart notification design. Contextual quick actions. |
| **Progress Perception** | Visual growth indicators, milestone celebrations. | Animated stat cards. Achievement unlock sequences. |
| **Reduced Anxiety** | Clear next steps, predictable interactions, supportive feedback. | Skeleton loading states. Helpful empty states. Gentle error recovery. |
| **Confidence Building** | Celebrate small wins, progressive challenges, skill mastery. | Micro-achievements. Skill trees. Progressive difficulty indicators. |
| **Retention** | Daily engagement loops, meaningful progress, community connection. | Personalized dashboards. Social proof elements. |

---

### **Design Constraints — Absolute Rules**

| Category | Constraint | Violation Consequence |
| :--- | :--- | :--- |
| **Color** | **White, Light Gray, Dark Gray ONLY.** Black reserved for shadows, borders, and micro-details (≤2% of surface area). | Any color introduction breaks brand identity. |
| **Typography** | Theme Extensions ONLY. No direct font access. No system defaults. | Ensures consistent typographic voice across all screens. |
| **Spacing** | Strict 8-point grid. No arbitrary values. Ever. | Guarantees mathematical harmony and predictability. |
| **Radius** | Semantic tokens only. No hardcoded values. | Maintains consistent surface language. |
| **Elevation** | Semantic levels only. No hardcoded shadows. | Creates predictable depth hierarchy. |
| **Motion** | Every animation must communicate hierarchy or state change. | Prevents decorative animation pollution. |
| **Accessibility** | WCAG AA minimum. Mandatory, not optional. | Legal compliance and inclusive design. |
| **Touch Targets** | Minimum 48dp for interactive elements. No exceptions. | Usability and accessibility compliance. |
| **Responsive** | Small Phones → Tablets → Foldables. Fluid layouts. | Universal experience quality. |

---

## 🎨 **Part 2: Design Tokens System**

### **Color System — Monochromatic Mastery**

```dart
// ═══════════════════════════════════════════════════════════════
// PRIMARY PALETTE — The Soul of ShapeShred
// ═══════════════════════════════════════════════════════════════

// Pure White — Primary surface, cards, content backgrounds
ColorPalette.pureWhite     = #FFFFFF

// Light Gray Spectrum — Secondary surfaces, subtle differentiation
ColorPalette.gray50        = #FAFAFA   // Ultra-light backgrounds
ColorPalette.gray100       = #F5F5F5   // Card backgrounds, input fields
ColorPalette.gray200       = #EEEEEE   // Dividers, subtle borders
ColorPalette.gray300       = #E0E0E0   // Disabled states, inactive elements

// Dark Gray Spectrum — Primary text, active elements, emphasis
ColorPalette.gray400       = #BDBDBD   // Placeholder text, tertiary content
ColorPalette.gray500       = #9E9E9E   // Secondary text, icons (inactive)
ColorPalette.gray600       = #757575   // Secondary text, descriptions
ColorPalette.gray700       = #616161   // Primary text (light backgrounds)
ColorPalette.gray800       = #424242   // Headlines, primary actions
ColorPalette.gray900       = #212121   // Maximum emphasis text

// Absolute Black — SHADOWS, BORDERS, MICRO-DETAILS ONLY
// Usage: ≤2% of any screen surface area
ColorPalette.absoluteBlack = #000000   // Elevation shadows, hairline borders, icon strokes

// ═══════════════════════════════════════════════════════════════
// SEMANTIC COLORS — Monochromatic Interpretation
// We do NOT use chromatic accents. Semantic meaning is conveyed
// through shade intensity and iconography, not hue.
// ═══════════════════════════════════════════════════════════════

SemanticColors.success     = #212121   // Darkest gray — achievement, completion
SemanticColors.warning     = #616161   // Medium gray — caution, attention needed
SemanticColors.danger      = #424242   // Dark gray — error, destructive (with icon context)
SemanticColors.info        = #757575   // Gray — informational, neutral guidance

// ═══════════════════════════════════════════════════════════════
// SURFACE HIERARCHY — How colors stack
// ═══════════════════════════════════════════════════════════════

SurfaceLevel.background    = #FFFFFF   // App background
SurfaceLevel.elevated      = #FAFAFA   // Cards, sheets, dialogs
SurfaceLevel.pressed       = #F5F5F5   // Pressed states, hover
SurfaceLevel.dragged       = #EEEEEE   // Dragged/reordered items
SurfaceLevel.selected      = #E0E0E0   // Selected states, active chips

// ═══════════════════════════════════════════════════════════════
// TEXT HIERARCHY — Contrast-driven readability
// ═══════════════════════════════════════════════════════════════

TextColor.primary          = #212121   // Headlines, primary content (on white)
TextColor.secondary        = #616161   // Descriptions, labels
TextColor.tertiary         = #9E9E9E   // Metadata, timestamps
TextColor.disabled         = #BDBDBD   // Unavailable content
TextColor.inverse          = #FFFFFF   // Text on dark surfaces
TextColor.inverseSecondary = #E0E0E0  // Secondary text on dark surfaces

// ═══════════════════════════════════════════════════════════════
// BORDER & DIVIDER SYSTEM
// ═══════════════════════════════════════════════════════════════

BorderColor.subtle         = #EEEEEE   // Hairline dividers
BorderColor.default        = #E0E0E0   // Input borders, card outlines
BorderColor.strong         = #BDBDBD   // Focused states, emphasized borders
BorderColor.inverse        = #424242   // Borders on light elements
```

---

### **Typography System**

```dart
// ═══════════════════════════════════════════════════════════════
// TYPOGRAPHY HIERARCHY — Refined, Not Default
// ═══════════════════════════════════════════════════════════════

// Display Scale — Maximum impact, minimum usage
TypographyTokens.displayLarge   = 57sp / 64sp line-height / w700 / letter-spacing: -0.25
TypographyTokens.displayMedium  = 45sp / 52sp line-height / w700 / letter-spacing: -0.25
TypographyTokens.displaySmall   = 36sp / 44sp line-height / w700 / letter-spacing: 0

// Headline Scale — Section anchors, major transitions
TypographyTokens.headlineLarge  = 32sp / 40sp line-height / w600 / letter-spacing: 0
TypographyTokens.headlineMedium = 28sp / 36sp line-height / w600 / letter-spacing: 0
TypographyTokens.headlineSmall  = 24sp / 32sp line-height / w600 / letter-spacing: 0

// Title Scale — Card headers, list sections, modal titles
TypographyTokens.titleLarge     = 22sp / 28sp line-height / w500 / letter-spacing: 0
TypographyTokens.titleMedium    = 16sp / 24sp line-height / w500 / letter-spacing: 0.15
TypographyTokens.titleSmall     = 14sp / 20sp line-height / w500 / letter-spacing: 0.1

// Body Scale — Primary reading content
TypographyTokens.bodyLarge      = 16sp / 24sp line-height / w400 / letter-spacing: 0.5
TypographyTokens.bodyMedium     = 14sp / 20sp line-height / w400 / letter-spacing: 0.25
TypographyTokens.bodySmall      = 12sp / 16sp line-height / w400 / letter-spacing: 0.4

// Label Scale — Interactive elements, buttons, chips
TypographyTokens.labelLarge     = 14sp / 20sp line-height / w600 / letter-spacing: 0.1
TypographyTokens.labelMedium    = 12sp / 16sp line-height / w600 / letter-spacing: 0.5
TypographyTokens.labelSmall     = 11sp / 16sp line-height / w600 / letter-spacing: 0.5

// Auxiliary Scale — Supporting information
TypographyTokens.caption        = 12sp / 16sp line-height / w400 / letter-spacing: 0.4
TypographyTokens.overline       = 10sp / 16sp line-height / w500 / letter-spacing: 1.5 / UPPERCASE

// ═══════════════════════════════════════════════════════════════
// TYPOGRAPHY RULES
// ═══════════════════════════════════════════════════════════════

Rule 1: Never use font size < 10sp
Rule 2: Never use font weight < w400 (except overline at w500)
Rule 3: Display text uses negative letter-spacing for tighter headlines
Rule 4: Body text uses positive letter-spacing for readability
Rule 5: All caps ONLY for overline and button labels
Rule 6: Maximum 3 font sizes per screen
Rule 7: Line height must be ≥ 1.5× font size for body text
```

---

### **Spacing System**

```dart
// ═══════════════════════════════════════════════════════════════
// 8-POINT GRID — Mathematical Precision
// ═══════════════════════════════════════════════════════════════

// Base Grid
SpacingTokens.space0   = 0.0
SpacingTokens.space4   = 4.0    // Micro-adjustments only
SpacingTokens.space8   = 8.0    // Tight element grouping
SpacingTokens.space12  = 12.0   // Compact component padding
SpacingTokens.space16  = 16.0   // Default component padding
SpacingTokens.space20  = 20.0   // Relaxed component padding
SpacingTokens.space24  = 24.0   // Section internal padding
SpacingTokens.space32  = 32.0   // Section separation
SpacingTokens.space40  = 40.0   // Major section breaks
SpacingTokens.space48  = 48.0   // Screen edge padding (compact)
SpacingTokens.space64  = 64.0   // Screen edge padding (default)
SpacingTokens.space80  = 80.0   // Hero section padding
SpacingTokens.space96  = 96.0   // Maximum section separation
SpacingTokens.space128 = 128.0  // Extreme separation (rare)

// Semantic Spacing — Contextual application
SpacingTokens.contentPadding   = space16    // Inside cards, inputs, buttons
SpacingTokens.screenPadding    = space24    // Horizontal screen margins
SpacingTokens.sectionSpacing   = space32    // Between major content sections
SpacingTokens.componentSpacing = space12    // Between related components
SpacingTokens.elementSpacing   = space8     // Between related elements
SpacingTokens.textSpacing      = space4     // Between text lines in tight groups

// ═══════════════════════════════════════════════════════════════
// SPACING RULES
// ═══════════════════════════════════════════════════════════════

Rule 1: Never use arbitrary spacing values. Always use tokens.
Rule 2: Vertical rhythm follows 8-point increments exclusively.
Rule 3: Horizontal padding is always symmetric (left = right).
Rule 4: Card internal padding = space16 (compact) or space20 (comfortable).
Rule 5: Between unrelated sections = minimum space32.
Rule 6: Touch target separation = minimum space8.
```

---

### **Border Radius System**

```dart
// ═══════════════════════════════════════════════════════════════
// RADIUS TOKENS — Surface Language
// ═══════════════════════════════════════════════════════════════

RadiusTokens.radiusNone   = 0.0     // Full-bleed content, data tables
RadiusTokens.radiusTiny   = 4.0     // Micro-components: tags, chips, badges
RadiusTokens.radiusSmall  = 8.0     // Compact components: small buttons, input fields
RadiusTokens.radiusMedium = 12.0    // Standard components: cards, medium buttons
RadiusTokens.radiusLarge  = 16.0    // Prominent components: modals, sheets, large cards
RadiusTokens.radiusXL     = 24.0    // Hero elements: feature cards, onboarding slides
RadiusTokens.radiusPill   = 999.0   // Buttons, chips, search bars
RadiusTokens.radiusCircle = double.infinity  // Avatars, profile images, status indicators

// ═══════════════════════════════════════════════════════════════
// RADIUS RULES
// ═══════════════════════════════════════════════════════════════

Rule 1: Cards use radiusMedium (12dp) or radiusLarge (16dp).
Rule 2: Buttons use radiusPill (999dp) for primary actions.
Rule 3: Input fields use radiusSmall (8dp).
Rule 4: Bottom sheets use radiusLarge (16dp) top corners only.
Rule 5: Modals use radiusLarge (16dp) all corners.
Rule 6: Avatars ALWAYS use radiusCircle.
Rule 7: Never mix more than 2 radius values on the same screen.
```

---

### **Elevation System — Shadow-First Architecture**

```dart
// ═══════════════════════════════════════════════════════════════
// ELEVATION TOKENS — Depth Through Shadow, Not Color
// Black is used EXCLUSIVELY here for shadow rendering
// ═══════════════════════════════════════════════════════════════

ElevationTokens.level0    = BoxShadow(offset: Offset(0, 0),  blurRadius: 0,  spreadRadius: 0,  color: transparent)
                          // Flat surfaces, backgrounds

ElevationTokens.level1    = BoxShadow(offset: Offset(0, 1),  blurRadius: 2,  spreadRadius: 0,  color: #000000.withOpacity(0.04))
                          // Subtle lift: resting cards, inactive buttons

ElevationTokens.level2    = BoxShadow(offset: Offset(0, 2),  blurRadius: 4,  spreadRadius: 0,  color: #000000.withOpacity(0.06))
                          // Gentle elevation: active cards, dropdowns

ElevationTokens.level3    = BoxShadow(offset: Offset(0, 4),  blurRadius: 8,  spreadRadius: 0,  color: #000000.withOpacity(0.08))
                          // Standard elevation: floating buttons, menus

ElevationTokens.level4    = BoxShadow(offset: Offset(0, 8),  blurRadius: 16, spreadRadius: 0,  color: #000000.withOpacity(0.10))
                          // Prominent elevation: dialogs, bottom sheets

ElevationTokens.floating  = BoxShadow(offset: Offset(0, 12), blurRadius: 24, spreadRadius: 0,  color: #000000.withOpacity(0.12))
                          // Maximum standard elevation: FAB, speed dial

ElevationTokens.modal     = BoxShadow(offset: Offset(0, 16), blurRadius: 32, spreadRadius: 0,  color: #000000.withOpacity(0.14))
                          // Modal overlays: full-screen dialogs, premium prompts

ElevationTokens.overlay   = BoxShadow(offset: Offset(0, 24), blurRadius: 48, spreadRadius: 0,  color: #000000.withOpacity(0.16))
                          // Maximum elevation: paywall, critical alerts

// ═══════════════════════════════════════════════════════════════
// ELEVATION RULES
// ═══════════════════════════════════════════════════════════════

Rule 1: Elevation communicates Z-axis hierarchy. Never decorative.
Rule 2: Black shadows ONLY. No colored shadows. Ever.
Rule 3: Opacity increases with elevation level, never exceeds 0.16.
Rule 4: Combined with subtle Y-offset for natural light direction.
Rule 5: Dark mode uses reduced opacity (multiply by 0.6).
```

---

### **Motion System — Intentional Animation**

```dart
// ═══════════════════════════════════════════════════════════════
// ANIMATION DURATIONS — Perceived Performance
// ═══════════════════════════════════════════════════════════════

DurationTokens.instant    = 100ms   // Micro-feedback: button press, checkbox toggle
DurationTokens.short      = 200ms   // Standard transitions: opacity, color, scale
DurationTokens.medium     = 300ms   // Structural changes: height, width, position
DurationTokens.long       = 400ms   // Screen transitions, modal entrance
DurationTokens.extended   = 600ms   // Hero animations, complex choreography
DurationTokens.cinematic  = 800ms   // Onboarding, premium reveals (rare)

// ═══════════════════════════════════════════════════════════════
// ANIMATION CURVES — Premium Physics
// ═══════════════════════════════════════════════════════════════

CurveTokens.easeStandard     = Curves.easeInOutCubic      // Default: balanced, professional
CurveTokens.easeFast         = Curves.easeOutCubic        // Exit animations: snappy, confident
CurveTokens.easeSlow         = Curves.easeInCubic         // Entrance animations: deliberate
CurveTokens.decelerate       = Curves.decelerate          // Scroll-based, momentum-driven
CurveTokens.accelerate       = Curves.accelerate          // Dismissal, removal
CurveTokens.smoothSpring     = Curves.fastEaseInToSlowEaseOut  // Premium feel: organic, expensive
CurveTokens.sharpSpring      = Curves.fastOutSlowIn      // Button presses, tactile feedback

// ═══════════════════════════════════════════════════════════════
// ANIMATION TYPES — Semantic Motion
// ═══════════════════════════════════════════════════════════════

MotionTokens.fade          // Opacity transitions: 0.0 → 1.0, subtle, elegant
MotionTokens.scale         // Size transitions: 0.95 → 1.0, press feedback, emphasis
MotionTokens.slide         // Position transitions: directional, spatial navigation
MotionTokens.hero          // Shared element: cross-screen continuity
MotionTokens.sharedAxis    // Container transform: parent-child relationships
MotionTokens.crossfade     // Content replacement: smooth state changes
MotionTokens.stagger       // Sequential reveals: list loading, dashboard assembly

// ═══════════════════════════════════════════════════════════════
// MOTION RULES
// ═══════════════════════════════════════════════════════════════

Rule 1: Every animation must communicate hierarchy, state, or spatial relationship.
Rule 2: No animation is decorative. If it doesn't inform, it doesn't exist.
Rule 3: Entrance animations use easeSlow (deliberate arrival).
Rule 4: Exit animations use easeFast (confident departure).
Rule 5: Interactive feedback uses sharpSpring (tactile, responsive).
Rule 6: List items use stagger (50ms delay between items).
Rule 7: Screen transitions use sharedAxis or fade (never slide between unrelated screens).
Rule 8: Loading states use shimmer with 1.5s duration, infinite loop.
Rule 9: Success states use scale + fade (200ms scale up, 100ms fade in).
Rule 10: Error states use subtle shake (8px horizontal, 3 cycles, 300ms total).
```

---

### **Icon System**

```dart
// ═══════════════════════════════════════════════════════════════
// ICON SIZES — Touch-Optimized
// ═══════════════════════════════════════════════════════════════

IconSizes.extraSmall  = 16.0   // Inline text, dense lists
IconSizes.small       = 20.0   // Compact buttons, form fields
IconSizes.medium      = 24.0   // Default: navigation, standard actions
IconSizes.large       = 28.0   // Prominent actions, toolbar icons
IconSizes.extraLarge  = 32.0   // Feature highlights, empty states
IconSizes.hero        = 48.0   // Onboarding, achievement badges

// ═══════════════════════════════════════════════════════════════
// ICON VARIANTS — Semantic Weight
// ═══════════════════════════════════════════════════════════════

IconVariant.outlined  // Navigation, secondary actions, inactive states
IconVariant.filled    // Primary actions, selected states, active navigation
IconVariant.rounded   // Premium feel: buttons, chips, floating actions

// ═══════════════════════════════════════════════════════════════
// ICON RULES
// ═══════════════════════════════════════════════════════════════

Rule 1: Navigation icons = outlined (inactive), filled (active).
Rule 2: Action buttons = filled for primary, outlined for secondary.
Rule 3: Icon color follows text hierarchy: primary/secondary/tertiary/disabled.
Rule 4: Icon + label spacing = space8.
Rule 5: Touch target for icon buttons = 48dp × 48dp minimum.
Rule 6: Never use icons without labels unless universally understood (home, search, settings).
```

---

## 🧩 **Part 3: Component Library Architecture**

### **Component DNA — Every Component Has:**

```
Component
├── Variants
│   ├── Primary     // High emphasis, main action
│   ├── Secondary   // Medium emphasis, supporting action
│   ├── Tertiary    // Low emphasis, subtle action
│   ├── Outline     // Bordered, minimal fill
│   ├── Ghost       // No fill, text only
│   └── Destructive // Special: irreversible actions
├── Sizes
│   ├── Small       // Dense layouts, inline actions
│   ├── Medium      // Default: most common usage
│   └── Large       // Hero actions, prominent CTAs
├── States
│   ├── Default     // Resting state
│   ├── Hover       // Pointer interaction (desktop/web)
│   ├── Pressed     // Active touch/click
│   ├── Focused     // Keyboard navigation
│   ├── Disabled    // Unavailable, reduced opacity
│   ├── Loading     // Async operation in progress
│   └── Success     // Completed action feedback
├── Theme
│   ├── Light       // Default: white/light gray surfaces
│   └── Dark        // Inverted: dark gray surfaces (rare, premium moments)
├── Accessibility
│   ├── Semantic Labels    // TalkBack/VoiceOver descriptions
│   ├── Touch Targets      // ≥48dp guaranteed
│   ├── Focus Indicators   // Visible keyboard focus
│   └── Dynamic Type       // Scales with system settings
└── Animation
    ├── Press Feedback     // Scale 0.97 + shadow reduction (instant)
    ├── State Transitions  // Color/opacity changes (short)
    ├── Loading Indicator  // Skeleton or circular progress
    └── Success Feedback   // Scale bounce + checkmark reveal
```

---

### **Component Library — Complete Inventory**

| Category | Components | Design Notes |
| :--- | :--- | :--- |
| **Buttons** | Primary, Secondary, Tertiary, Outline, Ghost, FAB, Icon Button, Toggle Button | Pill radius for primary. SharpSpring press feedback. |
| **Cards** | Workout Card, Nutrition Card, Progress Card, Stat Card, Achievement Card | radiusMedium, level2 elevation, space16 padding. |
| **Inputs** | Text Field, OTP Field, Password Field, Search Bar, Text Area | radiusSmall, subtle border, focused = borderColor.strong. |
| **Selections** | Checkbox, Radio, Switch, Dropdown, Slider, Segmented Control | Custom drawables, no platform defaults. |
| **Feedback** | Snackbar, Dialog, Bottom Sheet, Toast, Banner | Snackbar = bottom, slide up. Dialog = center, scale in. |
| **Indicators** | Progress Bar, Circular Progress, Skeleton, Shimmer, Stepper | Skeleton = shimmer animation, 1.5s cycle. |
| **Charts** | Line Chart, Bar Chart, Radial Chart, Progress Ring, Sparkline | Monochromatic: shade intensity represents value. |
| **Navigation** | Bottom Nav, Tab Bar, App Bar, Back Gesture, Breadcrumbs | Bottom nav = 4 tabs max. Icons + labels. |
| **Data Display** | Badge, Tag, Chip, Avatar, Statistic, Data Table, List Tile | Chips = radiusPill, space8 padding. |
| **Loading** | Shimmer Skeleton, Circular Spinner, Linear Progress, Pulsing Dot | Full-screen = skeleton layout. Inline = pulsing dot. |
| **Empty States** | Empty, Error, Success, No Data, No Connection | Custom illustration + action button + helpful copy. |
| **Premium** | Paywall, Subscription Card, Feature List, Trial Banner | radiusLarge, level4 elevation, generous spacing. |
| **Coach** | Chat Message, Task Item, Report Card, Insight Card | Chat = asymmetric layout, avatar + bubble. |
| **Workout** | Exercise Card, Workout Progress, Timer Display, Set Logger | Timer = monospaced digits, large display size. |
| **Nutrition** | Meal Card, Macro Ring, Water Tracker, Calorie Bar | Macro rings = concentric circles, shade intensity. |
| **Social** | Streak Counter, Leaderboard Row, Achievement Badge | Streak = fire icon (outlined inactive, filled active). |

---

## 📱 **Part 4: Screen Architecture**

### **Screen Structure Pattern — The ShapeShred Scaffold**

```dart
Screen
├── Scaffold
│   ├── AppBar (Custom, Collapsible)
│   │   ├── Leading          // Back button or menu icon
│   │   ├── Title            // Screen name or contextual title
│   │   ├── Actions          // Up to 2 icon buttons
│   │   └── Bottom (Optional) // Tab bar or filter chips
│   ├── Body
│   │   ├── State Management (BLoC Pattern)
│   │   │   ├── Initial    → Splash/Shimmer
│   │   │   ├── Loading    → Skeleton Screen (full layout)
│   │   │   ├── Error      → Error Screen (illustration + retry)
│   │   │   ├── Empty      → Empty State (illustration + CTA)
│   │   │   └── Loaded     → Content (staggered fade-in)
│   ├── BottomSheet (Optional) // Contextual actions, forms
│   ├── FloatingActionButton (Optional) // Primary action, radiusPill
│   └── BottomNavigationBar // 4 tabs max, icons + labels
```

---

### **Onboarding Flow — Cinematic Discipline**

```
Splash Screen (1.5s max)
    ├── Logo reveal: scale 0.8 → 1.0, fade 0 → 1, 600ms, smoothSpring
    ├── Tagline fade in: 200ms delay, 400ms duration
    └── Auto-advance or tap to continue
    ↓
Onboarding Carousel (3 Pages, swipeable)
    ├── Page 1: "Train Anytime, Anywhere"
    │   ├── Visual: Monochromatic workout illustration
    │   ├── Headline: displaySmall
    │   ├── Body: bodyLarge, gray600
    │   └── Progress indicator: 3 dots, active = filled
    ├── Page 2: "AI-Powered Progress"
    │   ├── Visual: Abstract data visualization
    │   ├── Headline: displaySmall
    │   └── Body: bodyLarge, gray600
    ├── Page 3: "Your Personal Coach"
    │   ├── Visual: Coach avatar + chat interface preview
    │   ├── Headline: displaySmall
    │   ├── Body: bodyLarge, gray600
    │   └── Primary CTA: "Get Started" (full-width, radiusPill)
    └── Skip button: top-right, ghost style, labelSmall
    ↓
Authentication Gateway
    ├── Login Tab / Signup Tab (segmented control)
    ├── Social auth buttons (outline style)
    └── Email/password form (compact, space16 gaps)
    ↓
Main App (Home Dashboard)
```

**Onboarding Rules:**
- Rule 1: Total onboarding time ≤ 45 seconds.
- Rule 2: No more than 3 onboarding pages.
- Rule 3: Each page has ONE message. No information overload.
- Rule 4: CTA is always visible, never below fold.
- Rule 5: Skip is always available (respect user autonomy).
- Rule 6: Illustrations are custom, monochromatic, premium quality.

---

### **Main Navigation Flow — The Four Pillars**

```
Bottom Navigation (4 Tabs — No More, No Less)
├── 🏠 Home (Dashboard)
│   ├── Today's Workout Card    // P0: Immediate action, full-width
│   ├── Daily Stats Row         // P1: 3-column grid (Calories, Minutes, Exercises)
│   ├── Quick Actions Bar       // P2: Horizontal scroll, 3-4 actions
│   ├── Recommended Workouts    // P3: Horizontal carousel, workout cards
│   └── Motivational Element    // P4: Streak counter or quote
│
├── 💪 Training
│   ├── Category Grid           // 6 categories, 2×3 grid
│   ├── Recent Workouts         // Vertical list, compact cards
│   ├── Weekly Schedule         // Calendar strip, horizontal scroll
│   └── Workout Player          // Full-screen, immersive, timer-focused
│
├── 🥗 Nutrition
│   ├── Calorie Goal Ring       // P0: Radial progress, large, prominent
│   ├── Today's Meals List      // P1: Vertical list, meal cards
│   ├── Water Tracker           // P2: Interactive, tap to add glass
│   ├── Macro Breakdown         // P3: 3-column grid (Protein, Carbs, Fat)
│   └── Add Meal FAB            // Floating action, bottom-right
│
└── 👤 Profile
    ├── User Header             // Avatar + name + membership badge
    ├── Stats Overview          // Grid: workouts, streak, calories, weight
    ├── Settings List           // Grouped items, chevron indicators
    ├── Premium Card            // If not subscribed: upgrade prompt
    └── Logout                  // Bottom of list, danger style
```

**Navigation Rules:**
- Rule 1: Exactly 4 tabs. No more (cognitive overload), no less (feels incomplete).
- Rule 2: Active tab = filled icon + primary text color.
- Rule 3: Inactive tab = outlined icon + tertiary text color.
- Rule 4: Tab bar height = 64dp (generous, thumb-friendly).
- Rule 5: No labels hidden. Icons + text always visible.
- Rule 6: Tab switch animation = crossfade, 200ms.

---

## 🎯 **Part 5: UX Patterns**

### **Task Completion Framework — Frictionless Flow**

| Pattern | Application | Implementation |
| :--- | :--- | :--- |
| **Progressive Disclosure** | Show complexity only when needed. | Default view = summary. Expand/collapse for details. |
| **Contextual Actions** | Act on data where it lives. | Swipe to complete. Long-press for options. Inline edit. |
| **One-Handed Usage** | Primary actions in thumb zone. | FAB bottom-right. Primary buttons bottom of screen. |
| **Reduced Taps** | Minimize cognitive load. | Smart defaults. Predictive input. Autofill where possible. |
| **Predictive UI** | Anticipate user needs. | Suggest next workout. Pre-fill nutrition based on history. |
| **Confirmation Dialogs** | Only for destructive actions. | Delete account, cancel subscription, discard workout. |
| **Undo Over Confirm** | Allow recovery instead of blocking. | Delete meal → Snackbar with undo. Remove exercise → Undo available. |

---

### **Feedback Framework — The ShapeShred Response**

| User Action | Immediate Feedback | Delayed Feedback | Haptic |
| :--- | :--- | :--- | :--- |
| **Tap Button** | Scale 0.97 (instant) | Color shift (short) | Light impact |
| **Complete Workout** | Success animation (scale + fade) | Confetti overlay (extended) | Success notification |
| **Log Meal** | Toast slide-up (short) | Calorie ring update (medium) | Light impact |
| **Achieve Goal** | Medal unlock animation (extended) | Achievement card reveal | Success notification |
| **Error** | Shake animation (300ms) | Snackbar with action | Error notification |
| **Loading** | Skeleton screen (instant) | Progressive content reveal | None |
| **Empty State** | Illustration fade-in (medium) | Suggested action button | None |
| **Pull to Refresh** | Spinner rotation | Content crossfade | Light impact |
| **Swipe Complete** | Checkmark scale-in | Item removal animation | Medium impact |

---

### **Cognitive Load Reduction — Mental Gymnastics Prevention**

| Strategy | Implementation | Example |
| :--- | :--- | :--- |
| **Information Hierarchy** | Primary → Secondary → Tertiary | Workout name (primary), duration (secondary), calories (tertiary) |
| **Visual Grouping** | Related items share container | Meal card groups: food name, calories, time |
| **White Space** | Breathing room between sections | space32 between dashboard sections |
| **Consistent Patterns** | Same actions, same places | Always top-right for settings, bottom for primary CTA |
| **Progressive Disclosure** | Advanced features hidden | "Show More" for detailed stats, "Edit" for advanced options |
| **Default Values** | Pre-populate where possible | Today's date pre-selected. Recent exercise suggested. |
| **Smart Suggestions** | AI recommendations | "Based on your schedule, try Leg Day today" |
| **Chunking** | Break complex tasks into steps | Workout creation: 1) Select exercises, 2) Configure sets, 3) Review |

---

## ♿ **Part 6: Accessibility Standards**

### **WCAG AA Compliance — Non-Negotiable**

| Category | Requirement | Implementation | Verification |
| :--- | :--- | :--- | :--- |
| **Perceivable** | Text alternatives for non-text content | Semantic labels for all icons. Alt text for images. | Screen reader test |
| **Operable** | Keyboard accessible | Tab order logical. Focus indicators visible. | Keyboard navigation test |
| **Understandable** | Consistent navigation | Same patterns across all screens. Predictable flows. | User testing |
| **Robust** | Compatible with assistive tech | TalkBack (Android), VoiceOver (iOS) fully supported. | Assistive tech audit |

---

### **Touch Target Requirements — Physical Accessibility**

| Element | Minimum Size | Ideal Size | Spacing |
| :--- | :--- | :--- | :--- |
| **Buttons** | 48dp × 48dp | 56dp × 48dp | space8 between adjacent |
| **Icon Buttons** | 48dp × 48dp | 48dp × 48dp | space12 between adjacent |
| **List Items** | 48dp height | 56dp height | space0 (full-bleed divider) |
| **Cards** | 48dp tap target | Full card tap | space12 between cards |
| **Form Inputs** | 48dp height | 56dp height | space16 between fields |
| **Chips/Tags** | 40dp height | 44dp height | space8 between chips |
| **Sliders** | 48dp touch area | 48dp touch area | N/A |
| **Switches** | 48dp × 32dp | 52dp × 32dp | space16 between items |

---

### **Typography Accessibility — Readable by Everyone**

| Requirement | Implementation | Token |
| :--- | :--- | :--- |
| **Dynamic Type** | Support system font scaling up to 200% | All text uses sp units |
| **Contrast Ratio** | Minimum 4.5:1 for normal text | TextColor.primary on SurfaceLevel.background = 15.3:1 ✓ |
| **Large Text** | Minimum 3:1 for 18pt+ | TextColor.primary on SurfaceLevel.elevated = 14.1:1 ✓ |
| **Line Height** | Minimum 1.5× for body text | bodyLarge = 16sp/24sp = 1.5 ✓ |
| **Letter Spacing** | Positive tracking for readability | bodyLarge = 0.5sp ✓ |
| **Font Weight** | Minimum w400 for body text | All body = w400 ✓ |
| **Maximum Line Length** | 60-75 characters per line | Content max width = 600dp on tablets |

---

### **Focus Management — Keyboard & Screen Reader**

```dart
// Focus Order Rules
Rule 1: Logical top-to-bottom, left-to-right flow.
Rule 2: Skip decorative elements (dividers, backgrounds).
Rule 3: Trap focus inside modals and bottom sheets.
Rule 4: Return focus to trigger element on modal dismiss.
Rule 5: Focus indicator = 2dp outline, BorderColor.strong, 2dp offset.

// Screen Reader Rules
Rule 1: Every interactive element has semantic label.
Rule 2: Decorative images have empty alt text (ignored).
Rule 3: Dynamic content announces changes (live regions).
Rule 4: Loading states announce "Loading" and "Complete".
Rule 5: Error states announce error message + recovery action.
```

---

## 🚀 **Part 7: Premium Experience Standards**

### **Premium UX Checklist — The ShapeShred Seal**

- [ ] **Onboarding is cinematic, not functional.** Every frame feels crafted.
- [ ] **Typography is refined, not default.** Custom hierarchy, perfect spacing.
- [ ] **Spacing is generous, not cramped.** Breathing room is luxury.
- [ ] **Animations are deliberate, not random.** Every motion has meaning.
- [ ] **Illustrations are custom, not stock.** Monochromatic, brand-aligned.
- [ ] **Empty states are engaging, not empty.** Helpful copy + action + illustration.
- [ ] **Loading states are smooth, not jarring.** Skeleton layouts, never spinners alone.
- [ ] **Success states are celebratory, not passive.** Haptics + animation + confetti.
- [ ] **Error states are helpful, not punishing.** Clear message + recovery action.
- [ ] **Every screen feels handcrafted.** No generic Flutter defaults. Ever.
- [ ] **Every interaction feels expensive.** Premium physics, refined curves.
- [ ] **Every state is considered.** Loading, error, empty, success — all designed.
- [ ] **Every edge case is handled.** No crashes, no blank screens, no dead ends.

---

### **Premium Interaction Standards — The Details That Matter**

| Interaction | Standard Implementation | Anti-Pattern |
| :--- | :--- | :--- |
| **Scrolling** | Smooth, physics-based, momentum-driven. No jank. | Scroll lag, rubber-banding artifacts |
| **Transitions** | Hero animations, shared axis, crossfade. Purposeful. | Instant cuts, random slide directions |
| **Gestures** | Fluid, responsive, immediate feedback. | Delayed response, missed gestures |
| **Haptics** | Subtle, appropriate, context-aware. | Absent, or overwhelming vibration |
| **Typography** | Kerning, leading, variable fonts. Refined. | System defaults, no attention to detail |
| **Spacing** | Generous, mathematical, breathing room. | Cramped, arbitrary, inconsistent |
| **Shadows** | Soft, directional, elevation-appropriate. | Harsh, colored, or absent |
| **Borders** | Hairline precision, semantic purpose. | Thick, decorative, unnecessary |
| **Icons** | Consistent weight, custom where needed. | Mixed styles, stock inconsistencies |
| **States** | Every state designed: default, hover, pressed, disabled, loading, error, success. | Only default state designed |

---

## 🤖 **Part 8: AI Experience Standards**

### **AI Coach Interaction Design — Human, Not Machine**

| Element | Requirement | Implementation |
| :--- | :--- | :--- |
| **Natural Conversation** | Human-like language, not robotic. | Warm tone, contractions, empathy. No "I am an AI." |
| **Context Awareness** | Remembers previous conversations. | Conversation history visible, referenced naturally. |
| **Memory** | Understands user history and preferences. | "Last time you mentioned knee pain — how is it today?" |
| **Empathy** | Supportive, encouraging tone. | Celebrate effort, not just results. |
| **Professional Guidance** | Scientifically accurate, not generic. | Cite principles, explain reasoning. |
| **Fast Responses** | Low latency, typing indicators. | Typing indicator after 500ms. Response within 2s. |
| **Elegant Chat Interface** | Clean bubbles, proper spacing. | User = right-aligned, gray800 bubble. Coach = left, white bubble. |
| **Streaming Responses** | Progressive loading, not batch. | Word-by-word reveal, 30ms per word. |
| **Voice Ready** | Supports voice input/output. | Mic button in input. Voice wave animation when listening. |
| **Image Ready** | Supports image recognition. | Camera button in input. Image preview in chat. |

---

### **AI Chat Interface Specification**

```dart
ChatBubble
├── User Message
│   ├── Alignment: Right
│   ├── Background: ColorPalette.gray800
│   ├── Text Color: TextColor.inverse
│   ├── Radius: radiusMedium (top-right: radiusSmall for continuity)
│   ├── Padding: space16
│   └── Max Width: 75% of screen
│
├── Coach Message
│   ├── Alignment: Left
│   ├── Background: SurfaceLevel.elevated
│   ├── Text Color: TextColor.primary
│   ├── Radius: radiusMedium (top-left: radiusSmall)
│   ├── Padding: space16
│   └── Max Width: 75% of screen
│
├── Timestamp
│   ├── Format: "2:30 PM" (12-hour, localized)
│   ├── Color: TextColor.tertiary
│   ├── Size: caption
│   └── Position: Below bubble, same alignment
│
├── Typing Indicator
│   ├── Three pulsing dots
│   ├── Animation: scale pulse, 1s cycle, staggered
│   └── Color: TextColor.secondary
│
└── Input Field
    ├── Hint: "Ask your coach anything..."
    ├── Radius: radiusPill
    ├── Background: SurfaceLevel.elevated
    ├── Border: BorderColor.subtle
    ├── Send Button: Icon button, filled when text present
    └── Voice Button: Mic icon, pulse animation when active
```

---

## 📊 **Part 9: Dashboard Information Architecture**

### **Home Dashboard Priority — Visual Hierarchy**

| Priority | Content | Visual Treatment | Rationale |
| :--- | :--- | :--- | :--- |
| **P0** | Today's Workout | Full-width card, radiusLarge, level3 elevation | Immediate action, highest value |
| **P1** | Daily Stats | 3-column grid, equal weight, icon + number + label | Quick progress check |
| **P2** | Quick Actions | Horizontal scroll, icon buttons, space12 gaps | Contextual tasks |
| **P3** | Recommended Workouts | Horizontal carousel, workout cards, peek next | Passive discovery |
| **P4** | Motivational Element | Compact banner, streak or quote | Emotional connection |

---

### **Nutrition Dashboard Priority**

| Priority | Content | Visual Treatment | Rationale |
| :--- | :--- | :--- | :--- |
| **P0** | Calorie Goal Ring | Centered, large (200dp), radial progress | Immediate feedback |
| **P1** | Today's Meals | Vertical list, meal cards, space12 gaps | Logging history |
| **P2** | Water Tracker | Interactive row, tap to increment, visual fill | Health tracking |
| **P3** | Add Meal Action | FAB, bottom-right, radiusPill | Quick logging |
| **P4** | Macro Breakdown | 3-column grid, compact bars | Detailed analysis |

---

### **Training Dashboard Priority**

| Priority | Content | Visual Treatment | Rationale |
| :--- | :--- | :--- | :--- |
| **P0** | Active Workout / Resume | Full-width banner, prominent CTA | Continue momentum |
| **P1** | Category Grid | 2×3 grid, icon + label, space16 gaps | Browse by type |
| **P2** | Recent Workouts | Vertical list, compact cards | Quick access |
| **P3** | Weekly Schedule | Horizontal calendar strip | Plan ahead |
| **P4** | Personal Records | Horizontal scroll, stat cards | Motivation |

---

## 🧪 **Part 10: Quality Gate**

### **Screen Quality Checklist — Before Any Screen Ships**

- [ ] **Is this screen beautiful?** Would it win a design award?
- [ ] **Is it intuitive?** Can a first-time user understand it without explanation?
- [ ] **Does it feel premium?** Every pixel intentional, every animation refined.
- [ ] **Does it feel world-class?** Comparable to Apple, Google, Airbnb, Notion.
- [ ] **Does it reduce cognitive load?** One primary action, clear hierarchy.
- [ ] **Is it accessible (WCAG AA)?** Screen reader compatible, 48dp touch targets.
- [ ] **Does it support Dynamic Type?** Scales gracefully to 200%.
- [ ] **Does it work on small screens?** iPhone SE, small Android phones.
- [ ] **Does it work on large screens?** iPad, tablets, foldables.
- [ ] **Are gestures natural and discoverable?** Swipe, tap, long-press all feel right.
- [ ] **Are all states designed?** Loading, error, empty, success, disabled.
- [ ] **Are animations purposeful?** Every motion communicates something.
- [ ] **Is typography refined?** No system defaults, perfect hierarchy.
- [ ] **Is spacing generous?** Breathing room, mathematical precision.
- [ ] **Are interactions responsive?** <100ms feedback, no jank.
- [ ] **Does it respect the monochromatic palette?** White, gray, black shadows only.
- [ ] **Would I pay for this experience?** The ultimate test.

---

### **Code Quality Checklist — Before Any PR Merges**

- [ ] **No hardcoded values.** All colors, spacing, typography from tokens.
- [ ] **No generic Flutter defaults.** Custom components only.
- [ ] **BLoC pattern followed.** Proper state management, no setState for business logic.
- [ ] **Accessibility labels present.** Every interactive element.
- [ ] **Error handling robust.** No unhandled exceptions, graceful degradation.
- [ ] **Performance audited.** 60fps animations, <16ms frame times.
- [ ] **Responsive tested.** Small, medium, large screens.
- [ ] **Dark mode considered.** Even if not shipped, architecture supports it.
- [ ] **Unit tests written.** Business logic covered.
- [ ] **Widget tests written.** Critical user flows covered.

---

## 📝 **Part 11: Implementation Guidelines**

### **Flutter Architecture — The ShapeShred Stack**

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── api_constants.dart
│   ├── design_tokens/
│   │   ├── colors.dart              // ColorPalette, GrayScale, SemanticColors
│   │   ├── typography.dart          // TypographyTokens
│   │   ├── spacing.dart             // SpacingTokens
│   │   ├── radius.dart              // RadiusTokens
│   │   ├── elevation.dart           // ElevationTokens
│   │   ├── motion.dart              // DurationTokens, CurveTokens, MotionTokens
│   │   └── icons.dart               // IconSizes, IconVariant
│   ├── theme/
│   │   ├── app_theme.dart           // ThemeData assembly
│   │   ├── light_theme.dart         // Light mode configuration
│   │   ├── dark_theme.dart          // Dark mode configuration (future)
│   │   └── theme_extensions.dart    // Custom theme extensions
│   ├── components/
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   ├── ghost_button.dart
│   │   │   └── icon_button.dart
│   │   ├── cards/
│   │   │   ├── workout_card.dart
│   │   │   ├── nutrition_card.dart
│   │   │   └── stat_card.dart
│   │   ├── inputs/
│   │   │   ├── text_field.dart
│   │   │   ├── search_bar.dart
│   │   │   └── otp_field.dart
│   │   ├── feedback/
│   │   │   ├── snackbar.dart
│   │   │   ├── dialog.dart
│   │   │   └── bottom_sheet.dart
│   │   ├── indicators/
│   │   │   ├── progress_ring.dart
│   │   │   ├── skeleton.dart
│   │   │   └── shimmer.dart
│   │   └── navigation/
│   │       ├── app_bar.dart
│   │       ├── bottom_nav.dart
│   │       └── tab_bar.dart
│   ├── utils/
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart
│   │   │   └── string_extensions.dart
│   │   └── helpers/
│   │       ├── haptic_helper.dart
│   │       └── animation_helper.dart
│   └── errors/
│       ├── exceptions.dart
│       └── failure.dart
├── features/
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── training/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── nutrition/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── coach/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── widgets/
│   │   └── common_widgets.dart
│   └── models/
│       └── base_models.dart
└── injection.dart                    // Dependency injection (GetIt)
```

---

### **Theme Extension Pattern — The Only Way**

```dart
// ═══════════════════════════════════════════════════════════════
// ❌ NEVER DO THIS — Hardcoded styles kill consistency
// ═══════════════════════════════════════════════════════════════

TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.black,
)

// ═══════════════════════════════════════════════════════════════
// ✅ ALWAYS DO THIS — Theme Extensions ensure consistency
// ═══════════════════════════════════════════════════════════════

// Accessing typography
Theme.of(context).textTheme.labelLarge

// Accessing colors
Theme.of(context).colorScheme.primary

// Custom theme extension for app-specific tokens
Theme.of(context).extension<ShapeShredTheme>()!.workoutCardElevation

// Combining tokens
Theme.of(context).textTheme.labelLarge?.copyWith(
  color: Theme.of(context).colorScheme.primary,
)

// ═══════════════════════════════════════════════════════════════
// CUSTOM THEME EXTENSION DEFINITION
// ═══════════════════════════════════════════════════════════════

@immutable
class ShapeShredTheme extends ThemeExtension<ShapeShredTheme> {
  final Color workoutCardBackground;
  final Color nutritionCardBackground;
  final double workoutCardElevation;
  final double modalElevation;

  const ShapeShredTheme({
    required this.workoutCardBackground,
    required this.nutritionCardBackground,
    required this.workoutCardElevation,
    required this.modalElevation,
  });

  @override
  ShapeShredTheme copyWith({
    Color? workoutCardBackground,
    Color? nutritionCardBackground,
    double? workoutCardElevation,
    double? modalElevation,
  }) {
    return ShapeShredTheme(
      workoutCardBackground: workoutCardBackground ?? this.workoutCardBackground,
      nutritionCardBackground: nutritionCardBackground ?? this.nutritionCardBackground,
      workoutCardElevation: workoutCardElevation ?? this.workoutCardElevation,
      modalElevation: modalElevation ?? this.modalElevation,
    );
  }

  @override
  ShapeShredTheme lerp(ThemeExtension<ShapeShredTheme>? other, double t) {
    // Implementation for theme animation
  }
}
```

---

### **State Management — BLoC Pattern Rules**

```dart
// ═══════════════════════════════════════════════════════════════
// BLoC ARCHITECTURE RULES
// ═══════════════════════════════════════════════════════════════

Rule 1: Every feature has its own BLoC.
Rule 2: BLoC handles business logic ONLY. No UI code in BLoC.
Rule 3: States are immutable. Use freezed or equatable.
Rule 4: Events represent user intentions. Name them as verbs.
Rule 5: Side effects (navigation, snackbars) use BLoC listeners, not builders.
Rule 6: Loading states are first-class. Always design the skeleton.
Rule 7: Error states are first-class. Always design the error screen.
Rule 8: Initial state is explicit. Never null or undefined.

// ═══════════════════════════════════════════════════════════════
// BLoC STATE PATTERN
// ═══════════════════════════════════════════════════════════════

@freezed
class WorkoutState with _$WorkoutState {
  const factory WorkoutState.initial() = _Initial;
  const factory WorkoutState.loading() = _Loading;
  const factory WorkoutState.loaded(List<Workout> workouts) = _Loaded;
  const factory WorkoutState.empty() = _Empty;
  const factory WorkoutState.error(String message) = _Error;
}

// ═══════════════════════════════════════════════════════════════
// BLoC EVENT PATTERN
// ═══════════════════════════════════════════════════════════════

@freezed
class WorkoutEvent with _$WorkoutEvent {
  const factory WorkoutEvent.loadWorkouts() = _LoadWorkouts;
  const factory WorkoutEvent.startWorkout(String workoutId) = _StartWorkout;
  const factory WorkoutEvent.completeExercise(String exerciseId) = _CompleteExercise;
}
```

---

## 🎯 **Part 12: Final Principles — The ShapeShred Doctrine**

### **The Ten Commandments of ShapeShred Design**

1. **Every element must earn its place.** If it doesn't serve the user, it is waste.
2. **Typography must be refined, not default.** Custom hierarchy, perfect spacing, intentional weight.
3. **Spacing must be generous, not cramped.** Breathing room is the luxury of digital minimalism.
4. **Animations must be deliberate, not random.** Every motion communicates hierarchy or state.
5. **Everything must feel handcrafted.** No generic Flutter examples. No system defaults.
6. **Color must be disciplined.** White, light gray, dark gray. Black only for shadows.
7. **Accessibility is mandatory, not optional.** WCAG AA minimum. No exceptions.
8. **Performance is a feature.** 60fps or nothing. Jank is a bug.
9. **Consistency is king.** Same patterns, same places, same behaviors. Everywhere.
10. **Never settle for average.** World-class or nothing. No compromises.

---

### **The ShapeShred Promise**

> **"We engineer one of the highest-quality mobile fitness experiences in the world. Every screen is a masterpiece. Every interaction is a delight. Every pixel is a promise of excellence. We do not ship average. We do not ship good. We ship world-class."**

---

### **The Monochromatic Manifesto**

> **"In a world of colorful noise, we choose disciplined restraint. White is our canvas. Gray is our voice. Black is our shadow. We do not need color to communicate power. Our design speaks through contrast, hierarchy, and precision. This is ShapeShred. This is digital discipline."**

---

## 🔄 **Version History**

| Version | Date | Changes |
| :--- | :--- | :--- |
| 1.0 | 2026-06-15 | Initial constitution. Core philosophy and basic tokens. |
| 2.0 | 2026-07-02 | Complete redesign. Added Design Tokens, Component Architecture, Accessibility Standards, Premium Experience, AI Experience, Quality Gate, and Implementation Guidelines. |
| 3.0 | 2026-07-02 | **Monochromatic Revolution.** Restructured color system around White/Light Gray/Dark Gray with Black reserved exclusively for shadows and micro-details. Enhanced motion system with premium curves. Expanded BLoC architecture guidelines. Added Monochromatic Manifesto. |

---

**End of Constitution v3.0**

> *"Discipline in design. Power in simplicity. Luxury in restraint."*
