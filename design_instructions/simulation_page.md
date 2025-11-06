# HeyGen Simulation Page - Figma AI Design Instruction

## Page Overview
Design a clean, focused simulation page for the HeyGen avatar interaction. This page should feel professional and immersive, with minimal UI elements to focus attention on the avatar conversation. Remove all debugging items and keep only essential controls.

## Layout Structure

### Full-Screen Container
- **Layout**: Full viewport (100vw x 100vh)
- **Background**: Dark theme background (use existing dark theme color)
- **Padding**: 0 (full bleed)
- **Display**: Flex column layout

### Main Content Area (Avatar View)
- **Height**: Flexible, takes remaining space
- **Layout**: Horizontal flex container with equal spacing
- **Padding**: 24px all around
- **Gap**: 24px between video elements

#### Left Video Panel (User Webcam)
- **Width**: 50% of container (minus gap)
- **Aspect Ratio**: 16:9
- **Background**: Dark gray/black
- **Border**: 1px solid, use border color from theme
- **Border Radius**: 8px
- **Video Element**:
  - Fills container
  - Object-fit: contain
  - Display: block
  - Plays inline (autoplay)

#### Right Video Panel (Avatar)
- **Width**: 50% of container (minus gap)
- **Aspect Ratio**: 16:9
- **Background**: Dark gray/black
- **Border**: 1px solid, use border color from theme
- **Border Radius**: 8px
- **Video Element**:
  - Fills container
  - Object-fit: contain
  - Display: block
  - Plays inline (autoplay)

### Control Bar (Bottom)
- **Position**: Fixed at bottom of viewport
- **Height**: 80px
- **Background**: Dark surface color (slightly lighter than main background)
- **Border**: Top border (1px, use divider color)
- **Padding**: 16px horizontal, 16px vertical
- **Layout**: Horizontal flex container
- **Alignment**: Center all items
- **Gap**: 16px between buttons

#### Start Simulation Button
- **State**: Default (when simulation not started)
- **Type**: Primary button
- **Style**: 
  - Background: Primary/lime color (use existing lime300)
  - Text: Black
  - Font: Inter Medium, 14px
  - Padding: 16px horizontal, 12px vertical
  - Border Radius: 8px
  - Icon: Play icon (24px) on left side
- **Text**: "Start Simulation"
- **Width**: Auto (min-width: 160px)
- **Hover State**: Slightly darker background
- **Active State**: Slightly pressed appearance

#### Stop Simulation Button
- **State**: Visible only when simulation is active
- **Type**: Destructive/secondary button
- **Style**:
  - Background: Red/destructive color OR transparent with red border
  - Text: Red or white
  - Font: Inter Medium, 14px
  - Padding: 16px horizontal, 12px vertical
  - Border Radius: 8px
  - Border: 1px solid red (if using transparent background)
  - Icon: Stop icon (24px) on left side
- **Text**: "Stop Simulation"
- **Width**: Auto (min-width: 160px)
- **Hover State**: Darker red background or border
- **Active State**: Slightly pressed appearance

## Responsive Behavior
- On mobile (< 768px):
  - Stack video panels vertically instead of side-by-side
  - Each video panel takes full width
  - Control bar remains fixed at bottom
  - Reduce padding to 16px

## States

### Initial State (Before Start)
- Both video panels show dark background/placeholder
- Only "Start Simulation" button visible
- No status indicators

### Active State (During Simulation)
- Both videos playing
- "Start Simulation" button hidden
- "Stop Simulation" button visible
- Optional: Small status indicator (green dot) showing "Live" or "Connected"

### Stopped State
- Videos stop/pause
- Return to initial state after confirmation modal

## Excluded Elements (Do NOT Include)
- ❌ Debug log text area
- ❌ "Start Session" button (replaced by "Start Simulation")
- ❌ "Start Rec" / "Stop Rec" buttons (handled automatically)
- ❌ "Start Voice Chat" button (handled automatically)
- ❌ "Speak" button (handled automatically)
- ❌ Any console/log output areas
- ❌ Technical status messages visible to user

