import 'package:flutter_test/flutter_test.dart';

import 'package:persona_path/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const PersonaPathApp());
    expect(find.text('PersonaPath'), findsOneWidget);
  });
}
