import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app_flutter/features/home/domain/entities/todo_entity.dart';

part 'todo_model.g.dart';

/// Data model: serialises to/from Firestore documents.
/// json_serializable handles the boilerplate toJson/fromJson.
@JsonSerializable(explicitToJson: true)
class TodoModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final bool isCompleted;
  @JsonKey(
    fromJson: _timestampToDateTime,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime createdAt;

  const TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  /// Convert a Firestore document snapshot to [TodoModel].
  factory TodoModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TodoModel(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      description: (data['description'] as String?) ?? '',
      isCompleted: (data['isCompleted'] as bool?) ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Map to domain entity.
  TodoEntity toEntity() => TodoEntity(
        id: id,
        userId: userId,
        title: title,
        description: description,
        isCompleted: isCompleted,
        createdAt: createdAt,
      );

  // --- helper converters for json_serializable ---
  static DateTime _timestampToDateTime(dynamic v) =>
      v is Timestamp ? v.toDate() : DateTime.parse(v as String);

  static dynamic _dateTimeToTimestamp(DateTime dt) =>
      Timestamp.fromDate(dt);
}
