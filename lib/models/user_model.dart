// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:math';
import 'package:online_counsellor/core/components/constants/strings.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? profile;
  String? phone;
  String? address;
  String? city;
  String? region;
  bool? isOnline;
  String? about;
  String? gender;
  String? userType;
  String? maritalStatus;
  String? employmentStatus;
  String? educationLevel;
  String? counsellorType;
  String? religion;
  String? dob;
  String? licenseCert;
  double? rating;
  int? createdAt;
  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.profile,
    this.phone,
    this.address,
    this.city,
    this.region,
    this.isOnline,
    this.about,
    this.gender,
    this.userType,
    this.maritalStatus,
    this.employmentStatus,
    this.educationLevel,
    this.counsellorType,
    this.religion,
    this.dob,
    this.licenseCert,
    this.rating = 5,
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? profile,
    String? phone,
    String? address,
    String? city,
    String? region,
    bool? isOnline,
    String? about,
    String? gender,
    String? userType,
    String? maritalStatus,
    String? employmentStatus,
    String? educationLevel,
    String? counsellorType,
    String? religion,
    String? dob,
    String? licenseCert,
    double? rating,
    int? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      isOnline: isOnline ?? this.isOnline,
      about: about ?? this.about,
      gender: gender ?? this.gender,
      userType: userType ?? this.userType,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      educationLevel: educationLevel ?? this.educationLevel,
      counsellorType: counsellorType ?? this.counsellorType,
      religion: religion ?? this.religion,
      dob: dob ?? this.dob,
      licenseCert: licenseCert ?? this.licenseCert,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'profile': profile,
      'phone': phone,
      'address': address,
      'city': city,
      'region': region,
      'isOnline': isOnline,
      'about': about,
      'gender': gender,
      'userType': userType,
      'maritalStatus': maritalStatus,
      'employmentStatus': employmentStatus,
      'educationLevel': educationLevel,
      'counsellorType': counsellorType,
      'religion': religion,
      'dob': dob,
      'licenseCert': licenseCert,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      about: map['about'] != null ? map['about'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      userType: map['userType'] != null ? map['userType'] as String : null,
      maritalStatus:
          map['maritalStatus'] != null ? map['maritalStatus'] as String : null,
      employmentStatus: map['employmentStatus'] != null
          ? map['employmentStatus'] as String
          : null,
      educationLevel: map['educationLevel'] != null
          ? map['educationLevel'] as String
          : null,
      counsellorType: map['counsellorType'] != null
          ? map['counsellorType'] as String
          : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      licenseCert:
          map['licenseCert'] != null ? map['licenseCert'] as String : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, password: $password, name: $name, profile: $profile, phone: $phone, address: $address, city: $city, region: $region, isOnline: $isOnline, about: $about, gender: $gender, userType: $userType, maritalStatus: $maritalStatus, employmentStatus: $employmentStatus, educationLevel: $educationLevel, counsellorType: $counsellorType, religion: $religion, dob: $dob, licenseCert: $licenseCert, rating: $rating, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.password == password &&
        other.name == name &&
        other.profile == profile &&
        other.phone == phone &&
        other.address == address &&
        other.city == city &&
        other.region == region &&
        other.isOnline == isOnline &&
        other.about == about &&
        other.gender == gender &&
        other.userType == userType &&
        other.maritalStatus == maritalStatus &&
        other.employmentStatus == employmentStatus &&
        other.educationLevel == educationLevel &&
        other.counsellorType == counsellorType &&
        other.religion == religion &&
        other.dob == dob &&
        other.licenseCert == licenseCert &&
        other.rating == rating &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        profile.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        city.hashCode ^
        region.hashCode ^
        isOnline.hashCode ^
        about.hashCode ^
        gender.hashCode ^
        userType.hashCode ^
        maritalStatus.hashCode ^
        employmentStatus.hashCode ^
        educationLevel.hashCode ^
        counsellorType.hashCode ^
        religion.hashCode ^
        dob.hashCode ^
        licenseCert.hashCode ^
        rating.hashCode ^
        createdAt.hashCode;
  }

  Map<String, dynamic> updateUserMap() {
    return <String, dynamic>{
      'name': name,
      'profile': profile,
      'phone': phone,
      'address': address,
      'city': city,
      'region': region,
      'about': about,
      'dob': dob,
    };
  }
}

