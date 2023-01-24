class UsersModel {
  UsersModel({
    required this.email,
    required this.name,
    // required this.phone,
    required this.id,
    required this.uid,
    required this.profileImageUrl,
    required this.coverImageUrl,
    required this.metadata,

  });
  late final String email;
  late final Map metadata;
  late final String name;
  // late final String phone;
  late final String id;
  late final String uid;
  late final String profileImageUrl;
  late final String coverImageUrl;
  UsersModel.fromJson(Map<String, dynamic> doc,String docId){
    email = doc['email']??"";
    name = doc['name']??"";
    // Map<String, dynamic>? metadata,
    metadata = doc['metadata']??{};
    // phone = doc['phone'];
    uid = doc['uid']??"";
    profileImageUrl =doc['profileImageUrl']??"";
    coverImageUrl =doc['coverImageUrl']??"";
    id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['name'] = name;
    // _data['Phone'] = phone;
    _data['metadata'] = metadata;
    _data['uid'] = uid;
    _data['id']=id;
    _data['profileImageUrl']='profileImageUrl';
    _data['coverImageUrl']='coverImageUrl';
    return _data;
  }
}