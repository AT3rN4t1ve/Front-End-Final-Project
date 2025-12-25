class User {
  String username = ''; // กำหนดค่าเริ่มต้น
  String email = ''; // กำหนดค่าเริ่มต้น
  String? password; // password สามารถเป็น null
 
  User({
    this.username = '', // กำหนดค่าเริ่มต้น
    this.email = '', // กำหนดค่าเริ่มต้น
    this.password,
  });
 
  factory User.fromJson(Map<String, dynamic> json) {
    print('JSON received: $json');
    return User(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}