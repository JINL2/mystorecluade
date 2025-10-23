/// Shift data model representing a shift schedule
///
/// Contains basic shift information including start time, end time, and store location
class ShiftData {
  final String startTime;
  final String endTime;
  final String store;

  const ShiftData(this.startTime, this.endTime, this.store);
}
