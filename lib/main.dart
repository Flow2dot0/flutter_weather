import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'Temperature.dart';
import 'my_flutter_app_icons.dart';

Future main() async {
  await DotEnv().load('.env');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

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
  String currentCityName;
  Coordinates coordsCityTaken;

  Temperature temperature;

  List<String> citiesList = [];

  AssetImage day = AssetImage("assets/img/day.jpg");
  AssetImage night = AssetImage("assets/img/night.jpg");
  AssetImage rain = AssetImage("assets/img/rain.jpg");

  Location location;
  Stream<LocationData> stream;
  LocationData locationData;
  LocationData currentLocation;


  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getListOfPref();
    location = Location();
    getCurrentLocation();
    streamNewLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: textStyled(widget.title, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        centerTitle: true,
      ),
      drawer: generateDrawer(),
      body: (temperature==null?
        Center(
          child: textStyled(cityTaken!=null ? cityTaken : "", color: Colors.white),
        )
        :
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: getBackground(),
                fit: BoxFit.cover
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              textStyled(cityTaken!=null? cityTaken.toUpperCase() : "", fontSize: 30.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
              Card(
                child: Container(
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      textStyled("${temperature.temperature.toInt().toString()} °C", color: Colors.white, fontSize: 40.0, fontStyle: FontStyle.normal),

                      //find solution to change icon status
                      getStatusIcon()

                    ],
                  ),
                ),
                elevation: 20.0,
              ),
              textStyled(temperature.mainDescription, fontSize: 35.0),
              textStyled(temperature.description, fontSize: 20.0, fontStyle: FontStyle.normal),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  displayStats(MyFlutterApp.temperatire, temperature.pressure.toInt().toString()),
                  displayStats(MyFlutterApp.waves, temperature.humidity.toInt().toString()),
                  displayStats(MyFlutterApp.down, temperature.minTemp.toInt().toString()),
                  displayStats(MyFlutterApp.up, temperature.maxTemp.toInt().toString()),

                ],
              ),
            ],
          )
      )
      )
    );
  }
  
  // column stats
  Card displayStats(icon, String text) {
    return Card(
      elevation: 20.0,
      child: Container(
        color: Colors.blueGrey,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 40.0,),
            textStyled(text, color: Colors.white, fontWeight: FontWeight.bold)
          ],
        ),
      ),
    );
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
        color: Colors.blueGrey,
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
                title: textStyled(currentCityName.toUpperCase(), color: Colors.orangeAccent, fontSize: 20.0, fontStyle: FontStyle.normal),
                leading: Icon(Icons.location_city, color: Colors.orangeAccent,),
                onTap: () {
                  setState(() {
                    cityTaken = currentCityName;
                    handleCityChange();
                    Navigator.pop(context);
                  });
                },
              );
            }else {
              // go back to real index
              String city = citiesList[i-2];
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
                        handleCityChange();
                        Navigator.pop(context);
                      });
                    },
                    leading: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: () {
                          setState(() {
                            deleteItemListOfPref(city);
                            setDefaultCity();
                            Navigator.pop(context);
                          });
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

  // load by default the current location (city name)
  setDefaultCity() async{
    print("je ve set default");
    if(currentCityName!=null)
      setState(() {
        cityTaken = currentCityName;
        coordsCityTaken = Coordinates(currentLocation.latitude, currentLocation.longitude);
        getDataFromApiByCoords();
      });
  }

  // load city
  handleCityChange() async{
   await apiGetCoordsFromCityName();
   await getDataFromApiByCoords();
  }


  // get correct background
  AssetImage getBackground() {
    if(temperature!=null){
      var tmp = temperature.icon;
        if(tmp.contains("n")){
          return night;
        }else{
          return day;
        }
    }
  }

  //* API *//

  // get name
  apiGetCityNameByCoords() async{
    final coords = Coordinates(currentLocation.latitude, currentLocation.longitude);
    var city = await Geocoder.local.findAddressesFromCoordinates(coords);
    if(city!=null){
      setState(() {
        currentCityName = city.first.locality;
      });
    }
  }

  // get coords
  apiGetCoordsFromCityName() async{
    final query = cityTaken;
    var city = await Geocoder.local.findAddressesFromQuery(query);
    if(city!=null){
      setState(() {
        coordsCityTaken = city.first.coordinates;
        print(coordsCityTaken);
      });
    }
  }

  // openweathermap
  getDataFromApiByCoords() async{
    String start = "https://api.openweathermap.org/data/2.5/weather?";
    String lat = "lat=${coordsCityTaken.latitude.toString()}";
    String lon = "&lon=${coordsCityTaken.longitude.toString()}";
    String lang = "&lang=${Localizations.localeOf(context).languageCode}";
    String units = "&units=metric";
    String _apiKey = "&appid=${DotEnv().env['API_KEY']}";

    var query = start + lat + lon + units + lang + _apiKey;
    var response = await http.get(query);
    if(response.statusCode==200){
      Map jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        temperature = Temperature(jsonResponse);
        print(temperature.temperature);
      });
    }
  }

  // get correct icon
  getStatusIcon() {
    String query = "http://openweathermap.org/img/wn/${temperature.icon}@2x.png";
    return Image.network(query);
  }


  //* location *//

  // getCurrentLocation
  getCurrentLocation() async{
    try{
      currentLocation = await location.getLocation();
      await apiGetCityNameByCoords();
      setDefaultCity();
      print("POS : ${currentLocation.longitude}");
    } on PlatformException catch(e) {
      if(e.code == "PERMISSION_DENIED"){
        print("Permission denied");
      }
      currentLocation = null;
    }
  }

  // streamNewLocation
  streamNewLocation() async{
    stream = await location.onLocationChanged();
    stream.listen((newLocation) {
      if(newLocation!=null && newLocation.latitude!=currentLocation.latitude && newLocation.longitude!=currentLocation.longitude)
      currentLocation = newLocation;
    });
  }


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
