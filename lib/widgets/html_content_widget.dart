import 'package:flutter/material.dart';

// This is a simplified HTML content renderer
// In a real app, you would use a package like flutter_html or flutter_widget_from_html
class HtmlContentWidget extends StatelessWidget {
  final String htmlContent;

  const HtmlContentWidget({
    Key? key,
    required this.htmlContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a very simple HTML parser for demonstration purposes
    // For production use, use a proper HTML parsing library
    
    final paragraphs = htmlContent.split('</p>');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render simplified HTML content
        for (var section in _parseContent(htmlContent))
          _renderSection(section),
      ],
    );
  }
  
  List<Map<String, dynamic>> _parseContent(String html) {
    final result = <Map<String, dynamic>>[];
    
    // Simple regex-based parser (not comprehensive)
    final h2Regex = RegExp(r'<h2>(.*?)</h2>');
    final h3Regex = RegExp(r'<h3>(.*?)</h3>');
    final pRegex = RegExp(r'<p>(.*?)</p>');
    final ulRegex = RegExp(r'<ul>(.*?)</ul>', dotAll: true);
    final liRegex = RegExp(r'<li>(.*?)</li>');
    
    // Extract h2 sections
    for (var match in h2Regex.allMatches(html)) {
      result.add({
        'type': 'h2',
        'content': match.group(1)?.trim() ?? '',
      });
    }
    
    // Extract h3 sections
    for (var match in h3Regex.allMatches(html)) {
      result.add({
        'type': 'h3',
        'content': match.group(1)?.trim() ?? '',
      });
    }
    
    // Extract paragraphs
    for (var match in pRegex.allMatches(html)) {
      result.add({
        'type': 'p',
        'content': match.group(1)?.trim() ?? '',
      });
    }
    
    // Extract lists
    for (var match in ulRegex.allMatches(html)) {
      final listItems = <String>[];
      final listContent = match.group(1) ?? '';
      
      for (var liMatch in liRegex.allMatches(listContent)) {
        listItems.add(liMatch.group(1)?.trim() ?? '');
      }
      
      result.add({
        'type': 'ul',
        'items': listItems,
      });
    }
    
    // Sort by position in original HTML (very simplified)
    result.sort((a, b) {
      final aPos = html.indexOf('<${a['type']}');
      final bPos = html.indexOf('<${b['type']}');
      return aPos.compareTo(bPos);
    });
    
    return result;
  }
  
  Widget _renderSection(Map<String, dynamic> section) {
    switch (section['type']) {
      case 'h2':
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            section['content'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Color(0xFF1F2937), // gray-800
            ),
          ),
        );
      
      case 'h3':
        return Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            section['content'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              color: Color(0xFF374151), // gray-700
            ),
          ),
        );
      
      case 'p':
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            section['content'],
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              color: Color(0xFF4B5563), // gray-600
              height: 1.5,
            ),
          ),
        );
      
      case 'ul':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var item in section['items'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B5563), // gray-600
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Color(0xFF4B5563), // gray-600
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      
      default:
        return const SizedBox.shrink();
    }
  }
}