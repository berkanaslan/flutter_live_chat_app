# Flutter Live Chat (WhatsApp Clone) with Firebase

Bu uygulama, sisteme kayıt olan tüm kullanıcıları listeleyerek, listedeki kullanıcıların birbiri ile anlık mesajlaşmasını sağlar.

Release APK için bu bağlantıyı kullanın: https://github.com/berkanaslan/flutter_live_chat_app/releases/download/v1.1.0/app-armeabi-v7a-release.apk

## Neler var?

  - Fake auth ve database işlemleri
  - Firebase auth ve database işlemleri
  - Anlık mesaj gönderimi ve anlık mesaj dinlemesi
  - Anlık mesaj dinlenirken mesajların sayfalanması (Stream ile birlikte statik yapı beraber kullanıldı)
  - Mesajların gönderim tarihine göre kategorize edilmesi & aynı tarihte gönderilmiş mesajların tek bir tarih başlığı altında görüntülenmesi
  - Mesaj geçmişinde, şu anki zaman ile son mesaj tarihi arasındaki farkı veritabanı saati üzerinden hesaplama
  - Firebase requestleri ile anlık mesaj bildirimler (Local Notification)
  - Java implementasyonu ile, uygulama kapalı olsa dahi mesaj bildirimleri
  - Provider & GetIt
  - Interface <-> ViewModel <-> Repository <-> Services yapısı
  - Ve daha fazlası...


## Kurulum

Eğer uygulamayı kendi Firebase projenize bağlamak istiyorsanız, proje kaynak dosyalarını edindikten sonra release mod için SHA1 anahtarınızı eklediğiniz google-services.json dosyası ile entegrasyonu tamamlayın.

E-Posta ve Google ile giriş, Firestore ve Storage servislerini aktif etmeyi unutmayın.


# Ekran Görüntüleri
SignIn Page             |  SignIn w/E-Mail
:-------------------------:|:-------------------------:
![1](https://berkanaslan.com/wp-content/uploads/2020/10/signinpage-709x1536.jpg)  |  ![2](https://berkanaslan.com/wp-content/uploads/2020/10/signinwithmailandpass-709x1536.jpg)

Chat History 1             |  Profile Page
:-------------------------:|:-------------------------:
![3](https://berkanaslan.com/wp-content/uploads/2020/10/chathistory1-709x1536.jpg)  |  ![4](https://berkanaslan.com/wp-content/uploads/2020/10/profile-709x1536.jpg)

Users             |  Chat Page
:-------------------------:|:-------------------------:
![5](https://berkanaslan.com/wp-content/uploads/2020/10/users-709x1536.jpg)  |  ![6](https://berkanaslan.com/wp-content/uploads/2020/10/chatpage-709x1536.jpg)

Profile Image Page             |  Chat History 2
:-------------------------:|:-------------------------:
![7](https://berkanaslan.com/wp-content/uploads/2020/10/userprofilephoto-709x1536.jpg)  |  ![8](https://berkanaslan.com/wp-content/uploads/2020/10/chathistory2-709x1536.jpg)

Notification          |  Background Notification
:-------------------------:|:-------------------------:
![7](https://berkanaslan.com/wp-content/uploads/2020/10/notification-709x1536.jpg)  |  ![8](https://berkanaslan.com/wp-content/uploads/2020/10/background-notification-709x1536.jpg)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
