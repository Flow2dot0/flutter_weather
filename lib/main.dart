import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Weather App by Flow2dot0'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String key = "cities";

  List<String> citiesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfPref();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: textStyled(widget.title, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        centerTitle: true,
      ),
      drawer: generateDrawer(),
      body: Center(
      ),
    );
  }
  
  Text textStyled(String data, {color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal, textAlign : TextAlign.center }) {
    return Text(
        data,
        textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
      ),
    );
  }

  // generate listview builder
  ListView generateCitiesItems() {
    return ListView.builder(
        itemCount: citiesList.length,
        itemBuilder: (context, i) {
          String city = citiesList[i];

          return ListTile(
            title: textStyled(city),
            onTap: () {
              key = city;
            },
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteItemListOfPref(city);
                }
            ),
          );
        }
    );
  }

  Widget generateDrawer() {
    print(citiesList);
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView.builder(
          itemCount: citiesList.length+2,
          itemBuilder: (context, i) {
            if(i==0){
              return DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        textStyled("My cities".toUpperCase(), color: Colors.deepPurple, fontSize: 30.0, fontWeight: FontWeight.bold),
                        IconButton(
                          iconSize: 50.0,
                            icon: Icon(Icons.add),
                            color: Colors.deepPurple,
                            onPressed: () {
                              addCity();
                            }
                        )
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/logo.png"),
                      fit: BoxFit.fitHeight
                  ),
                  color: Colors.white,
                ),
              );
            } else if(i==1){
              ListTile(
                title: textStyled("Current city", color: Colors.white, fontSize: 25.0),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              );
            }else{
              String city = citiesList[i];
              return ListTile(
                title: textStyled(city),
                onTap: () {
                  key = city;
                },
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteItemListOfPref(city);
                    }
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // add city to drawer
  Future<Null> addCity() async{
    return showDialog(
        context: context,
      builder: (BuildContext contextSimpleDialog) {
          return SimpleDialog(
            title: textStyled("add".toUpperCase(), color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
            backgroundColor: Colors.deepPurple,
            contentPadding: EdgeInsets.all(20.0),
            children: <Widget>[
              Divider(
                color: Colors.black,
              ),
              TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0
                ),
                cursorColor: Colors.white,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city, color: Colors.white,),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  )
                ),
                onSubmitted: (String str){
                  addItemListOfPref(str);
                }
              ),
            ],
          );
      }
    );
  }

  // shared preferences //

  // read
  getListOfPref() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> l = await sharedPreferences.getStringList(key);
    if(l!=null){
      setState(() {
        citiesList = l;
      });
    }
  }
  // create
  addItemListOfPref(String str) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    citiesList.add(str);
    await sharedPreferences.setStringList(key, citiesList);
    getListOfPref();
  }

  // delete
  deleteItemListOfPref(String str) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    citiesList.remove(str);
    await sharedPreferences.setStringList(key, citiesList);
    getListOfPref();
  }

}
