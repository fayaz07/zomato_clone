class PlacesModel{
  String main_text, secondary_text;

  PlacesModel({this.main_text, this.secondary_text});

  factory PlacesModel.fromJson(Map<String, dynamic> json) {
    return PlacesModel(
        main_text: json['main_text'],
        secondary_text: json['secondary_text'],
    );
  }

  @override
  String toString() {
    return "main_text: ${main_text}; secondary_text: ${secondary_text}";
  }

}