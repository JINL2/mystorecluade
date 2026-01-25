/// Shipment Constants - Domain Layer
///
/// Single source of truth for shipment-related constants.
/// Contains status definitions, shipping methods, and other static values.
library;

/// Shipment Feature Permission ID
class ShipmentPermissions {
  ShipmentPermissions._();

  /// Feature ID for shipment feature access
  static const String featureId = '0d76406c-2c45-422c-bc5a-ca6ebb0b4153';
}

/// Shipment Status Constants
class ShipmentStatusConstants {
  ShipmentStatusConstants._();

  static const String draft = 'draft';
  static const String booked = 'booked';
  static const String shipped = 'shipped';
  static const String inTransit = 'in_transit';
  static const String arrived = 'arrived';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';

  static const List<String> all = [
    draft,
    booked,
    shipped,
    inTransit,
    arrived,
    delivered,
    cancelled,
  ];

  static const List<String> active = [
    draft,
    booked,
    shipped,
    inTransit,
  ];

  static const List<String> completed = [
    arrived,
    delivered,
  ];
}

/// Shipping Method Constants
class ShippingMethodConstants {
  ShippingMethodConstants._();

  static const String sea = 'sea';
  static const String air = 'air';
  static const String land = 'land';
  static const String rail = 'rail';
  static const String multimodal = 'multimodal';

  static const List<String> all = [sea, air, land, rail, multimodal];

  static const Map<String, String> labels = {
    sea: 'Sea Freight',
    air: 'Air Freight',
    land: 'Land Transport',
    rail: 'Rail Transport',
    multimodal: 'Multimodal',
  };
}

/// Bill of Lading Type Constants
class BLTypeConstants {
  BLTypeConstants._();

  static const String original = 'original';
  static const String seaway = 'seaway';
  static const String express = 'express';
  static const String surrendered = 'surrendered';

  static const List<String> all = [original, seaway, express, surrendered];

  static const Map<String, String> labels = {
    original: 'Original B/L',
    seaway: 'Seaway Bill',
    express: 'Express B/L',
    surrendered: 'Surrendered B/L',
  };
}

/// Freight Terms Constants
class FreightTermsConstants {
  FreightTermsConstants._();

  static const String prepaid = 'prepaid';
  static const String collect = 'collect';

  static const List<String> all = [prepaid, collect];

  static const Map<String, String> labels = {
    prepaid: 'Prepaid',
    collect: 'Collect',
  };
}

/// Package Type Constants
class PackageTypeConstants {
  PackageTypeConstants._();

  static const String carton = 'carton';
  static const String pallet = 'pallet';
  static const String crate = 'crate';
  static const String drum = 'drum';
  static const String bag = 'bag';
  static const String bundle = 'bundle';
  static const String roll = 'roll';
  static const String container = 'container';

  static const List<String> all = [
    carton,
    pallet,
    crate,
    drum,
    bag,
    bundle,
    roll,
    container,
  ];

  static const Map<String, String> labels = {
    carton: 'Carton',
    pallet: 'Pallet',
    crate: 'Crate',
    drum: 'Drum',
    bag: 'Bag',
    bundle: 'Bundle',
    roll: 'Roll',
    container: 'Container',
  };
}

/// Container Type Constants
class ContainerTypeConstants {
  ContainerTypeConstants._();

  static const String dry20 = '20DC';
  static const String dry40 = '40DC';
  static const String highCube40 = '40HC';
  static const String reefer20 = '20RF';
  static const String reefer40 = '40RF';
  static const String openTop20 = '20OT';
  static const String openTop40 = '40OT';
  static const String flatRack20 = '20FR';
  static const String flatRack40 = '40FR';

  static const List<String> all = [
    dry20,
    dry40,
    highCube40,
    reefer20,
    reefer40,
    openTop20,
    openTop40,
    flatRack20,
    flatRack40,
  ];

  static const Map<String, String> labels = {
    dry20: "20' Dry Container",
    dry40: "40' Dry Container",
    highCube40: "40' High Cube",
    reefer20: "20' Reefer",
    reefer40: "40' Reefer",
    openTop20: "20' Open Top",
    openTop40: "40' Open Top",
    flatRack20: "20' Flat Rack",
    flatRack40: "40' Flat Rack",
  };
}
