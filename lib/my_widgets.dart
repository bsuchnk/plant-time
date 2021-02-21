import 'package:flutter/material.dart';
import 'package:timer_app/constants.dart';

class OneOfButtons extends StatefulWidget {
  @override
  _OneOfButtonsState createState() => _OneOfButtonsState();
}

class _OneOfButtonsState extends State<OneOfButtons> {
  int _index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _index = currentDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildButtonList(),
    );
  }

  List<Widget> _buildButtonList() {
    List<Widget> list = [];
    for (int i = 0; i < possibleDurations.length; i++) {
      list.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _index = i;
                currentDuration = i;
              });
            },
            child: Text('${possibleDurations[i]}'),
            style: ButtonStyle(
              backgroundColor: _index == i
                  ? MaterialStateProperty.all<Color>(col_grass)
                  : MaterialStateProperty.all<Color>(col_ground),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            ),
          ),
        ),
      );
    }
    return list;
  }
}

class OneOfPlants extends StatefulWidget {
  final Function() notifyParent;
  OneOfPlants({
    Key key,
    @required this.notifyParent,
  }) : super(key: key);

  @override
  _OneOfPlantsState createState() => _OneOfPlantsState();
}

class _OneOfPlantsState extends State<OneOfPlants> {
  int _index;

  @override
  void initState() {
    super.initState();
    _index = currentPlant;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildPlantList(),
    );
  }

  List<Widget> _buildPlantList() {
    List<Widget> list = [];
    for (int i = 0; i < plants.length; i++) {
      list.add(
        SizedBox(
          width: 64,
          height: 64,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _index = i;
                currentPlant = i;
                this.widget.notifyParent();
              });
            },
            child: Image.asset(plantPath(i, 2)),
            style: ButtonStyle(
              backgroundColor: _index == i
                  ? MaterialStateProperty.all<Color>(col_grass)
                  : MaterialStateProperty.all<Color>(col_ground),
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
            ),
          ),
        ),
      );
    }
    return list;
  }
}

class OneOfCategories extends StatefulWidget {
  @override
  _OneOfCategoriesState createState() => _OneOfCategoriesState();
}

class _OneOfCategoriesState extends State<OneOfCategories> {
  int _index;

  @override
  void initState() {
    super.initState();
    _index = currentCategory;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _buildCategoryList(),
      ),
    );
  }

  List<Widget> _buildCategoryList() {
    List<Widget> list = [];

    for (int i = 0; i < categories.length; i++) {
      list.add(
        ChoiceChip(
          label: Text(categories[i]),
          selected: _index == i,
          avatar: CircleAvatar(
            child: Icon(categoryIcons[i]),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onSelected: (bool selected) {
            setState(() {
              _index = i;
              currentCategory = _index;
            });
          },
          selectedColor: col_grass,
          backgroundColor: col_ground,
          elevation: 2,
        ),
      );
    }

    return list;
  }
}
