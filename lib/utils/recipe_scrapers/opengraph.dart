import 'package:html/dom.dart';

/// Parser for OpenGraph metadata in HTML documents
class OpenGraph(final Document document) {
  late final Map<String, String> _data = _extract(document);

  static Map<String, String> _extract(Document document) {
    final data = <String, String>{};
    for (final tag in document.querySelectorAll('meta[property^="og:"]')) {
      final property = tag.attributes['property'];
      final content = tag.attributes['content'];
      if (property != null && content != null) {
        data[property.replaceFirst('og:', '')] = content;
      }
    }
    return data;
  }

  String? get(String property) {
    return _data[property];
  }

  String? get title => get('title')?.split(':')[0];
  String? get type => get('type');
  String? get image => get('image');
  String? get url => get('url');
  String? get description => get('description');
  String? get siteName => get('site_name');
}
