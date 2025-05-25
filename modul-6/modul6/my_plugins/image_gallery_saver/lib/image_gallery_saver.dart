class ImageGallerySaver {
  static Future<String> saveImage(List<int> imageBytes, {String? name}) async {
    return "${name ?? 'saved_image'}.jpg";
  }
}