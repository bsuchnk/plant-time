import 'package:flutter/material.dart';
import 'package:timer_app/constants.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final durController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    durController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Customize session durations:',
            textScaleFactor: 1.5,
          ),
          buildButtonSettings(context),
          Divider(),
          Text(
            'Customize categories:',
            textScaleFactor: 1.5,
          ),
          CategorySettings(),
        ],
      ),
      decoration: new BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.lightGreenAccent,
          Colors.yellowAccent,
        ]),
      ),
    );
  }

  buildButtonSettings(BuildContext context) {
    return Row(
      children: _buildButtons(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  _buildButtons() {
    List<Widget> list = [];
    for (int i = 0; i < possibleDurations.length; i++) {
      list.add(Expanded(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Select duration in minutes'),
                  content: TextField(
                    controller: durController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Duration'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          int newValue = int.parse(durController.text);
                          if (newValue > 0 && newValue <= 24 * 60 * 60)
                            possibleDurations[i] = newValue;

                          Navigator.pop(context);
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('${possibleDurations[i]}'),
        ),
      ));
    }
    return list;
  }
}

class CategorySettings extends StatefulWidget {
  @override
  _CategorySettingsState createState() => _CategorySettingsState();
}

class _CategorySettingsState extends State<CategorySettings> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: -10,
      children: buildChips(),
    );
  }

  buildChips() {
    List<Widget> list = [];

    for (int i = 0; i < categories.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            label: Text(categories[i]),
            selected: categoryVisibilities[i],
            avatar: CircleAvatar(
              child: Icon(categoryIcons[i]),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onSelected: (bool selected) {
              setState(() {
                bool canChange = true;
                if (categoryVisibilities[i] == true) {
                  canChange = false;
                  for (int j = 0; j < categoryVisibilities.length; j++) {
                    if (i != j && categoryVisibilities[j] == true)
                      canChange = true;
                  }
                }
                if (canChange) categoryVisibilities[i] = selected;
              });
            },
            selectedColor: col_grass,
            backgroundColor: col_ground,
            elevation: 2,
          ),
        ),
      );
    }

    return list;
  }
}
