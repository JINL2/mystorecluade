# Employee Schedule Page Design Specification

## Overview
The Employee Schedule page provides a modern, intuitive drag-and-drop interface for managers to create and manage employee work schedules. The design follows the Toss design system while incorporating best practices for scheduling interfaces.

## Key Design Features

### 1. Store Filter (Top Control Bar)
- **Location**: Top-left of control bar
- **Design**: Matches the employee settings page implementation
- **Functionality**: 
  - Dropdown to select specific store or "All Stores"
  - Visual feedback on hover and active states
  - Persistent selection across sessions
  - Same styling and behavior as employee settings page for consistency

### 2. Control Bar Components

#### Week Navigation
- **Previous/Next buttons**: Navigate between weeks
- **Current week display**: Shows date range (e.g., "Dec 16 - Dec 22")
- **Today button**: Quick return to current week
- **Design**: Clean, minimal buttons with hover effects

#### View Toggle
- **Options**: Day, Week, Month views
- **Default**: Week view
- **Style**: Segmented control with active state highlighting
- **Responsive**: Adapts to screen size

#### Action Buttons
- **Save Draft**: Ghost button style for secondary action
- **Publish Schedule**: Primary button for main action
- **Icons**: Meaningful icons to enhance understanding

### 3. Schedule Grid Layout

#### Grid Structure
- **Columns**: Time column + 7 day columns
- **Rows**: Time slots (configurable, default 4-hour blocks)
- **Headers**: 
  - Days with date numbers
  - Today highlighted in blue (#0064FF)
  - Time labels in left column

#### Visual Design
- **Background**: Clean white with subtle borders
- **Borders**: Light gray (#e5e7eb) for structure
- **Spacing**: Consistent padding for readability
- **Shadows**: Subtle shadows for depth

### 4. Drag and Drop Interface

#### Employee Pool (Sidebar)
- **Position**: Fixed right sidebar on desktop, bottom sheet on mobile
- **Content**: List of available employees
- **Design Elements**:
  - Employee avatar with initials
  - Name and role display
  - Available hours indicator
  - Drag handle indicator (appears on hover)

#### Draggable Employee Cards
- **Visual Affordances**:
  - Cursor changes to "grab" on hover
  - Subtle lift effect on hover (translateX)
  - Drag handle dots appear on hover
  - Shadow increases when dragging

- **Drag States**:
  - **Default**: Normal card appearance
  - **Hover**: Background change, slight movement
  - **Dragging**: Opacity reduced, scale decreased, rotation effect
  - **Being Dragged**: Fixed position, elevated shadow

#### Drop Zones
- **Visual Feedback**:
  - Background color change on dragover
  - Dashed border appears
  - Drop indicator line shows exact placement
  - Smooth transitions for all states

#### Scheduled Shift Blocks
- **Design**: 
  - Gradient background (Toss blue)
  - White text for contrast
  - Rounded corners for modern look
  - Shadow for depth

- **Information Display**:
  - Employee name
  - Shift time
  - Remove button (X) appears on hover

- **Interactions**:
  - Hover: Lift effect with increased shadow
  - Draggable for rescheduling
  - Click to edit details

### 5. Stats Summary Bar
- **Location**: Bottom of schedule container
- **Content**:
  - Total hours scheduled
  - Number of shifts
  - Employee count
  - Conflict indicators

- **Design**: 
  - Gray background for separation
  - Clear labels and values
  - Conflict indicator in red when issues exist

### 6. Responsive Design

#### Desktop (>1400px)
- Full layout with sidebar
- Optimal spacing and sizing
- All features visible

#### Tablet (768px - 1400px)
- Employee pool moves below schedule
- Grid layout maintained
- Touch-friendly sizing

#### Mobile (<768px)
- Employee pool as bottom sheet
- Horizontal scroll for schedule grid
- Stacked controls in control bar
- Larger touch targets

## Color Scheme
- **Primary**: Toss Blue (#0064FF)
- **Background**: Light gray (#f9fafb)
- **White**: Card backgrounds (#ffffff)
- **Borders**: Light gray (#e5e7eb, #f3f4f6)
- **Text Primary**: Dark gray (#1a1a1a)
- **Text Secondary**: Medium gray (#6b7280)
- **Success**: Green (#10b981)
- **Error/Conflict**: Red (#dc2626)

## Typography
- **Page Title**: 28px, Bold (700)
- **Section Headers**: 14px, Semi-bold (600)
- **Body Text**: 14px, Regular (400)
- **Labels**: 12px, Medium (500)
- **Small Text**: 11px, Regular (400)

## Interaction Patterns

### Drag and Drop Flow
1. **Initiate**: Click and hold on employee card
2. **Drag**: Visual feedback (opacity, cursor, shadow)
3. **Hover**: Drop zones highlight when valid
4. **Drop**: Smooth animation to final position
5. **Confirm**: Shift block appears with employee info

### Store Filter Flow
1. **Click**: Dropdown opens with animation
2. **Select**: Store option highlighted
3. **Apply**: Schedule updates for selected store
4. **Persist**: Selection saved for future sessions

### Conflict Resolution
- Visual indicators for conflicts (red highlights)
- Tooltip on hover explaining conflict
- Prevent invalid drops with visual feedback
- Suggest alternative time slots

## Accessibility Considerations
- **Keyboard Navigation**: Full keyboard support for all interactions
- **ARIA Labels**: Proper labels for screen readers
- **Color Contrast**: WCAG AA compliant contrast ratios
- **Focus Indicators**: Clear focus states for keyboard users
- **Alternative Input**: Non-drag methods available (click to select, then click destination)

## Performance Optimizations
- **Smooth Animations**: CSS transitions for performance
- **Debounced Updates**: Batch updates to prevent lag
- **Virtual Scrolling**: For large employee lists
- **Lazy Loading**: Load schedule data as needed
- **Optimistic Updates**: Immediate visual feedback

## Future Enhancements
1. **Shift Templates**: Save and reuse common shift patterns
2. **Auto-Schedule**: AI-powered schedule suggestions
3. **Employee Preferences**: Show preferred/blocked times
4. **Shift Swapping**: Employee-initiated shift trades
5. **Labor Cost Display**: Real-time cost calculations
6. **Compliance Checks**: Automatic labor law validation
7. **Mobile App**: Native mobile experience
8. **Notifications**: Alert employees of schedule changes
9. **Reporting**: Schedule analytics and insights
10. **Integration**: Sync with payroll and time tracking systems

## Implementation Notes
- Use native HTML5 drag and drop API
- Consider touch-friendly libraries for mobile (e.g., Sortable.js)
- Implement proper state management for undo/redo
- Add loading states for async operations
- Include error handling for failed saves
- Provide offline capability with local storage

## Design Principles Followed
1. **Clarity**: Clear visual hierarchy and information architecture
2. **Efficiency**: Minimize clicks/taps to complete tasks
3. **Feedback**: Immediate visual response to all interactions
4. **Consistency**: Follows Toss design system patterns
5. **Flexibility**: Supports multiple workflows and views
6. **Simplicity**: Clean, uncluttered interface
7. **Trust**: Professional appearance with smooth interactions