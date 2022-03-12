class UserModel {
  String? uid;
  String? email;
  String? name;
  String? gender;
  int? age;
  String? occupation;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.gender,
      this.age,
      this.occupation});

  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['Email'],
      name: map['Name'],
      gender: map['Gender'],
      age: map['Age'],
      occupation: map['Occupation'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'Email': email,
      'Name': name,
      'Gender': gender,
      'Age': age,
      'Occupation': occupation,
    };
  }
}
