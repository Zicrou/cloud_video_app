class Login {
  String? phoneNumber;
  String? password;

  Login({this.phoneNumber, this.password});

  Login.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = this.phoneNumber;
    data['password'] = this.password;
    return data;
  }

  @override
  String toString() {
    return 'Login{phoneNumber: $phoneNumber, password: $password}';
  }
}
