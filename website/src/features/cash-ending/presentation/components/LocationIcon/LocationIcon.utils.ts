/**
 * LocationIcon Utility Functions
 */

import type { LocationType } from './LocationIcon.types';

/**
 * Get background color for location type
 */
export const getLocationIconBackground = (type: LocationType): string => {
  switch (type) {
    case 'bank':
      return '#F0F6FF'; // ✅ Toss Blue Surface
    case 'vault':
      return '#FFF4E6'; // ✅ Toss Warning Light
    case 'cash':
      return '#E3FFF4'; // ✅ Toss Success Light
    default:
      return '#F8F9FA'; // ✅ Toss Gray 50
  }
};

/**
 * Get icon color for location type
 */
export const getLocationIconColor = (type: LocationType): string => {
  switch (type) {
    case 'bank':
      return '#0064FF'; // ✅ Toss Blue
    case 'vault':
      return '#FF9500'; // ✅ Toss Orange (Warning)
    case 'cash':
      return '#00C896'; // ✅ Toss Green (Success)
    default:
      return '#6C757D'; // ✅ Toss Gray 600
  }
};

/**
 * Determine location type from location name
 */
export const getLocationTypeFromName = (locationName: string): LocationType => {
  const name = locationName.toLowerCase();
  if (name.includes('bank')) return 'bank';
  if (name.includes('vault')) return 'vault';
  return 'cash';
};

/**
 * Get badge background color for location type
 */
export const getLocationTypeBadgeBackground = (type: LocationType): string => {
  switch (type) {
    case 'bank':
      return '#E3F2FF'; // Blue-50
    case 'vault':
      return '#E0E0E0'; // Gray-300
    case 'cash':
      return '#E8F5E9'; // Green-50
    default:
      return '#F5F5F5';
  }
};

/**
 * Get badge text color for location type
 */
export const getLocationTypeBadgeColor = (type: LocationType): string => {
  switch (type) {
    case 'bank':
      return '#1976D2'; // Blue-700
    case 'vault':
      return '#616161'; // Gray-700
    case 'cash':
      return '#2E7D32'; // Green-700
    default:
      return '#757575';
  }
};

/**
 * Get label text for location type
 */
export const getLocationTypeLabel = (type: LocationType): string => {
  switch (type) {
    case 'bank':
      return 'BANK';
    case 'vault':
      return 'VAULT';
    case 'cash':
      return 'CASH';
    default:
      return 'UNKNOWN';
  }
};
