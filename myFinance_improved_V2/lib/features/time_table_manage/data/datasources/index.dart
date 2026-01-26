// Time Table Datasources
//
// Barrel export file for all time table datasources.
// Use this to import all datasources at once:
// import 'package:myfinance_improved/features/time_table_manage/data/datasources/index.dart';

// Specialized datasources (for granular DI or direct usage)
export 'employee_datasource.dart';
export 'manager_card_datasource.dart';
export 'schedule_datasource.dart';
export 'shift_datasource.dart';
// Main facade (recommended for general use - maintains backward compatibility)
export 'time_table_datasource.dart';
