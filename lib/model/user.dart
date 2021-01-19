import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String gender;
  final String picture;
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.title,
    this.phone,
    this.email,
    this.picture,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
