class StudentModel {
  final String fullName;
  final String username;
  final String registration;
  final String email;
  final String campus;
  final String course;

  StudentModel({
    required this.fullName,
    required this.username,
    required this.registration,
    required this.email,
    required this.campus,
    required this.course,
  });

  Map<String, dynamic> toMap(String authId) {
    return {
      'id': authId,
      'full_name': fullName,
      'username': username,
      'registration': registration,
      'email': email,
      'campus': campus,
      'course': course,
      'is_active': true,
    };
  }

  factory StudentModel.fromMetadata(
    Map<String, dynamic> metadata,
    String email,
  ) {
    return StudentModel(
      fullName: metadata["full_name"],
      username: metadata["username"],
      registration: metadata["registration"],
      email: email,
      campus: metadata["campus"],
      course: metadata["course"],
    );
  }
}
