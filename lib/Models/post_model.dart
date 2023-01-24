class PostModel {
  PostModel({
    required this.username,
    required this.posttext,
    required this.datetimepost,
    required this.id,
    required this.uid,
    required this.postImageUrl,
    required this.userImageUrl,
    required this.likecount,
    required this.likes,
    required this.commentcount,

  });
  late final String username;
  late final String posttext;
  late final String datetimepost;
  late final String id;
  late final String uid;
  late final String postImageUrl;
  late final String userImageUrl;
  late final int likecount;
  late final int commentcount;
  late final List likes;

  PostModel.fromJson(Map<String, dynamic> doc,String docId){
    username = doc['username']??"";
    posttext = doc['posttext']??"";
    datetimepost = doc['datetimepost']??"";
    uid = doc['uid']??"";
    postImageUrl =doc['postImageUrl']??"";
    userImageUrl =doc['userImageUrl']??"";
    commentcount =doc['commentcount']??0;
    likecount =doc['likecount']??0;
    likes=doc['likes']??[];
    id=docId;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['posttext'] = posttext;
    _data['datetimepost'] = datetimepost;
    _data['uid'] = uid;
    _data['id']=id;
    _data['postImageUrl']=postImageUrl;
    _data['userImageUrl']=userImageUrl;
    _data['likecount']=likecount;
    _data['likes']=likes;
    _data['commentcount']=commentcount;
    return _data;
  }
}