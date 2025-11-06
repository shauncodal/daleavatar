# Notifications Panel - Figma AI Design Instruction

## Panel Overview
Design a slide-out notifications panel for displaying user notifications and alerts. This panel slides in from the right side of the screen when the notifications icon is clicked in the header. It should clearly distinguish between read and unread notifications and provide easy interaction.

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
  - Notifications icon (left, use icon component)
  - Title: "Notifications" (use heading style)
  - Close button (right): X icon button, use existing button style
  - Spacer between title and close button

### Content Area
- **Layout**: Scrollable vertical list
- **Padding**: 16px all around
- **Scroll behavior**: Smooth scrolling if content overflows
- **Background**: Use existing page background color
- **Empty State**: Centered content when no notifications

## Notification List

### List Container
- **Type**: Vertical list container
- **Spacing**: 8px gap between notification items
- **Padding**: 16px all around
- **Layout**: Stack of notification cards

### Notification Card

**Card Structure**:
- **Card Style**: Use existing card component style
- **Margin**: 8px bottom margin
- **Padding**: Use existing list tile padding (typically 16px)
- **Layout**: Horizontal flex container (list tile style)

**Unread State**:
- **Background**: Subtle primary color tint (5% opacity)
- **Title**: Bold text weight
- **Indicator**: Blue dot indicator on right side

**Read State**:
- **Background**: Default card background
- **Title**: Normal text weight
- **No Indicator**: No dot indicator

### Notification Content

**Left Section**:
- **Avatar/Icon**: Circular avatar (40px diameter)
  - Background: Icon color with 20% opacity
  - Icon: Type-specific icon (20px size)
  - Icon colors by type:
    - Announcement: Orange/warning color
    - Instructor Message: Primary/blue color
    - System: Secondary/gray color
    - Progress: Success/green color

**Center Section** (Flexible width):
- **Title**: 
  - Style: Body text style
  - Weight: Bold if unread, normal if read
  - Color: Use primary text color
  - Single line, truncate with ellipsis if too long
  
- **Message**:
  - Style: Body text style, secondary color
  - Multi-line support (2-3 lines max)
  - Truncate with ellipsis if too long
  
- **Timestamp**:
  - Style: Small text style, secondary color
  - Examples: "2 hours ago", "1 day ago", "3 days ago"
  - Position: Below message text

**Right Section**:
- **Unread Indicator** (if unread):
  - Type: Circular dot
  - Size: 8px diameter
  - Color: Primary/blue color
  - Position: Top-right aligned
- **Read State**: No indicator (empty)

## Notification Types

### Type: Announcement
- **Icon**: Announcement icon
- **Icon Color**: Orange/warning color
- **Use Case**: New course announcements, general announcements

### Type: Instructor Message
- **Icon**: Message icon
- **Icon Color**: Primary/blue color
- **Use Case**: Personal feedback, instructor communications

### Type: System
- **Icon**: Info icon
- **Icon Color**: Secondary/gray color
- **Use Case**: System messages, welcome messages

### Type: Progress
- **Icon**: Trending up icon
- **Icon Color**: Success/green color
- **Use Case**: Progress updates, achievement notifications

## Interaction

### Card Interaction
- **Click/Tap**: Marks notification as read
- **Hover State**: Subtle background change (use hover state color)
- **Visual Feedback**: Immediate visual update when marked as read

### Mark as Read Behavior
- Background changes from tinted to default
- Title weight changes from bold to normal
- Unread indicator disappears
- Unread count in header badge decreases

## Empty State

**When No Notifications**:
- **Layout**: Centered vertical stack
- **Icon**: Large notification icon (48px, secondary text color)
- **Message**: "No notifications" (use body text style, secondary color)
- **Padding**: Generous padding for visual balance

## Header Badge (Outside Panel)
The notifications icon in the main header should show:
- **Badge**: Circular badge with unread count
- **Position**: Top-right corner of icon
- **Style**: Red background, white text
- **Size**: Minimum 16px, expands for 2-digit numbers
- **Display**: "9+" if count exceeds 9

## Overlay (Backdrop)
- **Position**: Fixed, covers entire viewport
- **Background**: Black with 30% opacity
- **Z-index**: Between main content and panel
- **Interaction**: Clickable to close panel
- **Right Offset**: Starts at 400px from right (when panel is open)
- **Animation**: Fade in/out with panel animation

## Interaction States
- **Panel Open**: Panel visible from right, overlay visible
- **Panel Close**: Panel slides out to right, overlay fades out
- **Notification Card Hover**: Subtle background change
- **Notification Card Click**: Immediate visual feedback, mark as read
- **Scroll**: Smooth scrolling for long lists

## Responsive Considerations
- **Desktop**: 400px width panel
- **Tablet**: 400px width panel, same layout
- **Mobile**: Full width panel (100vw) or 90% width with margins

## Accessibility
- All notifications should have clear titles and messages
- Keyboard navigation support (Tab to navigate, Enter/Space to mark as read)
- Escape key closes panel
- Focus trap within panel when open
- Screen reader announcements for new notifications
- Clear distinction between read and unread states
- Color not sole indicator (use icons, text weight, and indicators)

## Additional Notes
- Notifications should load in chronological order (newest first)
- Real-time updates if notifications arrive while panel is open
- Clear visual hierarchy with unread notifications standing out
- Consistent spacing between notification items
- Use existing card component style
- Icons should be consistent with notification types
- Timestamps should be human-readable and relative (e.g., "2 hours ago")
- Panel should maintain scroll position when reopening
- Consider pagination or "Load More" for long notification lists
- Follow existing design system for all components

