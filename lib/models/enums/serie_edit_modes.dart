enum SerieEditModeType { none, single, onlyFuture, all }

extension SerieEditModeTypeExtension on SerieEditModeType {
  String get name {
    switch (this) {
      case SerieEditModeType.none:
        return 'Keins';
      case SerieEditModeType.single:
        return 'Einzeln';
      case SerieEditModeType.onlyFuture:
        return 'Nur zukünftige';
      case SerieEditModeType.all:
        return 'Alle';
      default:
        throw Exception('$name is not a valid Serie Edit Mode type.');
    }
  }
}
