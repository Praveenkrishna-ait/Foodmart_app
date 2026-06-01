import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:instamart_app/main.dart';
import 'package:instamart_app/providers/cart_provider.dart';
import 'package:instamart_app/providers/order_provider.dart';

void main() {
  testWidgets('Instamart app splash screen smoke test', (WidgetTester tester) async {
    // Build our app with mock providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
        ],
        child: const InstamartApp(),
      ),
    );

    // Verify that the splash screen shows the "instamart" name
    expect(find.text('instamart'), findsOneWidget);
    expect(find.text('DELIVERY IN 10 MINUTES'), findsOneWidget);
  });
}
