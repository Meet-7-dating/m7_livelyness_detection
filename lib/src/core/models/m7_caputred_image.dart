import 'dart:convert';

class M7CapturedImage {
  final String imgPath;
  final bool didCaptureAutomatically;
  M7CapturedImage({
    required this.imgPath,
    required this.didCaptureAutomatically,
  });

  M7CapturedImage copyWith({
    String? imgPath,
    bool? didCaptureAutomatically,
  }) {
    return M7CapturedImage(
      imgPath: imgPath ?? this.imgPath,
      didCaptureAutomatically:
          didCaptureAutomatically ?? this.didCaptureAutomatically,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'imgPath': imgPath});
    result.addAll({'didCaptureAutomatically': didCaptureAutomatically});

    return result;
  }

  factory M7CapturedImage.fromMap(Map<String, dynamic> map) {
    return M7CapturedImage(
      imgPath: map['imgPath'] ?? '',
      didCaptureAutomatically: map['didCaptureAutomatically'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory M7CapturedImage.fromJson(String source) =>
      M7CapturedImage.fromMap(json.decode(source));

  @override
  String toString() =>
      'M7CaptureImage(imgPath: $imgPath, didCaptureAutomatically: $didCaptureAutomatically)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is M7CapturedImage &&
        other.imgPath == imgPath &&
        other.didCaptureAutomatically == didCaptureAutomatically;
  }

  @override
  int get hashCode => imgPath.hashCode ^ didCaptureAutomatically.hashCode;
}
