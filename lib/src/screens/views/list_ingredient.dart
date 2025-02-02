import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_task/src/provider/ingredient_provider.dart';
import 'package:tech_task/src/screens/views/list_recipes.dart';
import 'package:tech_task/src/screens/widgets/datepicker_widget.dart';
class IngredientPage extends StatefulWidget {
    const IngredientPage({Key key}) : super(key: key);

  @override
  _IngredientPageState createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IngredientProvider>(
      create: (_) => IngredientProvider(),
      child: DisplayListIngredient(),
    );
  }
}

class DisplayListIngredient extends StatefulWidget {
  @override
  _DisplayListIngredientState createState() => _DisplayListIngredientState();
}

class _DisplayListIngredientState extends State<DisplayListIngredient> {
  @override
  void initState() {
    Provider.of<IngredientProvider>(context, listen: false).checkPreferenceDate();
    Provider.of<IngredientProvider>(context, listen: false).fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<IngredientProvider>(
        builder: (context, model, _) => Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Builder(
                    builder: (context) => FlatButton.icon(
                      onPressed: model.ingredientPicked.isNotEmpty ? () {
                        print(model.ingredientPerRecipe);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => RecipePage(ingredients: model.ingredientPicked)
                        ));
                      } : null,
                      icon: Icon(Icons.launch),
                      label: Text("Get Recipe"),
                      textColor: Colors.white,
                    ),
                  ),
                ) 
              ],
            ),
          ),
      ),
      floatingActionButton: Consumer<IngredientProvider>(
        builder: (__, model, _) => DatePickerWidget(icon: Icons.calendar_today,)
      ),
      appBar: AppBar(
        title: Text('ingredient'),
      ),
      body: Consumer<IngredientProvider>(
        builder: (context, model, _) => StreamBuilder<bool>(
          stream: model.isLoading,
          builder: (context, snapshot) {
            print(model.listIngredient.length);
            if(snapshot.hasData != true) {
              return Center(child: CircularProgressIndicator(),);
            }
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: model.listIngredient.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: model.listIngredient[index].picked == true ? Colors.grey[300] : Colors.white,
                    elevation: 4.0,
                    child: ListTile(
                      onTap: (){
                        model.chooseIngredient(model.listIngredient[index].title);
                        // print(model.checkDate(index));
                        print(model.useBy);
                        print(model.listIngredient[index].useBy);
                        print(model.listIngredient[index].useBy.compareTo(model.useBy));
                      },
                      enabled: model.checkDate(index),
                      title: Text(model.listIngredient[index].title),
                      subtitle: Text('Use By: ${model.listIngredient[index].date}'),
                      trailing: model.listIngredient[index].picked == true ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      ): null,
                    ),
                  );
                },
              ),
            );
          },
        ),
      )
    );
  }
}