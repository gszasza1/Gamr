import 'package:flutter/material.dart';
import 'package:gamr/models/drawer/point.dart';

class AddEditPopup extends StatefulWidget {
  const AddEditPopup(
      {Key? key,
      required this.save,
      required this.dot,
      required this.options,
      required this.isEdit})
      : super(key: key);

  final void Function(Dot dot) save;
  final Dot dot;
  final bool isEdit;
  final List<String> options;
  
  @override
  AddEditPopupState createState() => AddEditPopupState();
}

class AddEditPopupState extends State<AddEditPopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(text: '');
  TextEditingController rank = TextEditingController(text: '');
  TextEditingController xCoordRText = TextEditingController(text: '');
  TextEditingController yCoordRText = TextEditingController(text: '');
  TextEditingController zCoordRText = TextEditingController(text: '');

  @override
  void dispose() {
    name.dispose();
    xCoordRText.dispose();
    yCoordRText.dispose();
    zCoordRText.dispose();
    rank.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Változtatás' : 'Új'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 70,
              ),
              child: RawAutocomplete(
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ki kell tölteni';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      onChanged: (e) {
                        name.text = e;
                      },
                      focusNode: fieldFocusNode,
                      controller: fieldTextEditingController
                        ..text = widget.dot.name.toString(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "pl.: Aszfalt",
                        labelText: 'Név',
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 50,
                          minWidth: MediaQuery.of(context).size.width * 0.5,
                          maxHeight: (65 * options.length > 260
                                  ? 260
                                  : 65 * options.length)
                              .toDouble(),
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return widget.options.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  print('You just selected $selection');
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: rank..text = widget.dot.rank.toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sorszám',
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: xCoordRText..text = widget.dot.x.toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'X',
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: yCoordRText..text = widget.dot.y.toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Y',
                  ),
                )),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: zCoordRText..text = widget.dot.z.toString(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Z',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Bezár'),
        ),
        TextButton(
          onPressed: () {
            widget.save(Dot.dzParameter(
                double.tryParse(xCoordRText.text) ?? widget.dot.x,
                double.tryParse(yCoordRText.text) ?? widget.dot.y,
                double.tryParse(zCoordRText.text) ?? widget.dot.z,
                name: name.text,
                id: widget.dot.id,
                rank: int.tryParse(rank.text) ?? 0));
            Navigator.of(context).pop();
          },
          child: const Text('Mentés'),
        ),
      ],
    );
  }
}
