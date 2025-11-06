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
    public readonly emailConfirmed: boolean,
    public readonly createdAt: Date,
    public readonly lastSignIn: Date | null,
    public readonly metadata: UserMetadata = {}
  ) {}

  get displayName(): string {
    return this.metadata.full_name || this.email.split('@')[0];
  }

  get initials(): string {
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
    emailConfirmed: boolean;
    createdAt: Date | string;
    lastSignIn?: Date | string | null;
    metadata?: UserMetadata;
  }): User {
    return new User(
      data.id,
      data.email,
      data.emailConfirmed,
      data.createdAt instanceof Date ? data.createdAt : new Date(data.createdAt),
      data.lastSignIn
        ? data.lastSignIn instanceof Date
          ? data.lastSignIn
          : new Date(data.lastSignIn)
        : null,
      data.metadata || {}
    );
  }
}
