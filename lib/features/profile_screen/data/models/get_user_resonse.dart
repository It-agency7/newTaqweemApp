class GetUserResopnse {
  GetUserResopnse({
    required this.id,
    required this.name,
    required this.email,
     this.emailVerifiedAt,
    required this.fcm,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this.openNotify,
    required this.isActive,
    required this.PhotoLink,
  });
  late final int id;
  late final String name;
  late final String email;
  late final Null emailVerifiedAt;
  late final String fcm;
  late final String photo;
  late final String createdAt;
  late final String updatedAt;
  late final String openNotify;
  late final String isActive;
  late final String PhotoLink;
  
  GetUserResopnse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = null;
    fcm = json['fcm'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    openNotify = json['open_notify'];
    isActive = json['is_active'];
    PhotoLink = json['PhotoLink'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['fcm'] = fcm;
    _data['photo'] = photo;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['open_notify'] = openNotify;
    _data['is_active'] = isActive;
    _data['PhotoLink'] = PhotoLink;
    return _data;
  }
}