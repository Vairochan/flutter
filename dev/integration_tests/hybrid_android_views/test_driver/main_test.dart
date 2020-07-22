// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' hide TypeMatcher, isInstanceOf;

Future<void> main() async {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() {
    driver.close();
  });

  // Each test below must return back to the home page after finishing.

  test('MotionEvent recomposition', () async {
    final SerializableFinder motionEventsListTile =
    find.byValueKey('MotionEventsListTile');
    await driver.tap(motionEventsListTile);
    await driver.waitFor(find.byValueKey('PlatformView'));
    final String errorMessage = await driver.requestData('run test');
    expect(errorMessage, '');
    final SerializableFinder backButton = find.byValueKey('back');
    await driver.tap(backButton);
  });

  group('Nested View Event', ()
  {
    setUpAll(() async {
      final SerializableFinder wmListTile =
      find.byValueKey('NestedViewEventTile');
      await driver.tap(wmListTile);
    });

    tearDownAll(() async {
      await driver.waitFor(find.pageBack());
      await driver.tap(find.pageBack());
    });

    test('AlertDialog from platform view context', () async {
      final SerializableFinder showAlertDialog = find.byValueKey(
          'ShowAlertDialog');
      await driver.waitFor(showAlertDialog);
      await driver.tap(showAlertDialog);
      final String status = await driver.getText(find.byValueKey('Status'));
      expect(status, 'Success');
    });

    test('Child view can handle touches', () async {
      final SerializableFinder addChildView = find.byValueKey('AddChildView');
      await driver.waitFor(addChildView);
      await driver.tap(addChildView);
      final SerializableFinder tapChildView = find.byValueKey('TapChildView');
      await driver.tap(tapChildView);
      final String nestedViewClickCount = await driver.getText(find.byValueKey('NestedViewClickCount'));
      expect(nestedViewClickCount, 'Click count: 1');
    });
  });
}
