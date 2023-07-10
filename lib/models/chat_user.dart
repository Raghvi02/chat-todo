
import 'dart:io';

class UserModel {
  final String name;
  final String about;
  final String id;
  final String email;
  final String image;

  UserModel({
    required this.name,
    required this.about,
    required this.id,
    required this.email,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name']?? '',
      about: json['about']?? '',
      id: json['id']??'',
      email: json['email']?? '',
      image: json['image']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name?? '',
      'about': about?? '',
      'id': id?? '',
      'email': email?? '',
      'image': image?? '',
    };
  }
}
