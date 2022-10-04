import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';

import '../../../constant/constant_text.dart';
import '../../../models/item_type.dart';
import '../../../providers/itemtype_provider.dart';
import 'add_edit_itemtype.dart';

class ItemTypeView extends StatelessWidget {
  const ItemTypeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemTypeProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text("Item Type"),
          actions: [
            IconButton(
                onPressed: () {
                  //==============================================================Navigate to Add Type Page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEditItemType(
                          isEditMode: false,
                        ),
                      ));
                },
                icon: const Icon(Icons.add_outlined)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              //====================================================================Item Type List Builder
              _itemTypeListBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  //============================================================================Item Type List Builder
  _itemTypeListBuilder() {
    return Expanded(
      child: FutureBuilder<List<ItemType>>(
          future: dbService.getAllItemTypeDbService(),
          builder:
              (BuildContext context, AsyncSnapshot<List<ItemType>> itemType) {
            //================================================================Data Content
            if (itemType.hasData) {
              return _buildItemTypeDataTable(context, itemType.data ?? []);
            }
            //================================================================Loading
            else if (itemType.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            //================================================================No Data
            else {
              return Center(child: Text(Message.nodata));
            }
          }),
    );
  }

  //============================================================================Build Data Table
  _buildItemTypeDataTable(BuildContext context, List<ItemType> itemType) {
    return ListUtils.buildDataTable(
      context,
      ["No.", "Item Type", ""],
      ["id", "typeName", ""],
      false,
      0,
      itemType,
      headingRowColor: Colors.orangeAccent,
      isScrollable: true,
      columnTextFontSize: 15,
      columnTextBold: false,
      columnSpacing: 50,
      onSort: (columnIndex, columnName, asc) {},
      //================================================================Edit Option
      (ItemType onEditTap) {
        //==============================================================Navigate to Edit Type Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditItemType(
              isEditMode: true,
              itemTypeModel: onEditTap,
            ),
          ),
        );
      },
      //================================================================Delete Option
      (ItemType onDeleteTap) {
        return showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(Header.confirmDelete),
                  content: Text(Message.delete),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<ItemTypeProvider>(
                          builder: (context, provider, child) =>
                              FormHelper.submitButton(
                            ButtonText.delete,
                            () {
                              Navigator.pop(context);
                              //========================================Call Provider for Deleting
                              provider
                                  .deleteItemTypeProvider(onDeleteTap)
                                  .then((value) {
                                //==============================================Alert After
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(value == true
                                        ? Message.success
                                        : Message.alertError),
                                  ),
                                );
                              });
                            },
                            width: 100,
                            borderRadius: 5,
                            btnColor: Colors.green,
                            borderColor: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FormHelper.submitButton(
                          "No",
                          () {
                            Navigator.of(context).pop();
                          },
                          width: 100,
                          borderRadius: 5,
                        )
                      ],
                    ),
                  ],
                ));
      },
    );
  }
}
