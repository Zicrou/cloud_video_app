class User {
 
  int? id;

  String? name;

  String? email;
  
  User({
    this.id,
   
    this.name,
   
    this.email,
  });

  User.fromJson(Map<String, dynamic> json) {
   
    id = json['id'];
    
    name = json['name'] ?? '';
   
    email = json['email'] ?? '';
    
  }

  Map<String, dynamic> toJson() {
   
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    
    data['name'] = name;
   
    data['email'] = email;

    return data;
  }

  @override
  String toString() {
   
    return "Id: $id, Name: $name, Email: $email";
  
  }

}
