/**
 * LocationIcon Component Types
 */

export type LocationType = 'bank' | 'vault' | 'cash';

export interface LocationIconProps {
  type: LocationType;
  size?: number;
}