class DummyCounsellors {
  static final Random _random = Random();
  static List<String> counselorNames = [
    'Dr. Kofi Mensah',
    'Mrs. Akosua Mensah',
    'Mr. Kwame Owusu',
    'Miss Ama Mensah',
    'Dr. Nana Osei',
    'Mrs. Abena Appiah',
    'Mr. Kwesi Agyemang',
    'Miss Adwoa Boateng',
    'Dr. Kofi Ansah',
    'Mrs. Afua Mensah',
    'Mr. Kojo Boateng',
    'Miss Yaa Adjei',
    'Dr. Kwabena Darko',
    'Mrs. Akua Asante',
    'Mr. Kweku Addo',
    'Miss Efua Amoah',
    'Dr. Kwame Mensah',
    'Mrs. Abena Ofori',
    'Mr. Kofi Adu',
    'Miss Akosua Frimpong',
    'Dr. Nana Kwame',
    'Mrs. Adwoa Boateng',
    'Mr. Kwabena Osei',
    'Miss Ama Asare',
    'Dr. Kofi Antwi',
    'Mrs. Afia Owusu',
    'Mr. Kojo Gyasi',
    'Miss Yaa Ansah',
    'Dr. Kwesi Amponsah',
    'Mrs. Akosua Asamoah'
  ];
  static List<String> counselorImages = [
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1530785602389-07594beb8b73?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1616805765352-beedbad46b2a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1563132337-f159f484226c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1617244147030-8bd6f9e21d1e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1606416041875-c020fd6cd16c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=391&q=80",
    "https://images.unsplash.com/photo-1578758803946-2c4f6738df87?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1573166953836-06864dc70a21?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
    "https://images.unsplash.com/photo-1514222709107-a180c68d72b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=449&q=80",
    "https://images.unsplash.com/photo-1571442463800-1337d7af9d2f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1173&q=80",
    "https://images.unsplash.com/photo-1617244146826-ce9182d9388b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1614533836100-dd83a8c04e29?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1610473068514-276d33c606dd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1614533836096-fc5a112c07a4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1627595359082-cc2b3487a40b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=464&q=80",
    "https://images.unsplash.com/photo-1508243771214-6e95d137426b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1571442463716-e3e186378445?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1173&q=80",
    "https://images.unsplash.com/photo-1621701582507-4e580f0c84f9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=464&q=80",
    "https://images.unsplash.com/photo-1535469618671-e58a8c365cbd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1524538198441-241ff79d153b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1489667897015-bf7a9e45c284?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=587&q=80",
    "https://images.unsplash.com/photo-1578758837674-93ed0ab5fbab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1575880918403-f578c9078302?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=580&q=80",
    "https://images.unsplash.com/photo-1621331938577-42f137e5d5f1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1655720357872-ce227e4164ba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1589114207353-1fc98a11070b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1331&q=80",
    "https://images.unsplash.com/photo-1521510186458-bbbda7aef46b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=581&q=80",
    "https://images.unsplash.com/photo-1581368135153-a506cf13b1e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1573496358961-3c82861ab8f4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
    "https://images.unsplash.com/photo-1517598024396-46c53fb391a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=435&q=80",
    "https://images.unsplash.com/photo-1618333453525-81f8582b1a3d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1529688530647-93a6e1916f5f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=436&q=80",
  ];

