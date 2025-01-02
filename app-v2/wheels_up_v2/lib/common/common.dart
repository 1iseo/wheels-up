import 'package:pocketbase/pocketbase.dart';

String getErrorMessageFromClientEx(ClientException ex) {
  return ex.response["message"];
}
