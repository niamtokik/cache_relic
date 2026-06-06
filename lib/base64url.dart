import 'dart:convert';

String toBase64Url(String base64) {
  return base64
    .replaceAllMapped(
      RegExp(r'\+'),
      (Match m) => '-'
    )
    .replaceAllMapped(
      RegExp(r'\/'),
      (Match m) => '_'
    );
}

String toBase64(String base64) {
  return base64
    .replaceAllMapped(
      RegExp(r'\-'),
      (Match m) => '+'
    )
    .replaceAllMapped(
      RegExp(r'\_'),
      (Match m) => '/'
    );
}

bool isBase64Url(String b64) {
  try {
    base64.decode(toBase64(b64));
    return true;
  }
  catch (_) {
    return false;
  }
}
