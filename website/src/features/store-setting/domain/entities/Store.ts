export class Store {
  constructor(
    public readonly storeId: string,
    public readonly companyId: string,
    public readonly storeName: string,
    public readonly address: string | null,
    public readonly phone: string | null,
    public readonly isActive: boolean
  ) {}
  get displayName(): string { return this.storeName; }
}
