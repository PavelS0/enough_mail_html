import '../enough_mail_html_base.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:html/dom.dart';

class ViewPortTransformer extends DomTransformer {
  static final Element _viewPortMetaElement = Element.html(
      '<meta name="viewport" content="width=device-width, initial-scale=1.0">');
  static final Element _contentTypeMetaElement = Element.html(
      '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">');

  const ViewPortTransformer();

  @override
  void process(Document document, MimeMessage message,
      TransformConfiguration configuration) {
    final metaElements = document.getElementsByTagName('meta');
    var viewportNeedsToBeAdded = true;
    var contentTypeNeedsToBeAdded = true;
    for (final metaElement in metaElements) {
      if (metaElement.attributes['name'] == 'viewport') {
        viewportNeedsToBeAdded = false;
        metaElement.attributes['content'] =
            'width=device-width, initial-scale=1.0';
      } else if (metaElement.attributes['charset'] != null) {
        metaElement.attributes['charset'] = 'utf-8';
      } else {
        final httpEquiv = metaElement.attributes['http-equiv'];
        if (httpEquiv != null && httpEquiv.toLowerCase() == 'content-type') {
          contentTypeNeedsToBeAdded = false;
          metaElement.attributes['content'] = 'text/html; charset=utf-8';
        }
      }
    }
    if (contentTypeNeedsToBeAdded) {
      ensureDocumentHeadIsAvailable(document);
      document.head!.append(_contentTypeMetaElement);
    }
    if (viewportNeedsToBeAdded) {
      ensureDocumentHeadIsAvailable(document);
      document.head!.append(_viewPortMetaElement);
    }
  }
}
