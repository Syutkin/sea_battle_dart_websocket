class Coordinates {
  int x;
  int y;

  static const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

  Coordinates({required this.x, required this.y});

  static Coordinates? tryParse(String input) {
    int? x;
    int? y;

    final exp_a1 = RegExp(r'^([A-J])([1-9]|10)$');
    final exp_1a = RegExp(r'^([1-9]|10)([A-J])$');

    input = input.trim().toUpperCase().replaceAll(' ', '');

    var match = exp_a1.firstMatch(input);

    if (match != null) {
      x = letters.indexOf(match.group(1)!);

      y = int.parse(match.group(2)!) - 1;
    } else {
      match = exp_1a.firstMatch(input);
      if (match != null) {
        x = letters.indexOf(match.group(2)!);
        y = int.parse(match.group(1)!) - 1;
      }
    }
    if (x == null || y == null) {
      return null;
    }
    return Coordinates(x: x, y: y);
  }

  @override
  String toString() {
    return '${letters[x]}${y+1}';
  }
}
