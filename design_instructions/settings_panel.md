# Settings Panel - Figma AI Design Instruction

## Panel Overview
Design a slide-out settings panel for configuring avatar settings in a sales training application. This panel slides in from the right side of the screen when the settings icon is clicked in the header. It should be clean, organized, and easy to navigate.

## Panel Structure

### Panel Container
- **Position**: Fixed, slides in from right side
- **Width**: 400px
- **Height**: Full viewport height (100vh)
- **Animation**: Slide-in from right (translateX from 400px to 0)
- **Duration**: 300ms, ease-in-out curve
- **Background**: Use existing surface/card background color
- **Shadow**: Elevation shadow on left edge (use existing shadow tokens)
- **Z-index**: Above main content, below overlay

### Header Section
- **Height**: Fixed height (approx 64px)
- **Background**: Use primary color with light opacity (10%)
- **Border**: Bottom border (1px, use divider color)
- **Padding**: 16px all around
- **Layout**: Horizontal flex container
- **Elements**:
  - Settings icon (left, use icon component)
  - Title: "Avatar Settings" (use heading style)
  - Close button (right): X icon button, use existing button style
  - Spacer between title and close button

### Content Area
- **Layout**: Scrollable vertical container
- **Padding**: 16px all around
- **Scroll behavior**: Smooth scrolling if content overflows
- **Background**: Use existing page background color

## Settings Sections

Each section is a card component with:
- **Card Style**: Use existing card component style
- **Padding**: 16px all around
- **Margin**: 24px gap between sections
- **Section Title**: Use heading style, bold

### Section 1: Avatar
**Section Title**: "Avatar"

**Avatar Name/ID Field**:
- **Type**: Text input field
- **Label**: "Avatar Name/ID"
- **Placeholder/Hint**: "Elenora_IT_Sitting_public"
- **Help Text**: "Interactive Avatar ID from labs.heygen.com" (use small/secondary text style)
- **Input Style**: Use existing text field component style
- **Full width**: Yes
- **Spacing**: 16px gap below field

**Quality Dropdown**:
- **Type**: Dropdown select
- **Label**: "Quality"
- **Options**:
  - LOW (500kbps, 360p - Faster connection)
  - MEDIUM (1000kbps, 480p - Balanced)
  - HIGH (2000kbps, 720p - Best quality)
- **Description**: Show description below dropdown for selected option (use small/secondary text style)
- **Dropdown Style**: Use existing dropdown component style
- **Full width**: Yes

### Section 2: Voice Settings
**Section Title**: "Voice Settings"

**Voice ID Field**:
- **Type**: Text input field (optional)
- **Label**: "Voice ID (Optional)"
- **Placeholder/Hint**: "Leave empty for avatar default"
- **Help Text**: "Custom voice ID from HeyGen" (use small/secondary text style)
- **Input Style**: Use existing text field component style
- **Full width**: Yes
- **Spacing**: 16px gap below field

**Voice Rate Slider**:
- **Type**: Range slider
- **Label**: "Voice Rate"
- **Value Display**: Show current value on right side (use bold text style)
- **Range**: 0.5 to 1.5
- **Divisions**: 20 steps
- **Format**: Display as decimal (e.g., "1.0")
- **Slider Style**: Use existing slider component style
- **Full width**: Yes
- **Spacing**: 16px gap below slider

**Voice Emotion Dropdown**:
- **Type**: Dropdown select (optional)
- **Label**: "Voice Emotion (Optional)"
- **Options**:
  - Default (null option)
  - EXCITED
  - SERIOUS
  - FRIENDLY
  - SOOTHING
  - BROADCASTER
- **Description**: Show description below dropdown if applicable
- **Dropdown Style**: Use existing dropdown component style
- **Full width**: Yes

### Section 3: Knowledge Base
**Section Title**: "Knowledge Base"

**Knowledge ID Field**:
- **Type**: Text input field (optional)
- **Label**: "Knowledge ID (Optional)"
- **Placeholder/Hint**: "Enter knowledge base ID"
- **Help Text**: "Get from labs.heygen.com/knowledge-base" (use small/secondary text style)
- **Input Style**: Use existing text field component style
- **Full width**: Yes
- **Spacing**: 16px gap below field

**Custom System Prompt Field**:
- **Type**: Multi-line text area (optional)
- **Label**: "Custom System Prompt (Optional)"
- **Placeholder/Hint**: "Enter custom prompt for LLM"
- **Help Text**: "Custom system prompt for GPT-4o mini" (use small/secondary text style)
- **Rows**: 4 lines
- **Input Style**: Use existing text area component style
- **Full width**: Yes

### Section 4: Speech-to-Text
**Section Title**: "Speech-to-Text"

