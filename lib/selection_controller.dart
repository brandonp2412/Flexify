class SelectionController<T> {
  final Set<T> _selected = {};

  Set<T> get selected => _selected;
  bool get isEmpty => _selected.isEmpty;
  bool get isNotEmpty => _selected.isNotEmpty;
  int get length => _selected.length;

  bool contains(T item) => _selected.contains(item);
  T get first => _selected.first;
  List<T> toList() => _selected.toList();

  void add(T item) => _selected.add(item);
  void remove(T item) => _selected.remove(item);

  void toggle(T item) {
    if (_selected.contains(item))
      _selected.remove(item);
    else
      _selected.add(item);
  }

  void setAll(Iterable<T> items) => _selected.addAll(items);
  void clear() => _selected.clear();
}
