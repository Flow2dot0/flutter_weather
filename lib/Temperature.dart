class Temperature {

  String mainDescription;
  String description;
  String icon;

  var temperature;
  var pressure;
  var humidity;
  var minTemp;
  var maxTemp;

  Temperature(Map m){
    this.mainDescription = m["weather"][0]["main"];
    this.description =  m["weather"][0]["description"];
    this.icon =  m["weather"][0]["icon"];

    this.temperature = m["main"]["temp"];
    this.pressure = m["main"]["pressure"];
    this.humidity = m["main"]["humidity"];
    this.minTemp = m["main"]["temp_min"];
    this.maxTemp = m["main"]["temp_max"];
  }
}

