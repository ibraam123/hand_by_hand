
class FeatureModel{
  final String title;
  final String subtitle;
  final String? image;
  final String buttonText;
  final void Function()? onPress;

  FeatureModel({
    this.onPress,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
  });

}