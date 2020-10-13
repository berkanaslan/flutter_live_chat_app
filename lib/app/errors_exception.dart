class Errors {
  static String showError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return "Bu e-posta adresi zaten kullanılıyor. Lütfen farklı bir e-posta adresi kullanınız.";
      case 'user-not-found':
        return "Bu e-posta adresi ile kayıtlı bir kullanıcı yok. Lütfen geçerli bir e-posta adresi deneyiniz.";
      case 'ınvalıd-emaıl':
        return "Yazdığınız e-posta sistemimizde kayıtlı değil. Lütfen doğru bir e-posta hesabı giriniz.";

      default:
        return "Üzgünüz, bir hata oluştu.";
    }
  }
}
