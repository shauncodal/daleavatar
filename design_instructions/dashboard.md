# Dashboard Page - Figma AI Design Instruction

## Page Overview
Design a modern, clean dashboard page for a sales training application. This is the main landing page that users see after logging in. It should feel professional, engaging, and provide quick insights into the user's progress and performance.

## Layout Structure

### Top Navigation Bar (Persistent Header)
- **Height**: 64px
- **Layout**: Horizontal flex container
- **Elements from left to right**:
  1. **User Profile Section** (left-aligned):
     - Circular avatar (36px diameter) with user's initial
     - User name (use existing text styles)
     - Optional: "DEMO" badge if in demo mode (rounded, use warning/alert color)
  2. **Spacer** (flexible, pushes content to edges)
  3. **Notifications Icon** (center):
     - Bell icon (24px)
     - Badge with unread count (if > 0)
     - Badge: 16px circle, positioned top-right corner
  4. **Settings Icon** (center): Gear icon (24px)
  5. **Logout Icon** (right): Logout icon (24px)

### Main Content Area
- **Container**: Max width 1200px, centered, with 24px horizontal padding
- **Padding**: 24px top and bottom
- **Layout**: Single column, vertical stack with 24px gaps between sections
- **Background**: Use existing page background color from theme

## Section 1: Try Interactive Demo Card
- **Card Style**: Use existing card component style with accent background
- **Layout**: Horizontal flex container with padding 16px
- **Left Side**:
  - Large play icon (48px, use primary color)
  - Text stack:
    - Title: "Try Interactive Demo" (use heading style)
    - Subtitle: "Experience our sales training scenarios" (use body/secondary text style)
- **Right Side**:
  - Primary button with icon and text "Start Demo"
  - Use existing button component style

## Section 2: Performance Statistics Card
- **Card Style**: Use existing card component style
- **Padding**: 16px all around
- **Header**:
  - Bar chart icon (24px, use primary color)
  - Title: "Performance Statistics" (use heading style)
  - Subtitle (optional): "Based on X recordings and Y evaluations" (use small/secondary text style)

### Statistics Display Layout

**Top Row - Prominent Metrics Cards** (if data available):
- Two equal-width cards side by side with 12px gap
- **Engagement Score Card**:
  - Background: Use primary color tint
  - Border: Primary color border (2px, rounded)
  - Icon: People icon (32px, primary color)
  - Large number: Percentage (use large number style, primary color)
  - Label: "Engagement Score" (use small text style)
  
- **Evaluator Feedback Card**:
  - Background: Use success color tint
  - Border: Success color border (2px, rounded)
  - Icon: Star icon (32px, success color)
  - Large number: Percentage (use large number style, success color)
  - Label: "Evaluator Feedback" (use small text style)

**Tone & Delivery Section** (if data available):
- Section title: "Tone & Delivery" (use subheading style)
- List of metrics, each on its own row:
  - Left: Metric name (use body text style)
  - Right: Percentage value in colored badge
  - Metrics to include:
    - Confidence (use success color badge)
    - Enthusiasm (use warning color badge)
    - Clarity (use primary color badge)
    - Professionalism (use secondary color badge)
    - Friendliness (use accent color badge)

**Key Metrics Section** (if data available):
- Section title: "Key Metrics" (use subheading style)
- List of metrics, each on its own row:
  - Left: Metric name (use body text style)
  - Right: Percentage value in colored badge
  - Metrics to include:
    - Question Quality (use accent color badge)
    - Objection Handling (use warning color badge)
    - Rapport Score (use secondary color badge)

**Badge Style**:
- Use existing badge component style
- Horizontal padding: 12px
- Vertical padding: 4px
- Rounded corners: Use existing border radius
- Light background tint matching the metric color from theme
- Bold percentage text in matching metric color

## Section 3: Progress Snapshot Card
- **Card Style**: Use existing card component style
- **Padding**: 16px all around
- **Header**: "Progress Snapshot" (use heading style)

**Overall Progress Section**:
- Two-row layout:
  - Row 1: "Overall Progress" label (left, use body text) and percentage (right, use bold text, primary color)
  - Row 2: Progress bar (full width, 10px height, rounded)
    - Use existing progress bar component style
    - Background: Use surface/background color
    - Fill: Use primary color
    - Shows percentage completion

**Next Task Section** (if available):
- Section title: "Next Up:" (use body text style, medium weight)
- Task item row:
  - Task icon (20px, use secondary text color)
  - Task title (use subheading style, bold)
  - Due date (use body text style, secondary color, right-aligned)

## Section 4: My Courses Card
- **Card Style**: Use existing card component style
- **Padding**: 16px all around
- **Header**: "My Courses" (use heading style)

**Empty State** (if no courses):
- Centered content
- Large icon (48px, use secondary text color)
- Text: "No courses enrolled yet. Go to Scenarios to enroll!" (use body text style, secondary color)

**Course List** (if courses exist):
- Vertical list of course cards, 12px gap between
- Each course card:
  - **Layout**: Horizontal flex container, padding 16px
  - **Left Section**:
    - Avatar circle (60px) with emoji/icon and colored background (use theme colors)
    - Course info stack:
      - Course title (use subheading style, bold)
      - Course description (use body text style, secondary color, single line, truncated)
  - **Right Section**:
    - Status badge (top-right):
      - "In Progress" (use primary color)
      - "Completed" (use success color)
      - "Not Started" (use secondary text color)
      - Use existing badge component style
    - Progress bar (if In Progress):
      - Progress label and percentage (use body text style)
      - Progress bar (8px height, rounded, use course/accent color)
    - Completion indicator (if Completed):
      - Check icon and "Completed!" text (use success color)
    - Resume button (bottom-right):
      - Use existing button component style with play icon and "Resume" text

## Spacing
- **Section gaps**: 24px
- **Card padding**: 16px
- **Element spacing**: 8px, 12px, 16px as needed
- Use existing spacing system from design tokens

## Interaction States
- **Cards**: Subtle shadow on hover
- **Buttons**: Slightly darker on hover, elevation change
- **Icons**: Slight scale on hover (1.1x)
- **Course cards**: Entire card clickable, hover state with slight elevation

## Responsive Considerations
- Desktop: Max width 1200px, centered
- Tablet: Same layout, adjust padding to 16px
- Mobile: Single column, stack statistics cards vertically, full width cards

## Accessibility
- High contrast text (WCAG AA minimum)
- Touch targets minimum 44x44px
- Clear visual hierarchy
- Icon labels where appropriate
- Color not sole indicator (use icons/text)

## Additional Notes
- Follow existing design system and component library
- Include subtle animations for data loading states (use existing animation patterns)
- Empty states should be encouraging, not empty
- Statistics section should gracefully handle missing data (hide sections without data)
- All percentages should be clearly labeled
- Use existing icon library/component style
- Reference existing design tokens for colors, typography, spacing, and component styles

