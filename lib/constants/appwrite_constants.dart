class AppwriteConstants {
  static const String databaseId = '6669a7220033de4f8967';
  static const String projectId = '6669a4f7001f84cde53d';
  static const String endPoint = 'http://localhost:80/v1';
  static const String usersCollection = '666d373900050fa6332b';
  static const String tweetsCollection = '666dcaa3003d2cf47d6c';
  static const String imagesBucket = '666e75fa00129bd41ded';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
