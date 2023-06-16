extension DateTimeFormatting on DateTime {
  String formatDay() {
    // Day and month should always have dwo digits
    // Sor example January should be displayed as `01`, not `1`

    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');

    return "$day.$month.$year";
  }
}
