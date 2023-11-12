String rateToZone(int hb) {
  if (hb <= 111) {
    return "Zone 1";
  } else if (hb <= 129) {
    return "Zone 2";
  } else if (hb <= 148) {
    return "Zone 3";
  } else if (hb <= 166) {
    return "Zone 4";
  } else {
    return "Zone 5";
  }
}
