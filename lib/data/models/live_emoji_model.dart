class LiveEmojiModel {
  String name;
  String emoji;
  String? foreground;
  String? background;
  bool? backgroundRepeat;
  bool? foregroundRepeat;
  LiveEmojiModel(
      {required this.emoji,
      required this.background,
      required this.foreground,
      required this.name,
      required this.backgroundRepeat,
      required this.foregroundRepeat});

  factory LiveEmojiModel.fromJson(Map<String, dynamic> json, String name) {
    return LiveEmojiModel(
      name: name,
      emoji: json['emoji'],
      background: json['background'],
      foreground: json['foreground'],
      backgroundRepeat: json['backgroundRepeat'],
      foregroundRepeat: json['foregroundRepeat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'background': background,
      'foreground': foreground,
      'backgroundRepeat': backgroundRepeat,
      'foregroundRepeat': foregroundRepeat
    };
  }
}
