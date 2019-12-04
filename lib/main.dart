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
  String cityTaken;

  List<String> citiesList = [];

  AssetImage day = AssetImage("assets/img/day.jpg");
  AssetImage night = AssetImage("assets/img/night.jpg");
  AssetImage rain = AssetImage("assets/img/rain.jpg");

  @override
  void initState(){
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: night,
            fit: BoxFit.cover
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            textStyled(cityTaken==null? "City not selected" : cityTaken, color: Colors.white, fontSize: 30.0, fontStyle: FontStyle.normal),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                textStyled(cityTaken==null? "" : cityTaken, color: Colors.white, fontSize: 50.0, fontStyle: FontStyle.normal),
                Icon(Icons.wb_sunny, color: Colors.white, size: 50.0,)
              ],
            ),
            textStyled(cityTaken==null? "" : cityTaken, color: Colors.white, fontSize: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                displayStats(),
                displayStats(),
                displayStats(),
                displayStats(),

              ],
            )
          ],
        )
      ),
    );
  }
  
  // column stats
  Column displayStats() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.arrow_drop_up, color: Colors.white,),
        textStyled("23", color: Colors.white, fontWeight: FontWeight.bold)
      ],
    );
  }

  // generate all stats
  List<Widget> allStats() {
    List<Widget> l = [];

    return  l;
  }

  // custom text in a function because we don't use other stateful widget
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

  // drawer
  Widget generateDrawer() {
    print(citiesList);
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView.builder(
          // add +2 for setting between 0 & 1 custom boilerplate
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
             return ListTile(
                title: textStyled("Current city".toUpperCase(), color: Colors.orangeAccent, fontSize: 20.0, fontStyle: FontStyle.normal),
                leading: Icon(Icons.location_city, color: Colors.orangeAccent,),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              );
            }else {
              // go back to real index
              String city = citiesList[i-2];
              print("ville : $city");
              return Column(
                children: <Widget>[
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    title: textStyled(city),
                    onTap: () {
                      setState(() {
                        cityTaken = city;
                        Navigator.pop(context);
                      });
                    },
                    leading: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: () {
                          deleteItemListOfPref(city);
                        }
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // simple dialog : add city to drawer
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
                color: Colors.white,
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
                  Navigator.pop(context);
                }
              ),
            ],
          );
      }
    );
  }



  // API



  //* shared preferences *//

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
    // lock the doublon possibility
    if(citiesList.contains(str))
      return;

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
