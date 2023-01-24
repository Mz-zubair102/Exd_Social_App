class LikesModel {
  LikesModel({
    required this.likeusername,
    required this.likedatetime,
    required this.id,
    required this.uid,
    required this.postid,
    required this.userImageUrl,

  });
  late final String likeusername;
  late final String likedatetime;
  late final String id;
  late final String uid;
  late final String postid;
  late final String userImageUrl;
  LikesModel.fromJson(Map<String, dynamic> doc,String docId){
    likeusername = doc['likeusername']??"";
    likedatetime = doc['likedatetime']??"";
    uid = doc['uid']??"";
    postid =doc['postid']??"";
    userImageUrl =doc['userImageUrl']??"";
    id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['likeusername'] = likeusername;
    _data['likedatetime'] = likedatetime;
    _data['uid'] = uid;
    _data['id']=id;
    _data['postid']=postid;
    _data['userImageUrl']=userImageUrl;

    return _data;
  }
}