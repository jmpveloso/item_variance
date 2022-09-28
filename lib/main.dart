import 'package:flutter/material.dart';
import 'package:item_variance/providers/itemtype_provider.dart';
import 'package:provider/provider.dart';

import 'presentation/pages/item_type/add_edit_itemtype.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ItemTypeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Item Variance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddEditItemType(),
    );
  }
}
