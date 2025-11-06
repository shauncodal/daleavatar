# Simulation Analysis Loading Page - Figma AI Design Instruction

## Page Overview
A full-screen loading page that shows progress through the analysis stages. This should feel reassuring and provide clear feedback about what's happening.

## Layout Structure

### Full-Screen Container
- **Layout**: Full viewport (100vw x 100vh)
- **Background**: Dark theme background (use existing dark theme color)
- **Display**: Flex column
- **Alignment**: Center all content
- **Padding**: 24px

### Main Content Area (Centered)
- **Width**: Max 600px
- **Layout**: Vertical flex container
- **Alignment**: Center
- **Gap**: 32px between sections

### Logo/Icon Section (Top)
- **Icon**: Company logo or app icon (64px)
- **OR**: Spinning loading indicator (64px)
- **Margin**: Bottom 32px
- **Color**: Primary/lime color

### Progress Indicator
- **Type**: Multi-step progress indicator
- **Layout**: Horizontal with connecting lines
- **Steps**: 2 steps
- **Active Step**: Highlighted with primary color
- **Completed Step**: Checkmark icon + primary color
- **Pending Step**: Gray/disabled color

#### Step 1: Analyzing Simulation
- **State**: Active (when this step is running)
- **Icon**: Spinning loader OR checkmark (when complete)
- **Label**: "Analyzing Simulation"
- **Description**: "Processing audio and video data..." (shown when active)

#### Step 2: Generating Results
- **State**: Pending → Active (when step 1 completes)
- **Icon**: Spinning loader OR checkmark (when complete)
- **Label**: "Generating Results"
- **Description**: "Creating your performance report..." (shown when active)

### Progress Animation
- **Type**: Animated progress bar below steps
- **Width**: 100% of container
- **Height**: 4px
- **Background**: Dark gray (20% opacity)
- **Fill**: Primary/lime color
- **Animation**: Smooth progress from 0% → 50% (step 1) → 100% (step 2)
- **Duration**: 3-5 seconds per step (adjustable)

### Status Text
- **Text**: Dynamic based on current step
  - Step 1: "Analyzing your simulation..."
  - Step 2: "Generating your results..."
- **Font**: Inter Regular, 16px
- **Color**: Text secondary color
- **Alignment**: Center
- **Margin**: Top 16px

### Optional: Percentage Indicator
- **Text**: "X%" (0% → 50% → 100%)
- **Font**: Inter Semi-Bold, 24px
- **Color**: Primary/lime color
- **Alignment**: Center
- **Margin**: Top 8px

## Animation Details

### Step Transitions
- **Fade out**: Current step description fades out (200ms)
- **Progress bar**: Animates to next milestone (1-2 seconds)
- **Fade in**: Next step description fades in (200ms)
- **Icon change**: Spinner changes to checkmark when step completes

### Loading Spinner (if used)
- **Type**: Circular spinner
- **Size**: 48px (for step icons) or 64px (for main icon)
- **Color**: Primary/lime color
- **Speed**: 1 rotation per second
- **Style**: Smooth, continuous rotation

## States

### State 1: Analyzing Simulation (0-50%)
- Step 1: Active (spinner + highlighted)
- Step 2: Pending (gray)
- Progress bar: 0% → 50%
- Status: "Analyzing your simulation..."

### State 2: Generating Results (50-100%)
- Step 1: Complete (checkmark + primary color)
- Step 2: Active (spinner + highlighted)
- Progress bar: 50% → 100%
- Status: "Generating your results..."

### State 3: Complete (100%)
- Step 1: Complete (checkmark)
- Step 2: Complete (checkmark)
- Progress bar: 100%
- Status: "Complete!" (briefly, then redirect)

## Mobile Responsive
- Reduce icon sizes to 48px
- Reduce gap to 24px
- Reduce padding to 16px
- Stack progress steps vertically if needed

