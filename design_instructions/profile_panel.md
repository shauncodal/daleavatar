# Profile Panel - Figma AI Design Instruction

## Panel Overview
Design a slide-out profile panel for displaying user profile information and account actions. This panel slides in from the left side of the screen when the user avatar/name is clicked in the header. It should feel personal and provide easy access to account management features.

## Panel Structure

### Panel Container
- **Position**: Fixed, slides in from left side
- **Width**: 400px
- **Height**: Full viewport height (100vh)
- **Animation**: Slide-in from left (translateX from -400px to 0)
- **Duration**: 300ms, ease-in-out curve
- **Background**: Use existing surface/card background color
- **Shadow**: Elevation shadow on right edge (use existing shadow tokens)
- **Z-index**: Above main content, below overlay

### Header Section
- **Height**: Fixed height (approx 64px)
- **Background**: Use primary color with light opacity (10%)
- **Border**: Bottom border (1px, use divider color)
- **Padding**: 16px all around
- **Layout**: Horizontal flex container
- **Elements**:
  - Person icon (left, use icon component)
  - Title: "Profile" (use heading style)
  - Close button (right): X icon button, use existing button style
  - Spacer between title and close button

### Content Area
- **Layout**: Scrollable vertical container
- **Padding**: 24px all around (horizontal and vertical)
- **Scroll behavior**: Smooth scrolling if content overflows
- **Background**: Use existing page background color
- **Alignment**: Center-aligned for profile section, left-aligned for menu items

## Profile Section (Top)

### Avatar
- **Type**: Large circular avatar
- **Size**: 100px diameter (50px radius)
- **Background**: Use primary color with 20% opacity
- **Content**: User's first initial (uppercase)
- **Text Style**: Large, bold, primary color (48px font size)
- **Position**: Centered horizontally
- **Spacing**: 16px below avatar

### User Name
- **Text**: User's full name or "User" if not available
- **Style**: Use headline/section heading style, bold
- **Alignment**: Centered
- **Spacing**: 8px below name

### Role/Title
- **Text**: "Sales Training Student" (or dynamic role if available)
- **Style**: Use body text style, secondary color
- **Alignment**: Centered
- **Spacing**: 32px below role

## Menu Items Section

### Menu Item Structure
Each menu item follows this pattern:
- **Layout**: List tile style (horizontal flex container)
- **Left**: Icon (20px, use secondary text color, except for special items)
- **Center**: Title text (use body text style)
- **Right**: Chevron right icon (use existing icon component)
- **Padding**: Use existing list tile padding
- **Height**: Minimum 48px touch target
- **Interaction**: Entire row clickable, hover state

### Section 1: Account Management
**Items**:

1. **Edit Profile**
   - Icon: Edit icon
   - Title: "Edit Profile"
   - Action: Opens edit profile screen (placeholder for now)

2. **Change Password**
   - Icon: Lock icon
   - Title: "Change Password"
   - Action: Opens change password screen (placeholder for now)

3. **Account Settings**
   - Icon: Person pin icon
   - Title: "Account Settings"
   - Action: Opens account settings screen (placeholder for now)

**Divider**: Horizontal divider below this section (use existing divider component)

### Section 2: Support
**Items**:

1. **Help & Support**
   - Icon: Help outline icon
   - Title: "Help & Support"
   - Action: Opens help/support screen (placeholder for now)

2. **About**
   - Icon: Info outline icon
   - Title: "About"
   - Action: Opens about screen (placeholder for now)

**Divider**: Horizontal divider below this section (use existing divider component)

### Section 3: Sign Out
**Items**:

1. **Sign Out**
   - Icon: Logout icon
   - Title: "Sign Out"
   - Title Color: Use error/warning color (red)
   - Icon Color: Use error/warning color (red)
   - Action: Logs user out and returns to login screen
   - **Special Styling**: Use error color to indicate destructive action

## Menu Item States

### Default State
- Background: Transparent
- Text: Use body text style
- Icon: Use secondary text color (except sign out)

### Hover State
- Background: Use hover background color from theme
- Subtle background tint

### Active/Pressed State
- Background: Use pressed state color from theme
- Slight scale or elevation change

## Overlay (Backdrop)
- **Position**: Fixed, covers entire viewport
- **Background**: Black with 30% opacity
- **Z-index**: Between main content and panel
- **Interaction**: Clickable to close panel
- **Left Offset**: Starts at 400px from left (when panel is open)
- **Animation**: Fade in/out with panel animation

## Interaction States
- **Panel Open**: Panel visible from left, overlay visible
- **Panel Close**: Panel slides out to left, overlay fades out
- **Menu Items**: Hover and active states
- **Profile Avatar**: Static (no interaction)

## Responsive Considerations
- **Desktop**: 400px width panel
- **Tablet**: 400px width panel, same layout
- **Mobile**: Full width panel (100vw) or 90% width with margins

## Accessibility
- All menu items should have clear labels
- Keyboard navigation support (Tab to navigate, Enter to activate)
- Escape key closes panel
- Focus trap within panel when open
- Screen reader announcements for panel open/close
- Clear visual hierarchy
- Color not sole indicator (Sign Out uses icon + text + color)

## Additional Notes
- Profile section should be visually distinct from menu items
- Use existing list tile component style
- Consistent spacing between sections
- Dividers separate logical groups of menu items
- Sign Out should feel distinct from other items (destructive action)
- Panel should maintain scroll position if content grows
- Follow existing design system for all components
- Center-aligned profile section creates clear visual break from left-aligned menu items

