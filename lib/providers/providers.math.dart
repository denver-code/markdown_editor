import 'package:markdown/markdown.dart' as md;

class MathSyntax extends md.InlineSyntax {
  MathSyntax() : super(r'(\${1,2})([^\0]+?)\1');
  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (match.groupCount != 2) return true;
    final display = match[1]! == r'$$';
    final elm = md.Element('math', [
      md.Text(match[2]!),
    ])
      ..attributes.addAll({'display': display.toString()});
    parser.addNode(elm);
    return true;
  }
}
