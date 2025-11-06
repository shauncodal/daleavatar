# Stop Simulation Confirmation Modal - Figma AI Design Instruction

## Modal Overview
A confirmation dialog that appears when the user clicks "Stop Simulation". This should feel non-intrusive but clear about the action being taken.

## Modal Container
- **Type**: Center modal dialog
- **Width**: 400px (max-width: 90vw on mobile)
- **Background**: Use existing card/surface background color
- **Border**: 1px solid, use border color from theme
- **Border Radius**: 12px
- **Padding**: 24px all around
- **Shadow**: Elevated shadow (use existing shadow tokens)
- **Z-index**: Above all content (modal overlay)

## Overlay
- **Background**: Black with 50% opacity
- **Position**: Fixed, full viewport
- **Z-index**: Below modal, above content

## Content Structure

### Icon Section (Top)
- **Icon**: Warning/Alert icon (48px)
- **Color**: Orange or yellow (warning color)
- **Alignment**: Center
- **Margin**: Bottom 16px

### Title
- **Text**: "Stop Simulation?"
- **Font**: Inter Semi-Bold, 18px
- **Color**: Text primary color
- **Alignment**: Center
- **Margin**: Bottom 8px

### Description
- **Text**: "Are you sure you want to stop the simulation? Your session will be analyzed and results will be generated."
- **Font**: Inter Regular, 14px
- **Color**: Text secondary color
- **Alignment**: Center
- **Line Height**: 1.5
- **Margin**: Bottom 24px

### Button Group (Bottom)
- **Layout**: Horizontal flex container
- **Gap**: 12px between buttons
- **Alignment**: Center

#### Cancel Button
- **Type**: Text button (secondary)
- **Text**: "Cancel"
- **Font**: Inter Medium, 14px
- **Color**: Text secondary color
- **Padding**: 12px horizontal, 10px vertical
- **Border Radius**: 8px
- **Width**: Auto (flex: 1)
- **Background**: Transparent
- **Hover**: Light background tint

#### Confirm Button
- **Type**: Primary button
- **Text**: "Yes, Stop"
- **Font**: Inter Medium, 14px
- **Color**: Black (on lime background) or white (on red background)
- **Background**: Red/destructive color OR lime300
- **Padding**: 12px horizontal, 10px vertical
- **Border Radius**: 8px
- **Width**: Auto (flex: 1)
- **Hover**: Darker background

## Animation
- **Entry**: Fade in + slight scale up (0.95 to 1.0)
- **Duration**: 200ms
- **Easing**: Ease-out
- **Exit**: Fade out + slight scale down
- **Duration**: 150ms
- **Easing**: Ease-in

