import 'package:user_agent_mock/user_agent_mock.dart';

void main() {
  final userAgent = UserAgent();
  print(userAgent.build());
}
