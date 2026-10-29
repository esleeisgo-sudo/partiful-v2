import 'package:flutter_test/flutter_test.dart';
import 'package:mid_project_template/main.dart';

void main() {
  testWidgets('PartifulApp smoke test', (WidgetTester tester) async {
    // 앱을 실행하고 화면을 그립니다.
    await tester.pumpWidget(const PartifulApp());

    // 앱 상단 타이틀이 정상적으로 존재하는지 확인합니다.
    expect(find.text('Partiful v2'), findsOneWidget);
  });
}