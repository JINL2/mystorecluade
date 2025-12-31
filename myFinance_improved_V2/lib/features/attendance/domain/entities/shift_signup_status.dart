/// Shift signup status determining the action button state
enum ShiftSignupStatus {
  available, // Can apply - shows blue "+ Apply" button
  waitlist, // Full but can waitlist - shows gray "+ Waitlist" button
  onWaitlist, // User is on waitlist - shows gray outline "- Leave" button
  applied, // Already applied - shows blue outline "- Withdraw" button
  assigned, // Already assigned - shows gray "Assigned" badge
}
