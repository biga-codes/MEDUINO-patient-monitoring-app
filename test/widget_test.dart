import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Dashboard screen loads with correct title', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verify the app title
    expect(find.text("Health Dashboard"), findsOneWidget);

    // Verify placeholder text is present
    expect(find.text("No data available (Firebase not integrated yet)"), findsOneWidget);
  });
}
