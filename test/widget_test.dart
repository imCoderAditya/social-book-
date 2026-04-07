// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:social_book/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:social_book/app/modules/home/views/home_view.dart';
import 'package:social_book/app/modules/home/controllers/home_controller.dart';

void main() {
  testWidgets('HomeView displays correct title and text', (WidgetTester tester) async {
    // Initialize GetX controller
    Get.put(HomeController());

    // Pump the HomeView widget
    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );

    // Verify AppBar title
    expect(find.text('HomeView'), findsOneWidget);

    // Verify body text
    expect(find.text('HomeView is working'), findsOneWidget);

    // Verify TextStyle font size is 20
    final textWidget = tester.widget<Text>(find.text('HomeView is working'));
    expect(textWidget.style?.fontSize, 20);
  });
}