  static List<String> counselorEmails = [
    'kofimensah@gmail.com',
    'akomansah@gmail.com',
    'owusukwame@example.com',
    'amamensah@example.com',
    'nanaosei@example.com',
    'abenaappiah@example.com',
    'kwesiagyemang@example.com',
    'adwoaboateng@example.com',
    'kofiansah@example.com',
    'afuamensah@example.com',
    'koboateng@example.com',
    'yaadjei@example.com',
    'kwabenadarko@example.com',
    'akuaasante@example.com',
    'kwekuaddo@example.com',
    'efuaamoah@example.com',
    'kwamemensah@example.com',
    'abenaofori@example.com',
    'kofiadu@example.com',
    'akosuafrimpong@example.com',
    'nanakwame@example.com',
    'adwoaboateng@example.com',
    'kwabenaosei@example.com',
    'amaasare@example.com',
    'kofiantwi@example.com',
    'afiaowusu@example.com',
    'kojogyasi@example.com',
    'yaaansah@example.com',
    'kwesiamponsah@example.com',
    'akosuaasamoah@example.com',
  ];
  static List<String> counselorAddresses = [
    'Block 5, Office 3, Accra',
    'Lapas, P.O. Box 234-4567, Accra',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
  ];
  static List<String> counselorRegions = [
    'Greater Accra Region',
    'Greater Accra Region',
    'Ashanti Region',
    'Greater Accra Region',
    'Bono Region',
    'Greater Accra Region',
    'Ashanti Region',
    'Greater Accra Region',
    'Bono Region',
    'Greater Accra Region',
    'Ashanti Region',
    'Greater Accra Region',
    'Bono Region',
    'Greater Accra Region',
    'Ashanti Region',
    'Greater Accra Region',
    'Bono Region',
    'Greater Accra Region',
    'Ashanti Region',
    'Greater Accra Region',
    'Bono Region',
    'Greater Accra Region',
    'Ashanti Region',
    'Greater Accra Region',
    'Bono Region',
    'Greater Accra Region',
    'Ashanti Region',
    'Greater Accra Region',
    'Bono Region',
    'Greater Accra Region',
  ];
  static List<String> counselorPhoneNumbers = [
    '0248235689',
    '02458965656',
    '0557823456',
    '0245678921',
    '0509876543',
    '0278765432',
    '0263456789',
    '0234567890',
    '0541234567',
    '0209876543',
    '0556789012',
    '0245678901',
    '0557823456',
    '02458965656',
    '0509876543',
    '0278765432',
    '0263456789',
    '0234567890',
    '0541234567',
    '0209876543',
    '0556789012',
    '0245678901',
    '0557823456',
    '02458965656',
    '0509876543',
    '0278765432',
    '0263456789',
    '0234567890',
    '0541234567',
    '0209876543',
  ];

  static bool _getRandomBool() {
    return _random.nextBool();
  }

  static String _getRandomGender(bool isMan) {
    return isMan ? 'Male' : 'Female';
  }

  static String _getRandomReligion() {
    final religions = ['Christian', 'Muslim', 'Traditional'];
    return religions[_random.nextInt(religions.length)];
  }

  static String _getCounsellorType() {
    return counsellorTypeList[_random.nextInt(counsellorTypeList.length)];
  }

  static List<UserModel> counsellorList() {
    List<UserModel> counsellors = [];

    for (int i = 0; i < counselorNames.length; i++) {
      bool isMan = counselorNames[i].startsWith('Dr') ||
          counselorNames[i].startsWith('Mr');
      var city = counselorAddresses[i].split(',');
      counsellors.add(
        UserModel(
          name: counselorNames[i],
          email: counselorEmails[i],
          address: counselorAddresses[i],
          region: counselorRegions[i],
          password: '',
          gender: _getRandomGender(isMan),
          phone: counselorPhoneNumbers[i],
          religion: _getRandomReligion(),
          counsellorType: _getCounsellorType(),
          profile: counselorImages[i],
          userType: 'Counsellor',
          isOnline: _getRandomBool(),
          city: city[0],
        ),
      );
    }
    return counsellors;
  }
}
