class Login {
  String? email;
  String? password;

  Login({this.email, this.password});

  Login.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  // Map<String, dynamic> toJson() {
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['email'] = email;
    // data['password'] = password;
    // return data;
  // }

  @override
  String toString() {
    return 'Login{email: $email, password: $password}';
  }
}
