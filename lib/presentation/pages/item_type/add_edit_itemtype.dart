import 'package:flutter/material.dart';
import 'package:item_variance/constant/constant_text.dart';
import 'package:item_variance/models/item_type.dart';
import 'package:item_variance/providers/itemtype_provider.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';

import '../../../services/db_services.dart';

//==========================================================================Global Key for Form State
GlobalKey<FormState> _gkFormState = GlobalKey<FormState>();
late DBService dbService;

class AddEditItemType extends StatefulWidget {
  const AddEditItemType({Key? key}) : super(key: key);

  @override
  State<AddEditItemType> createState() => _AddEditItemTypeState();
}

class _AddEditItemTypeState extends State<AddEditItemType> {
  @override
  void initState() {
    super.initState();

    //==========================================================================Call Function to Fetch Report
    Future.delayed(Duration.zero).then((value) {
      //==========================================================================Function to Fetch Report
      Provider.of<ItemTypeProvider>(context, listen: false)
          .getAllItemTypeProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Add Item Type"),
      ),
      body: Column(
        children: [
          Form(key: _gkFormState, child: _addItemType(context)),
          //====================================================================Item Type List Builder
          _itemTypeListBuilder(),
        ],
      ),
      //========================================================================Bottom Navigation Buttons
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  //============================================================================Widget Section for Adding Item Type
  _addItemType(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ItemTypeProvider>(
        builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FormHelper.inputFieldWidgetWithLabel(
                context,
                "typeName",
                "Type Name",
                "",
                initialValue: provider.itemTypeHolder.typeName ?? "",
                showPrefixIcon: true,
                prefixIcon: const Icon(Icons.text_fields),
                borderRadius: 10,
                contentPadding: 15,
                fontSize: 14,
                labelFontSize: 14,
                paddingLeft: 0,
                paddingRight: 0,
                prefixIconPaddingLeft: 10,
                (onSaved) {
                  //============================================================Get Value From Field
                  provider.getItemTypeValueProvider(onSaved);
                },
                (onValidate) {
                  //============================================================Validate
                  if (onValidate == "") {
                    return "* Required";
                  }

                  return null;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  //============================================================================Validate First the Form
  bool validateAndSave() {
    final form = _gkFormState.currentState;

    //==========================================================================Check the Current State of the Form
    if (form!.validate()) {
      //========================================================================Save if Valid Form
      form.save();
      return true;
    }
    return false;
  }

  //============================================================================Item Type List Builder
  _itemTypeListBuilder() {
    return Expanded(
      child: Consumer<ItemTypeProvider>(
        builder: (context, provider, child) => provider.itemTypeList.isEmpty
            ? Center(child: Text(Message.nodata))
            : ListUtils.buildDataTable(
                context,
                ["No.", "Item Type", ""],
                ["id", "typeName", ""],
                false,
                0,
                provider.itemTypeList,
                headingRowColor: Colors.orangeAccent,
                isScrollable: true,
                columnTextFontSize: 15,
                columnTextBold: false,
                columnSpacing: 50,
                onSort: (columnIndex, columnName, asc) {},
                //==============================================================Edit Option
                (ItemType itemType) {
                  //============================================================Edit Item  Type Name
                  provider.editItemTypeProvider(itemType);
                },
                //==============================================================Delete Option
                (ItemType itemType) {
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
                                  FormHelper.submitButton(
                                      ButtonText.delete, () {},
                                      width: 100,
                                      borderRadius: 5,
                                      btnColor: Colors.green,
                                      borderColor: Colors.green),
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
              ),
      ),
    );
  }

  //============================================================================Bottom Navigation Buttons
  _bottomNavigation() {
    return Consumer<ItemTypeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //==================================================================Save Button
            FormHelper.submitButton(
                //================================================================Check Edit Mode
                provider.isEditMode == true
                    ? ButtonText.update
                    : ButtonText.save, () {
              if (validateAndSave()) {
                if (provider.isEditMode == true) {
                  //============================================================Call Provider to Update Item Type
                  provider.updateItemTypeProvider();
                  //============================================================Alert After
                  FormHelper.showSimpleAlertDialog(
                      context,
                      Header.updatetemType,
                      provider.addResult ? Message.success : Message.alertError,
                      ButtonText.ok, () {
                    Navigator.pop(context);
                  });
                } else {
                  //============================================================Call Provider to Save Item Type
                  provider.addItemTypeProvider();
                  //============================================================Alert After
                  FormHelper.showSimpleAlertDialog(
                      context,
                      Header.addingItemType,
                      provider.addResult ? Message.success : Message.alertError,
                      ButtonText.ok, () {
                    Navigator.pop(context);
                  });
                }
              }
            },
                borderRadius: 10,
                btnColor: Colors.green,
                borderColor: Colors.green),
            FormHelper.submitButton(ButtonText.cancel, () {
              //================================================================Cancel Button
              provider.cancelItemType();
            },
                borderRadius: 10,
                btnColor: Colors.grey,
                borderColor: Colors.grey),
          ],
        ),
      ),
    );
  }
}
