import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_app/constants.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

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
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure?'),
                    backgroundColor: col_lg,
                    content:
                        Text('Your session durations will be set to defaults.'),
                    actions: [
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          setState(() {
                            possibleDurations = List.from(defaultDurations);
                          });
                          for (int i = 0; i < possibleDurations.length; i++) {
                            _setPrefDuration(i, possibleDurations[i]);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Set to defaults'),
          ),
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
                  backgroundColor: col_lg,
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
                          if (newValue < minDuration)
                            newValue = minDuration;
                          else if (newValue > maxDuration)
                            newValue = maxDuration;

                          possibleDurations[i] = newValue;
                          _setPrefDuration(i, newValue);

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
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          ),
        ),
      ));
    }
    return list;
  }

  _setPrefDuration(int index, int value) async {
    var prefs = await SharedPreferences.getInstance();
    //developer.log('possibleDurations' + index.toString());
    //developer
    //    .log(prefs.getInt('possibleDurations' + index.toString()).toString());
    prefs.setInt('possibleDurations' + index.toString(), value);
    //developer
    //    .log(prefs.getInt('possibleDurations' + index.toString()).toString());
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
                if (canChange) {
                  categoryVisibilities[i] = selected;
                  _setPrefCategoryVisibility(i, selected);
                }
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

  _setPrefCategoryVisibility(int index, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('categoryVisibilities' + index.toString(), value);
  }
}
