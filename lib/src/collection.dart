import 'package:flutter/material.dart';

import 'cuppertino.dart';
import 'font.awesome.dart';
import 'line.icons.dart';
import 'material.dart';


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
enum IconCollection {
  material,
  cupertino,
  line,
  awesome;

  Map<String, IconData> get icons {
    switch (this) {
      case IconCollection.material:
        return iconCollectionAdd(prefix: 'material', collection: materialIcons);
      case IconCollection.cupertino:
        return iconCollectionAdd(
            prefix: 'cupertino', collection: cupertinoIcons);
      case IconCollection.line:
        return iconCollectionAdd(prefix: 'line', collection: lineAwesomeIcons);
      case IconCollection.awesome:
        return iconCollectionAdd(
            prefix: 'awesome', collection: fontAwesomeIcons);
    }
  }

  static Map<String, IconData> get allIcons => IconCollection.values
      .map((v) => v.icons)
      .fold({}, (r, c) => {...r, ...c});
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
Map<String, IconData> iconCollectionAdd(
        {required String prefix, required Map<String, IconData> collection}) =>
    collection.map((key, value) => MapEntry('$prefix.$key', value));

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
