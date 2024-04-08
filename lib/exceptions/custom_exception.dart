class CustomException implements Exception {
  //firebase관련 예외를 발생 code
  final String code;
  final String message;

  const CustomException({
    required this.code,
    required this.message,
});

  @override
  String toString() {
    return this.message;
  }
}
