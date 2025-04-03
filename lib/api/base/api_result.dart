class ApiResult<T> {
  T? data;
  String? error;

  ApiResult({this.data, this.error});

  bool get isSuccess => this.error == null && this.data != null;
}
