import 'package:user_agent_mock/user_agent_mock.dart';

void main() {
  final userAgent = UserAgent();
  print(userAgent.build());
  userAgent.system(UASystem.android);
  print(userAgent.build());
  userAgent.browser(UABrowser.safari);
  print(userAgent.build());
}
