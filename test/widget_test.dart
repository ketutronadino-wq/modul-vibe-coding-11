import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kosfinder_mini/main.dart';

void main() {
  testWidgets('shows the sample kos list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('KosFinder Mini'), findsOneWidget);
    expect(kosList, hasLength(6));
    expect(kosList.map((kos) => kos.id).toSet(), hasLength(kosList.length));
    expect(find.text('Kos Melati'), findsOneWidget);
    expect(find.text('Jl. Mawar, Bandung'), findsOneWidget);
    expect(find.text('Rp 1.200.000 / bulan'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Kos Sejahtera'),
      300,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('Jl. Seturan, Yogyakarta'), findsOneWidget);
    expect(find.text('Rp 850.000 / bulan'), findsOneWidget);
  });

  testWidgets('searches kos names without case sensitivity', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), 'mElAti');
    await tester.pump();

    expect(find.text('Kos Melati'), findsOneWidget);
    expect(find.text('Kos Harmoni'), findsNothing);

    await tester.enterText(find.byType(TextField), 'kos tidak ada');
    await tester.pump();

    expect(find.text('Kos tidak ditemukan'), findsOneWidget);
    expect(find.text('Kos Melati'), findsNothing);
    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();

    expect(find.text('Kos tidak ditemukan'), findsNothing);
    expect(find.text('Kos Melati'), findsOneWidget);
  });

  testWidgets('toggles a kos favorite', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Tambahkan ke favorit').first);
    await tester.pump();
    expect(find.byTooltip('Hapus dari favorit').first, findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus dari favorit').first);
    await tester.pump();
    expect(find.byTooltip('Tambahkan ke favorit').first, findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });

  testWidgets('dismisses the search keyboard when results are dragged', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.showKeyboard(find.byType(TextField));
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();

    expect(tester.testTextInput.isVisible, isFalse);
  });
}
