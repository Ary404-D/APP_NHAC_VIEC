import 'package:flutter_test/flutter_test.dart';
import 'package:nhac_viec/main.dart';

void main() {
  testWidgets('App shows task list title', (WidgetTester tester) async {
    await tester.pumpWidget(const NhacViecApp());
    expect(find.text('Danh sách công việc'), findsOneWidget);
  });
}
