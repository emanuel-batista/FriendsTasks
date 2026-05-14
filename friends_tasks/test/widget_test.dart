import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tasks/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Usuários'), findsOneWidget);
  });
}
