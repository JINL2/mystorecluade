/**
 * LocationIcon Component
 * Reusable icon component for different cash location types
 */

import React from 'react';
import type { LocationIconProps } from './LocationIcon.types';

export const LocationIcon: React.FC<LocationIconProps> = ({ type, size = 16 }) => {
  switch (type) {
    case 'bank':
      return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
          <path
            d="M12 4L4 8V9H20V9L12 4Z"
            stroke="currentColor"
            strokeWidth="2.5"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
          <rect x="6" y="10" width="2" height="6" stroke="currentColor" strokeWidth="2" />
          <rect x="11" y="10" width="2" height="6" stroke="currentColor" strokeWidth="2" />
          <rect x="16" y="10" width="2" height="6" stroke="currentColor" strokeWidth="2" />
          <rect x="4" y="17" width="16" height="2" fill="currentColor" />
        </svg>
      );

    case 'vault':
      return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
          <rect x="5" y="5" width="16" height="16" rx="2" stroke="currentColor" strokeWidth="2.5" />
          <circle cx="12" cy="12" r="3" stroke="currentColor" strokeWidth="2" />
          <circle cx="12" cy="12" r="1" fill="currentColor" />
        </svg>
      );

    case 'cash':
    default:
      return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
          <ellipse cx="12" cy="8" rx="6" ry="2.5" stroke="currentColor" strokeWidth="2.5" />
          <path
            d="M6 8V12C6 13.1 8.686 14 12 14C15.314 14 18 13.1 18 12V8"
            stroke="currentColor"
            strokeWidth="2.5"
          />
          <path
            d="M6 12V16C6 17.1 8.686 18 12 18C15.314 18 18 17.1 18 16V12"
            stroke="currentColor"
            strokeWidth="2.5"
          />
        </svg>
      );
  }
};
