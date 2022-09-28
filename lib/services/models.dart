import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Comments {
  String comment;
  String commenter;

  Comments(this.comment, this.commenter);

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}
