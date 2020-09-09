class Errors {
  static String showError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return "Bu e-posta adresi zaten kullanılıyor. Lütfen farklı bir e-posta adresi kullanınız.";

      default:
        return "Üzgünüz, bir hata oluştu.";
    }
  }
}
