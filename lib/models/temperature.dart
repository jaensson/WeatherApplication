class Temperature {
  int temperature;

  Temperature(this.temperature);

  @override
  String toString() {
    return "$temperature \u2103";
  }
}
