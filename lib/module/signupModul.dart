class SignUpModule {
  String firstName;
  String lastName;
  String password;
  String email;
  String phone;
  String state;
  String imageUrl;

  SignUpModule( this.firstName, this.lastName, this.email,
      this.password, this.phone, this.state, [this.imageUrl]);



  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "phone": phone,
      "state": state,
      'imageUrl': imageUrl,
    };
  }
}
