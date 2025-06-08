class EmailModel {
  String email_address;
  String title;
  String? content;
  EmailModel({
    required this.email_address,
    required this.title,
    this.content,
  });
}
