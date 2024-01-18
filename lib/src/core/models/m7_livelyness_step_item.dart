import 'package:m7_livelyness_detection/index.dart';

class M7LivelynessStepItem {
  //enum
  final M7LivelynessStep step;
  final double? thresholdToCheck;
  final bool isCompleted;

  M7LivelynessStepItem({
    required this.step,
    this.thresholdToCheck,
    required this.isCompleted,
  });

  M7LivelynessStepItem copyWith({
    M7LivelynessStep? step,
    String? title,
    double? thresholdToCheck,
    bool? isCompleted,
  }) {
    return M7LivelynessStepItem(
      step: step ?? this.step,
      thresholdToCheck: thresholdToCheck ?? this.thresholdToCheck,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'step': step.index});
    if (thresholdToCheck != null) {
      result.addAll({'thresholdToCheck': thresholdToCheck});
    }
    result.addAll({'isCompleted': isCompleted});

    return result;
  }

  factory M7LivelynessStepItem.fromMap(Map<String, dynamic> map) {
    return M7LivelynessStepItem(
      step: M7LivelynessStep.values[map['step'] ?? 0],
      thresholdToCheck: map['thresholdToCheck']?.toDouble(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory M7LivelynessStepItem.fromJson(String source) =>
      M7LivelynessStepItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'M7LivelynessStepItem(step: $step, thresholdToCheck: $thresholdToCheck, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is M7LivelynessStepItem &&
        other.step == step &&
        other.thresholdToCheck == thresholdToCheck &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return step.hashCode ^
        thresholdToCheck.hashCode ^
        isCompleted.hashCode;
  }
}
