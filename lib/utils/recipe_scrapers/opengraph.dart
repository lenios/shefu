import 'package:html/dom.dart';

/// Parser for OpenGraph metadata in HTML documents
class OpenGraph {
  final Document document;
  final Map<String, String> _data = {};

  OpenGraph(this.document) {
    var ogTags = document.querySelectorAll('meta[property^="og:"]');

    for (var tag in ogTags) {
      if (tag.attributes.containsKey('property') && tag.attributes.containsKey('content')) {
        String property = tag.attributes['property']!.replaceFirst('og:', '');
        String content = tag.attributes['content']!;
        _data[property] = content;
      }
    }
  }

  String? get(String property) {
    return _data[property];
  }

  String? get title => get('title');
  String? get type => get('type');
  String? get image => get('image');
  String? get url => get('url');
  String? get description => get('description');
  String? get siteName => get('site_name');
}
