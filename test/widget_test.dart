import 'package:flutter_test/flutter_test.dart';
import 'package:isc_sanitation_platform/main.dart';

void main() {
  testWidgets('shows sanitation login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ISCSanitationApp());

    expect(find.text('Platform Sign In'), findsOneWidget);
    expect(
      find.text('ISC Unified Sanitation Monitoring Platform'),
      findsOneWidget,
    );
  });
}
