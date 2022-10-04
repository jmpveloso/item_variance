import 'package:flutter/material.dart';
import 'package:item_variance/constant/constant_text.dart';
import 'package:item_variance/models/item_type.dart';
import 'package:item_variance/providers/itemtype_provider.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

//==========================================================================Global Key for Form State
GlobalKey<FormState> _gkFormState = GlobalKey<FormState>();

class AddEditItemType extends StatefulWidget {
  const AddEditItemType({Key? key, this.itemTypeModel, this.isEditMode = false})
      : super(key: key);

  final ItemType? itemTypeModel;
  final bool isEditMode;

  @override
  State<AddEditItemType> createState() => _AddEditItemTypeState();
}

class _AddEditItemTypeState extends State<AddEditItemType> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(widget.isEditMode ? 'Edit Item Type' : 'Add Item Type'),
      ),
      body: Column(
        children: [
          Form(key: _gkFormState, child: _addItemTypeForm(context)),
        ],
      ),
      //========================================================================Bottom Navigation Buttons
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  //============================================================================Widget Section for Adding Item Type
  _addItemTypeForm(BuildContext context) {
    return Consumer<ItemTypeProvider>(
      builder: (context, provider, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FormHelper.inputFieldWidgetWithLabel(
                context,
                "typeName",
                "Type Name",
                "",
                initialValue: widget.isEditMode
                    ? widget.itemTypeModel!.typeName.toString()
                    : "",
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

  //============================================================================Bottom Navigation Buttons
  Widget _bottomNavigation() {
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
                widget.isEditMode ? ButtonText.update : ButtonText.save, () {
              if (validateAndSave()) {
                if (widget.isEditMode == true) {
                  //============================================================Call Provider to Update Item Type
                  provider.updateItemTypeProvider().then((value) {
                    //============================================================Alert After
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value == true
                            ? Message.success
                            : Message.alertError),
                      ),
                    );
                  });
                } else {
                  //============================================================Call Provider to Save Item Type
                  provider.addItemTypeProvider().then((value) {
                    //============================================================Alert After
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value == true
                            ? Message.success
                            : Message.alertError),
                      ),
                    );
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
