String apiUrl = 'https://jc-backend-flutter.herokuapp.com/api';

String getUploadUrlByTypeFile(String tipo) {
  return 'https://api.cloudinary.com/v1_1/dbhavnbjy/$tipo/upload?upload_preset=wxrho0bl';
}

String authUrl = 'https://jc-backend-flutter.herokuapp.com/api/auth';
