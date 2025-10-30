import 'package:flutter_test/flutter_test.dart';
import 'package:daleavatar_app/main.dart';

void main() {
  testWidgets('renders app shell', (tester) async {
    await tester.pumpWidget(const DaleAvatarApp());
    expect(find.text('DaleAvatar'), findsOneWidget);
  });
}

