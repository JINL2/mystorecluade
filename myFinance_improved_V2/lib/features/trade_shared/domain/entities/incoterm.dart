/// Incoterms 2020 entity
class Incoterm {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String transportMode; // 'any' or 'sea_only'
  final String? riskTransferPoint;
  final String? costTransferPoint;
  final List<String> sellerResponsibilities;
  final List<String> buyerResponsibilities;
  final int sortOrder;
  final bool isActive;

  const Incoterm({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.transportMode,
    this.riskTransferPoint,
    this.costTransferPoint,
    this.sellerResponsibilities = const [],
    this.buyerResponsibilities = const [],
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Check if this incoterm is for sea transport only
  bool get isSeaOnly => transportMode == 'sea_only';

  /// Check if this incoterm works for any transport mode
  bool get isAnyMode => transportMode == 'any';

  /// Full display name (e.g., "FOB - Free On Board")
  String get fullName => '$code - $name';

  /// Standard Incoterms 2020 list
  static List<Incoterm> get standardList => [
        // Any Transport Mode
        const Incoterm(
          id: '1',
          code: 'EXW',
          name: 'Ex Works',
          description: 'Buyer bears all costs and risks from seller\'s premises',
          transportMode: 'any',
          riskTransferPoint: 'Seller\'s premises',
          costTransferPoint: 'Seller\'s premises',
          sortOrder: 1,
        ),
        const Incoterm(
          id: '2',
          code: 'FCA',
          name: 'Free Carrier',
          description: 'Seller delivers goods to carrier at named place',
          transportMode: 'any',
          riskTransferPoint: 'Named place of delivery',
          costTransferPoint: 'Named place of delivery',
          sortOrder: 2,
        ),
        const Incoterm(
          id: '3',
          code: 'CPT',
          name: 'Carriage Paid To',
          description: 'Seller pays carriage to destination, risk transfers at handover',
          transportMode: 'any',
          riskTransferPoint: 'Handover to carrier',
          costTransferPoint: 'Named destination',
          sortOrder: 3,
        ),
        const Incoterm(
          id: '4',
          code: 'CIP',
          name: 'Carriage and Insurance Paid To',
          description: 'Like CPT but seller also provides insurance',
          transportMode: 'any',
          riskTransferPoint: 'Handover to carrier',
          costTransferPoint: 'Named destination (including insurance)',
          sortOrder: 4,
        ),
        const Incoterm(
          id: '5',
          code: 'DAP',
          name: 'Delivered at Place',
          description: 'Seller delivers goods to named destination, unloaded',
          transportMode: 'any',
          riskTransferPoint: 'Named destination (before unloading)',
          costTransferPoint: 'Named destination (before unloading)',
          sortOrder: 5,
        ),
        const Incoterm(
          id: '6',
          code: 'DPU',
          name: 'Delivered at Place Unloaded',
          description: 'Seller delivers and unloads at destination',
          transportMode: 'any',
          riskTransferPoint: 'Named destination (after unloading)',
          costTransferPoint: 'Named destination (after unloading)',
          sortOrder: 6,
        ),
        const Incoterm(
          id: '7',
          code: 'DDP',
          name: 'Delivered Duty Paid',
          description: 'Seller bears all costs including import duties',
          transportMode: 'any',
          riskTransferPoint: 'Named destination',
          costTransferPoint: 'Named destination (including duties)',
          sortOrder: 7,
        ),
        // Sea and Inland Waterway Only
        const Incoterm(
          id: '8',
          code: 'FAS',
          name: 'Free Alongside Ship',
          description: 'Seller delivers goods alongside vessel at port',
          transportMode: 'sea_only',
          riskTransferPoint: 'Alongside vessel at port',
          costTransferPoint: 'Alongside vessel at port',
          sortOrder: 8,
        ),
        const Incoterm(
          id: '9',
          code: 'FOB',
          name: 'Free On Board',
          description: 'Seller loads goods on vessel, most common for sea freight',
          transportMode: 'sea_only',
          riskTransferPoint: 'On board vessel',
          costTransferPoint: 'On board vessel',
          sortOrder: 9,
        ),
        const Incoterm(
          id: '10',
          code: 'CFR',
          name: 'Cost and Freight',
          description: 'Seller pays freight to destination port',
          transportMode: 'sea_only',
          riskTransferPoint: 'On board vessel',
          costTransferPoint: 'Destination port',
          sortOrder: 10,
        ),
        const Incoterm(
          id: '11',
          code: 'CIF',
          name: 'Cost Insurance and Freight',
          description: 'Seller pays freight and insurance to destination port',
          transportMode: 'sea_only',
          riskTransferPoint: 'On board vessel',
          costTransferPoint: 'Destination port (including insurance)',
          sortOrder: 11,
        ),
      ];

  /// Get incoterm by code
  static Incoterm? getByCode(String code) {
    try {
      return standardList.firstWhere(
        (i) => i.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Payment terms entity
class PaymentTerm {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String paymentTiming; // 'immediate' or 'deferred'
  final int? daysAfterShipment;
  final bool requiresLC;
  final int sortOrder;
  final bool isActive;

  const PaymentTerm({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.paymentTiming,
    this.daysAfterShipment,
    this.requiresLC = false,
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Check if this is immediate payment
  bool get isImmediate => paymentTiming == 'immediate';

  /// Check if this is deferred payment
  bool get isDeferred => paymentTiming == 'deferred';

  /// Standard payment terms list
  static List<PaymentTerm> get standardList => [
        // L/C Terms
        const PaymentTerm(
          id: '1',
          code: 'lc_at_sight',
          name: 'L/C At Sight',
          description: 'Payment upon document presentation',
          paymentTiming: 'immediate',
          requiresLC: true,
          sortOrder: 1,
        ),
        const PaymentTerm(
          id: '2',
          code: 'lc_usance_30',
          name: 'L/C Usance 30 Days',
          paymentTiming: 'deferred',
          daysAfterShipment: 30,
          requiresLC: true,
          sortOrder: 2,
        ),
        const PaymentTerm(
          id: '3',
          code: 'lc_usance_60',
          name: 'L/C Usance 60 Days',
          paymentTiming: 'deferred',
          daysAfterShipment: 60,
          requiresLC: true,
          sortOrder: 3,
        ),
        const PaymentTerm(
          id: '4',
          code: 'lc_usance_90',
          name: 'L/C Usance 90 Days',
          paymentTiming: 'deferred',
          daysAfterShipment: 90,
          requiresLC: true,
          sortOrder: 4,
        ),
        // T/T Terms
        const PaymentTerm(
          id: '10',
          code: 'tt_advance',
          name: 'T/T in Advance (100%)',
          paymentTiming: 'immediate',
          requiresLC: false,
          sortOrder: 10,
        ),
        const PaymentTerm(
          id: '11',
          code: 'tt_against_bl',
          name: 'T/T Against B/L Copy',
          paymentTiming: 'immediate',
          requiresLC: false,
          sortOrder: 11,
        ),
        const PaymentTerm(
          id: '12',
          code: 'tt_30',
          name: 'T/T 30 Days After Shipment',
          paymentTiming: 'deferred',
          daysAfterShipment: 30,
          requiresLC: false,
          sortOrder: 12,
        ),
        // D/A, D/P Terms
        const PaymentTerm(
          id: '20',
          code: 'dp',
          name: 'D/P (Documents against Payment)',
          paymentTiming: 'immediate',
          requiresLC: false,
          sortOrder: 20,
        ),
        const PaymentTerm(
          id: '21',
          code: 'da_30',
          name: 'D/A 30 Days',
          paymentTiming: 'deferred',
          daysAfterShipment: 30,
          requiresLC: false,
          sortOrder: 21,
        ),
      ];
}

/// L/C type entity
class LCType {
  final String id;
  final String code;
  final String name;
  final String? description;
  final bool isRevocable;
  final bool isConfirmed;
  final bool isTransferable;
  final bool isRevolving;
  final bool isStandby;
  final int sortOrder;
  final bool isActive;

  const LCType({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.isRevocable = false,
    this.isConfirmed = false,
    this.isTransferable = false,
    this.isRevolving = false,
    this.isStandby = false,
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Standard L/C types list
  static List<LCType> get standardList => [
        const LCType(
          id: '1',
          code: 'irrevocable',
          name: 'Irrevocable L/C',
          description: 'Standard irrevocable letter of credit (UCP600)',
          sortOrder: 1,
        ),
        const LCType(
          id: '2',
          code: 'confirmed',
          name: 'Confirmed L/C',
          description: 'Irrevocable L/C with confirmation from another bank',
          isConfirmed: true,
          sortOrder: 2,
        ),
        const LCType(
          id: '3',
          code: 'transferable',
          name: 'Transferable L/C',
          description: 'Can be transferred to third party',
          isTransferable: true,
          sortOrder: 3,
        ),
        const LCType(
          id: '4',
          code: 'revolving',
          name: 'Revolving L/C',
          description: 'Amount restores after each use',
          isRevolving: true,
          sortOrder: 4,
        ),
        const LCType(
          id: '5',
          code: 'standby',
          name: 'Standby L/C (SBLC)',
          description: 'Performance/payment guarantee',
          isStandby: true,
          sortOrder: 5,
        ),
      ];
}

/// Document type entity
class TradeDocumentType {
  final String id;
  final String code;
  final String name;
  final String? nameShort;
  final String? description;
  final String category; // transport, commercial, insurance, certificate, financial, other
  final bool commonlyRequired;
  final int sortOrder;
  final bool isActive;

  const TradeDocumentType({
    required this.id,
    required this.code,
    required this.name,
    this.nameShort,
    this.description,
    required this.category,
    this.commonlyRequired = false,
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Display name with short code
  String get displayName => nameShort != null ? '$nameShort - $name' : name;

  /// Standard document types
  static List<TradeDocumentType> get standardList => [
        // Transport
        const TradeDocumentType(
          id: '1', code: 'bill_of_lading', name: 'Bill of Lading',
          nameShort: 'B/L', category: 'transport', commonlyRequired: true, sortOrder: 1,
        ),
        const TradeDocumentType(
          id: '2', code: 'airway_bill', name: 'Air Waybill',
          nameShort: 'AWB', category: 'transport', commonlyRequired: true, sortOrder: 2,
        ),
        // Commercial
        const TradeDocumentType(
          id: '10', code: 'commercial_invoice', name: 'Commercial Invoice',
          nameShort: 'CI', category: 'commercial', commonlyRequired: true, sortOrder: 10,
        ),
        const TradeDocumentType(
          id: '11', code: 'packing_list', name: 'Packing List',
          nameShort: 'PL', category: 'commercial', commonlyRequired: true, sortOrder: 11,
        ),
        // Insurance
        const TradeDocumentType(
          id: '20', code: 'insurance_certificate', name: 'Insurance Certificate',
          nameShort: 'INS', category: 'insurance', commonlyRequired: true, sortOrder: 20,
        ),
        // Certificates
        const TradeDocumentType(
          id: '30', code: 'certificate_of_origin', name: 'Certificate of Origin',
          nameShort: 'COO', category: 'certificate', commonlyRequired: true, sortOrder: 30,
        ),
        const TradeDocumentType(
          id: '31', code: 'inspection_certificate', name: 'Inspection Certificate',
          nameShort: 'IC', category: 'certificate', sortOrder: 31,
        ),
        const TradeDocumentType(
          id: '32', code: 'quality_certificate', name: 'Quality Certificate',
          nameShort: 'QC', category: 'certificate', sortOrder: 32,
        ),
      ];
}

/// Shipping method entity
class ShippingMethod {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String? transportDocumentCode;
  final int sortOrder;
  final bool isActive;

  const ShippingMethod({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.transportDocumentCode,
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Standard shipping methods
  static List<ShippingMethod> get standardList => [
        const ShippingMethod(
          id: '1', code: 'sea', name: 'Sea Freight (FCL/LCL)',
          transportDocumentCode: 'bill_of_lading', sortOrder: 1,
        ),
        const ShippingMethod(
          id: '2', code: 'air', name: 'Air Freight',
          transportDocumentCode: 'airway_bill', sortOrder: 2,
        ),
        const ShippingMethod(
          id: '3', code: 'road', name: 'Road/Truck',
          transportDocumentCode: 'truck_receipt', sortOrder: 3,
        ),
        const ShippingMethod(
          id: '4', code: 'rail', name: 'Rail',
          transportDocumentCode: 'rail_consignment', sortOrder: 4,
        ),
        const ShippingMethod(
          id: '5', code: 'multimodal', name: 'Multimodal',
          transportDocumentCode: 'multimodal_transport', sortOrder: 5,
        ),
        const ShippingMethod(
          id: '6', code: 'courier', name: 'Courier/Express',
          transportDocumentCode: 'courier_receipt', sortOrder: 6,
        ),
      ];
}

/// Freight term entity
class FreightTerm {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String payer; // seller, buyer, third_party
  final int sortOrder;
  final bool isActive;

  const FreightTerm({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.payer,
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Standard freight terms
  static List<FreightTerm> get standardList => [
        const FreightTerm(
          id: '1', code: 'prepaid', name: 'Freight Prepaid',
          description: 'Seller pays freight in advance', payer: 'seller', sortOrder: 1,
        ),
        const FreightTerm(
          id: '2', code: 'collect', name: 'Freight Collect',
          description: 'Buyer pays freight at destination', payer: 'buyer', sortOrder: 2,
        ),
        const FreightTerm(
          id: '3', code: 'prepaid_and_add', name: 'Prepaid and Add',
          description: 'Seller pays then invoices buyer', payer: 'seller', sortOrder: 3,
        ),
        const FreightTerm(
          id: '4', code: 'third_party', name: 'Third Party Freight',
          description: 'Third party (forwarder) pays', payer: 'third_party', sortOrder: 4,
        ),
      ];
}
