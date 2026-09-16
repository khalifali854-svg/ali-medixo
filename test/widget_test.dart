import 'package:flutter_test/flutter_test.dart';
import 'package:khalif_ali/main.dart';

void main() {
  testWidgets('App renders clean card interface smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AliApp());
    expect(find.text('Kosa Kata Ali'), findsOneWidget);
  });
}
