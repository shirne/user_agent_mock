import 'package:user_agent_mock/user_agent_mock.dart';
import 'package:test/test.dart';

void main() {
  group('user agent tests', () {
    final userAgent = UserAgent();

    test('test builder', () {
      print(userAgent.build());
      userAgent.system(UASystem.android);
      print(userAgent.build());
      userAgent.browser(UABrowser.safari);
      print(userAgent.build());
    });
  });
}
