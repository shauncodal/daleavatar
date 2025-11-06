# Recording Report Page - Figma AI Design Instruction

## Page Overview
A comprehensive report page showing detailed analysis of the simulation session. This should feel like a professional performance review with clear metrics, insights, and actionable feedback.

## Layout Structure

### Header Section (Persistent)
- **Height**: 64px
- **Background**: Use existing header background
- **Layout**: Horizontal flex container
- **Padding**: 16px horizontal
- **Elements**:
  - Back button (left): Arrow icon, returns to previous screen
  - Title (center): "Simulation Report" or "Performance Report"
  - Spacer (flexible)
  - Optional: Share/Export button (right)

### Main Content Area
- **Container**: Max width 1200px, centered
- **Padding**: 24px horizontal, 16px vertical
- **Layout**: Single column, vertical stack
- **Gap**: 24px between sections

## Section 1: Report Header Card
- **Card Style**: Use existing card component
- **Padding**: 20px all around
- **Layout**: Horizontal flex container
- **Background**: Use card background color
- **Border**: 1px solid, use border color
- **Border Radius**: 12px

### Left Side (Info)
- **Date/Time**: 
  - Icon: Calendar icon (16px)
  - Text: "MMM dd, yyyy • hh:mm a" format
  - Font: Inter Regular, 14px
  - Color: Text secondary
- **Duration**: 
  - Spacing: 8px margin top
  - Text: "Duration: X:XX minutes"
  - Font: Inter Regular, 14px
  - Color: Text secondary
- **Status Badge**:
  - Background: Green (success) or gray
  - Text: "READY" (uppercase)
  - Font: Inter Bold, 12px
  - Color: White
  - Padding: 4px 12px
  - Border Radius: 12px
  - Margin: 8px top

### Right Side (Quick Stats)
- **Layout**: Horizontal flex, gap 24px
- **Stat Items**:
  - **Engagement Score**: Large number (36px, bold), label below (12px)
  - **Confidence**: Large number (36px, bold), label below (12px)
  - **Overall Score**: Large number (36px, bold), label below (12px)

## Section 2: Key Metrics Grid
- **Title**: "Key Metrics" (use heading style, 20px, bold)
- **Layout**: Grid, 2 columns (4 items total)
- **Gap**: 12px
- **Card Style**: Each metric in own card
- **Card Properties**:
  - Background: Use card background
  - Border: 1px solid
  - Border Radius: 12px
  - Padding: 16px
  - Aspect Ratio: 1.5:1

### Metric Cards
Each card contains:
- **Value**: Large number (32px, bold), colored by metric type
  - Engagement: Blue
  - Confidence: Green
  - Rapport: Purple
  - Question Quality: Teal
- **Label**: Text below value (14px, secondary color)
- **Optional**: Small trend indicator (up/down arrow)

## Section 3: Engagement Analysis
- **Title**: "Engagement Analysis" (use heading style, 20px, bold)
- **Card Style**: Single card with padding 20px
- **Border Radius**: 12px

### Content
- **Listening Time Progress Bar**:
  - Label: "Listening Time" (left), Percentage (right, bold)
  - Progress bar: Blue color, 8px height, rounded
  - Value: 65% (example)
  
- **Talking Time Progress Bar**:
  - Label: "Talking Time" (left), Percentage (right, bold)
  - Progress bar: Orange color, 8px height, rounded
  - Value: 35% (example)
  - Spacing: 12px below listening time

- **Stats Row**:
  - Layout: Horizontal, space-around
  - Items: "Questions Asked", "Responses Given", "Interruptions"
  - Each item: Large number (24px, bold) on top, label (12px, secondary) below
  - Spacing: 16px top margin

## Section 4: Tone & Delivery
- **Title**: "Tone & Delivery" (use heading style, 20px, bold)
- **Card Style**: Single card with padding 20px
- **Border Radius**: 12px

### Progress Bars (Vertical Stack)
Each metric with:
- **Label**: Left side (14px, regular)
- **Value**: Right side (16px, bold)
- **Progress Bar**: 8px height, rounded, colored by metric
  - Confidence: Green
  - Enthusiasm: Orange
  - Professionalism: Blue
  - Friendliness: Purple
- **Spacing**: 12px between each bar

### Speaking Pace
- **Layout**: Row, space-between
- **Label**: "Speaking Pace"
- **Value**: "68 WPM" (bold)

## Section 5: Areas for Improvement
- **Title**: "Areas for Improvement" (use heading style, 20px, bold)
- **Layout**: Vertical stack of cards
- **Gap**: 8px between cards

### Improvement Cards
Each card:
- **Background**: Colored by severity (10% opacity)
  - High: Red tint
  - Medium: Orange tint
  - Low: Yellow tint
- **Border Radius**: 8px
- **Padding**: 16px
- **Layout**: Row with icon, content, and optional timestamp

**Left Side**:
- **Icon**: Warning icon (24px), colored by severity
- **Spacing**: 12px gap

**Right Side (Flex)**:
- **Title**: Mistake type (16px, bold, colored by severity)
- **Description**: Full text (14px, regular)
- **Timestamp**: "Time: 00:45" (12px, italic, secondary color)
- **Impact**: "Impact: [description]" (12px, regular)

## Section 6: Key Insights
- **Title**: "Key Insights" (use heading style, 20px, bold)
- **Layout**: Vertical stack of cards
- **Gap**: 8px between cards

### Insight Cards
Each card:
- **Background**: Colored by score type (10% opacity)
  - Positive: Green tint
  - Improvement: Orange tint
- **Border Radius**: 8px
- **Padding**: 16px
- **Layout**: Row with icon and content

**Left Side**:
- **Icon**: Check circle (positive) or Info icon (improvement), 24px
- **Spacing**: 12px gap

**Right Side (Flex)**:
- **Title**: Insight title (16px, bold, colored by score)
- **Description**: Full text (14px, regular)

## Section 7: Sales Performance
- **Title**: "Sales Performance" (use heading style, 20px, bold)
- **Card Style**: Single card with padding 20px
- **Border Radius**: 12px

### Metrics List
Vertical list of metrics, each with:
- **Layout**: Row, space-between
- **Label**: Left side (16px, regular)
- **Value**: Right side (16px, bold)
- **Divider**: Between items (1px, use divider color)

Metrics:
- Total Duration
- Speaking Ratio
- Objection Handling
- Closing Attempts

## Color Scheme
- **Primary Text**: Use existing text primary color
- **Secondary Text**: Use existing text secondary color
- **Success/Positive**: Green (#10B981 or similar)
- **Warning**: Orange (#F59E0B or similar)
- **Error/High Severity**: Red (#EF4444 or similar)
- **Info**: Blue (#3B82F6 or similar)
- **Metric Colors**: 
  - Engagement: Blue
  - Confidence: Green
  - Rapport: Purple
  - Question Quality: Teal

## Typography
- **Headings**: Inter Semi-Bold, 20px
- **Body**: Inter Regular, 14px
- **Labels**: Inter Regular, 12-14px
- **Values**: Inter Bold, 16-36px (depending on size)
- **Secondary Text**: Inter Regular, 12px

## Spacing
- **Section Gap**: 24px
- **Card Padding**: 16-20px
- **Element Gap**: 8-12px
- **Content Padding**: 24px horizontal

## Mobile Responsive
- **Grid**: 1 column on mobile (< 768px)
- **Cards**: Full width
- **Stats Row**: Stack vertically on mobile
- **Padding**: Reduce to 16px on mobile
- **Font Sizes**: Slightly smaller on mobile (reduce by 2px)

