import 'dart:typed_data';

/// Thrown when a file is not a readable LMDB environment.
final class LmdbFormatException implements Exception {
  const LmdbFormatException(this.message);

  final String message;

  @override
  String toString() => 'LmdbFormatException: $message';
}

/// Minimal read-only walker over the main database of an LMDB data file.
///
/// ObjectBox stores its data in an LMDB environment (`data.mdb`). This reader
/// only implements what a one-time export needs: it picks the most recent
/// committed meta page, then walks the main B+tree in key order, following
/// overflow pages for large values. The page size is read from the file, so
/// databases written on any device (4 KiB or 16 KiB pages) can be read.
///
/// ObjectBox uses 64-bit page numbers and sizes on every platform, including
/// 32-bit ARM, which is the only layout supported here.
final class LmdbReader {
  LmdbReader(this._data) : _view = ByteData.sublistView(_data) {
    _readMeta();
  }

  static const _magic = 0xBEEFC0DE;
  static const _dataVersion = 1;

  // Page layout: pgno u64, pad u16, flags u16, lower u16, upper u16.
  static const _pageHeaderSize = 16;
  static const _flagsOffset = 10;
  static const _lowerOffset = 12;

  // MDB_meta (after the page header): magic u32, version u32, address u64,
  // mapsize u64, dbs[2] (free, main), last_pg u64, txnid u64.
  // MDB_db: pad u32, flags u16, depth u16, branch/leaf/overflow pages u64,
  // entries u64, root u64.
  static const _dbsOffset = 24;
  static const _dbSize = 48;
  static const _txnIdOffset = _dbsOffset + 2 * _dbSize + 8;

  // Page flags.
  static const _pBranch = 0x01;
  static const _pLeaf = 0x02;

  // Node flags.
  static const _fBigData = 0x01;
  static const _fSubData = 0x02;
  static const _fDupData = 0x04;

  final Uint8List _data;
  final ByteData _view;

  late final int _pageSize;
  late final int _root;
  late final int _depth;
  late final int _entries;

  int _u16(int offset) => _view.getUint16(offset, Endian.little);
  int _u32(int offset) => _view.getUint32(offset, Endian.little);
  int _u64(int offset) => _view.getUint64(offset, Endian.little);

  void _readMeta() {
    if (_data.length < 2 * 512) throw const LmdbFormatException('file too small');
    if (_u32(_pageHeaderSize) != _magic) throw const LmdbFormatException('bad magic');
    // The free DB's `md_pad` holds the page size.
    final pageSize = _u32(_pageHeaderSize + _dbsOffset);
    if (pageSize < 512 || pageSize > 65536 || pageSize & (pageSize - 1) != 0) {
      throw LmdbFormatException('invalid page size $pageSize');
    }
    _pageSize = pageSize;

    ({int txnId, int mainDb})? meta(int page) {
      final base = page * pageSize + _pageHeaderSize;
      if (base + _txnIdOffset + 8 > _data.length) return null;
      if (_u32(base) != _magic || _u32(base + 4) != _dataVersion) return null;
      return (txnId: _u64(base + _txnIdOffset), mainDb: base + _dbsOffset + _dbSize);
    }

    // Two meta pages alternate between commits; the higher txnid is current.
    final current = switch ((meta(0), meta(1))) {
      (null, null) => throw const LmdbFormatException('no valid meta page'),
      (final a?, null) => a,
      (null, final b?) => b,
      (final a?, final b?) => a.txnId >= b.txnId ? a : b,
    };
    _depth = _u16(current.mainDb + 6);
    _entries = _u64(current.mainDb + 32);
    _root = _u64(current.mainDb + 40);
  }

  /// Iterates the key/value pairs of the main database in key order.
  /// Keys and values are zero-copy views on the file buffer.
  Iterable<(Uint8List key, Uint8List value)> entries() sync* {
    // An empty database has no root page (P_INVALID = all bits set).
    if (_entries == 0 || _root == -1) return;
    yield* _walk(_root, 1);
  }

  Iterable<(Uint8List, Uint8List)> _walk(int page, int level) sync* {
    if (level > _depth) throw LmdbFormatException('tree deeper than recorded depth $_depth');
    final offset = _pageOffset(page);
    final flags = _u16(offset + _flagsOffset);
    final isBranch = flags & _pBranch != 0;
    if (!isBranch && flags & _pLeaf == 0) {
      throw LmdbFormatException('page $page is neither branch nor leaf (flags $flags)');
    }
    final nodeCount = (_u16(offset + _lowerOffset) - _pageHeaderSize) >> 1;

    for (var i = 0; i < nodeCount; i++) {
      // Node: lo u16, hi u16, flags u16, ksize u16, key, data.
      final node = offset + _u16(offset + _pageHeaderSize + 2 * i);
      final lo = _u16(node);
      final hi = _u16(node + 2);
      final nodeFlags = _u16(node + 4);
      final keySize = _u16(node + 6);
      final keyOffset = node + 8;

      if (isBranch) {
        // Branch nodes store the child page number across lo/hi/flags.
        yield* _walk(lo | hi << 16 | nodeFlags << 32, level + 1);
        continue;
      }
      // Named sub-databases and duplicate sets are not used for object data.
      if (nodeFlags & (_fSubData | _fDupData) != 0) continue;

      final key = _slice(keyOffset, keySize);
      final dataSize = lo | hi << 16;
      final dataOffset = nodeFlags & _fBigData != 0
          // Large values live in contiguous overflow pages.
          ? _pageOffset(_u64(keyOffset + keySize)) + _pageHeaderSize
          : keyOffset + keySize;
      yield (key, _slice(dataOffset, dataSize));
    }
  }

  int _pageOffset(int page) {
    final offset = page * _pageSize;
    if (page < 2 || offset + _pageHeaderSize > _data.length) {
      throw LmdbFormatException('page $page out of bounds');
    }
    return offset;
  }

  Uint8List _slice(int offset, int length) {
    if (offset + length > _data.length) throw const LmdbFormatException('value out of bounds');
    return Uint8List.sublistView(_data, offset, offset + length);
  }
}
