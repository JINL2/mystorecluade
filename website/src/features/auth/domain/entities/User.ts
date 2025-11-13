/**
 * User Entity
 * Domain layer - Business object for authenticated user
 */

export interface UserMetadata {
  full_name?: string;
  avatar_url?: string;
  [key: string]: any;
}

export class User {
  constructor(
    public readonly id: string,
    public readonly email: string,
    public readonly firstName: string | null,
    public readonly lastName: string | null,
    public readonly emailConfirmed: boolean,
    public readonly createdAt: Date,
    public readonly lastSignIn: Date | null,
    public readonly metadata: UserMetadata = {},
    public readonly userPhoneNumber: string | null = null,
    public readonly profileImage: string | null = null,
    public readonly preferredTimezone: string = 'Asia/Ho_Chi_Minh',
    public readonly isDeleted: boolean = false,
    public readonly updatedAt: Date | null = null
  ) {}

  get displayName(): string {
    if (this.firstName && this.lastName) {
      return `${this.firstName} ${this.lastName}`;
    }
    return this.metadata.full_name || this.email.split('@')[0];
  }

  get initials(): string {
    if (this.firstName && this.lastName) {
      return `${this.firstName[0]}${this.lastName[0]}`.toUpperCase();
    }
    if (this.metadata.full_name) {
      return this.metadata.full_name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .toUpperCase()
        .slice(0, 2);
    }
    return this.email.slice(0, 2).toUpperCase();
  }

  get isEmailVerified(): boolean {
    return this.emailConfirmed;
  }

  static create(data: {
    id: string;
    email: string;
    firstName?: string | null;
    lastName?: string | null;
    emailConfirmed: boolean;
    createdAt: Date | string;
    lastSignIn?: Date | string | null;
    metadata?: UserMetadata;
    userPhoneNumber?: string | null;
    profileImage?: string | null;
    preferredTimezone?: string;
    isDeleted?: boolean;
    updatedAt?: Date | string | null;
  }): User {
    return new User(
      data.id,
      data.email,
      data.firstName || null,
      data.lastName || null,
      data.emailConfirmed,
      data.createdAt instanceof Date ? data.createdAt : new Date(data.createdAt),
      data.lastSignIn
        ? data.lastSignIn instanceof Date
          ? data.lastSignIn
          : new Date(data.lastSignIn)
        : null,
      data.metadata || {},
      data.userPhoneNumber || null,
      data.profileImage || null,
      data.preferredTimezone || 'Asia/Ho_Chi_Minh',
      data.isDeleted || false,
      data.updatedAt
        ? data.updatedAt instanceof Date
          ? data.updatedAt
          : new Date(data.updatedAt)
        : null
    );
  }
}