**STT Provider Dropdown**:
- **Type**: Dropdown select
- **Label**: "STT Provider"
- **Options**:
  - DEEPGRAM (default)
- **Description**: "Speech recognition provider" (use small/secondary text style)
- **Dropdown Style**: Use existing dropdown component style
- **Full width**: Yes
- **Spacing**: 16px gap below dropdown

**Confidence Threshold Slider**:
- **Type**: Range slider
- **Label**: "Confidence Threshold"
- **Value Display**: Show current value on right side (use bold text style)
- **Range**: 0.0 to 1.0
- **Divisions**: 20 steps
- **Format**: Display as decimal (e.g., "0.55")
- **Slider Style**: Use existing slider component style
- **Full width**: Yes

### Section 5: Session Settings
**Section Title**: "Session Settings"

**Language Code Field**:
- **Type**: Text input field
- **Label**: "Language Code"
- **Placeholder/Hint**: "en, ja, es, etc."
- **Help Text**: "Basic language codes only (e.g., en, not en-US)" (use small/secondary text style)
- **Input Style**: Use existing text field component style
- **Full width**: Yes
- **Spacing**: 16px gap below field

**Idle Timeout Slider**:
- **Type**: Range slider
- **Label**: "Idle Timeout (seconds)"
- **Value Display**: Show current value on right side (use bold text style)
- **Range**: 30 to 3600 seconds
- **Divisions**: 119 steps
- **Format**: Display with "s" suffix (e.g., "120s")
- **Slider Style**: Use existing slider component style
- **Full width**: Yes
- **Spacing**: 16px gap below slider

**Use Silence Prompt Toggle**:
- **Type**: Switch/toggle component
- **Label**: "Use Silence Prompt"
- **Subtitle**: "Enable automatic conversational prompts during silence"
- **Toggle Style**: Use existing switch component style
- **Full width**: Yes

### Information Card (Bottom)
**Card Style**: Use existing card component style with accent/info background tint
**Padding**: 16px all around

**Content**:
- **Icon**: Info icon (use primary/accend color)
- **Title**: "Settings Reference" (use body text style, bold)
- **Description**: "These settings are based on the HeyGen Streaming Avatar SDK. Settings are automatically saved and will be used when you start a session." (use body text style)
- **Link**: "View SDK Documentation" (use text button style)

## Form Component Styles

### Text Field
- **Style**: Use existing outlined text field component
- **Label**: Above or floating label (use existing text field style)
- **Help Text**: Below field, use small/secondary text style
- **Border**: Use existing border style
- **Focus State**: Use existing focus state
- **Padding**: Use existing text field padding

### Dropdown
- **Style**: Use existing dropdown component style
- **Label**: Above dropdown (use existing label style)
- **Description**: Below dropdown if applicable (use small/secondary text style)
- **Options**: Full width dropdown menu
- **Padding**: Use existing dropdown padding

### Slider
- **Style**: Use existing slider component style
- **Layout**: Row with label on left, value on right, slider below
- **Label**: Use body text style
- **Value**: Use bold text style, right-aligned
- **Track**: Use existing slider track style
- **Thumb**: Use existing slider thumb style

### Switch/Toggle
- **Style**: Use existing switch component style
- **Layout**: List tile style with title and subtitle
- **Position**: Switch on right side
- **Title**: Use body text style
- **Subtitle**: Use small/secondary text style

## Overlay (Backdrop)
- **Position**: Fixed, covers entire viewport
- **Background**: Black with 30% opacity
- **Z-index**: Between main content and panel
- **Interaction**: Clickable to close panel
- **Animation**: Fade in/out with panel animation

## Interaction States
- **Panel Open**: Panel visible, overlay visible
- **Panel Close**: Panel slides out to right, overlay fades out
- **Form Fields**: Use existing focus, hover, and error states
- **Save Behavior**: Settings auto-save on change (no explicit save button needed)

## Responsive Considerations
- **Desktop**: 400px width panel
- **Tablet**: 400px width panel, same layout
- **Mobile**: Full width panel (100vw) or 90% width with margins

## Accessibility
- All form fields should have proper labels
- Keyboard navigation support (Tab to navigate, Enter to select)
- Escape key closes panel
- Focus trap within panel when open
- Screen reader announcements for form changes
- High contrast for form elements

## Additional Notes
- Settings auto-save on each change (show subtle save indicator if needed)
- Use existing form component library
- Dropdowns should prevent overflow (use existing dropdown overflow handling)
- Long help text should wrap properly
- Section cards should stack vertically with consistent spacing
- Follow existing design system for all form elements
- Panel should maintain scroll position when reopening

