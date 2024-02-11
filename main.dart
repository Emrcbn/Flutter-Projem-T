import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_pixels/image_pixels.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final double guncelFatura = 50.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GirisYapSayfasi(),
    );
  }
}

class GirisYapSayfasi extends StatefulWidget {
  @override
  _GirisYapSayfasiState createState() => _GirisYapSayfasiState();
}

class _GirisYapSayfasiState extends State<GirisYapSayfasi> {
  final int kalanInternet = 500;
  final int kalanDakika = 120;
  final int kalanSMS = 20;
  final double guncelFatura = 50.0;

  int girisHakki = 3;
  TextEditingController telefonController = TextEditingController();
  TextEditingController sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/t_mobile_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'T Mobile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            buildInputField('Telefon Numarası', TextInputType.phone, telefonController),
            buildInputField('Şifre', TextInputType.text, sifreController, obscureText: true),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    resetPassword();
                  },
                  child: Text(
                    'Şifremi Unuttum',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showSnackBar(context, 'Yeni Şifreniz Telefon Numaranıza SMS Olarak Gönderilmiştir');
                  },
                  child: Text(
                    'Şifre Al',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int remainingAttempts = 2;
        String verificationCode = '1032';

        return StatefulBuilder(
          builder: (context, setState) {
            TextEditingController codeController = TextEditingController();

            return AlertDialog(
              title: Text('Doğrulama Kodu'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Doğrulama Kodu 1032'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kalan Deneme Hakkı: $remainingAttempts',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (codeController.text == verificationCode) {
                      Navigator.pop(context);
                      showResetPasswordPage();
                    } else {
                      setState(() {
                        remainingAttempts--;
                      });

                      if (remainingAttempts == 0) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('Doğrula'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showResetPasswordPage() {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Şifre'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newPasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Yeni Şifre'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Yeni Şifreyi Doğrula'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (newPasswordController.text == confirmPasswordController.text) {
                  Navigator.pop(context);
                  showSnackBar(context, 'Şifreniz başarıyla değiştirildi.');
                } else {
                  showSnackBar(context, 'Şifreler uyuşmuyor. Lütfen tekrar deneyin.');
                }
              },
              child: Text('Şifreyi Değiştir'),
            ),
          ],
        );
      },
    );
  }

  void login() {
    if (telefonController.text == '5325262760' && sifreController.text == '4545') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AnaSayfa(guncelFatura)),
      );

      showSnackBar(context, 'Hoşgeldiniz Emre Bey');
    } else {
      girisHakki--;
      if (girisHakki == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hata'),
              content: Text('Giriş hakkınız tükendi. Lütfen daha sonra tekrar deneyin.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    girisHakki = 3;
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hata'),
              content: Text('Telefon numaranız veya şifreniz yanlış. Kalan giriş hakkınız: $girisHakki'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
      }
    }
  }


  Widget buildInputField(String labelText, TextInputType keyboardType, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
class AnaSayfa extends StatelessWidget {
  final int kalanInternet = 500;
  final int kalanDakika = 1000;
  final int kalanSMS = 125;
  final double guncelFatura;

  AnaSayfa(this.guncelFatura);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T Mobile'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildKalanDakikaCard(context, kalanDakika),
                buildKalanInternetCard(context, kalanInternet, guncelFatura),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildFaturaBox(guncelFatura, context),
                buildKalanSMSCard(context, kalanSMS),
              ],
            ),
            SizedBox(height: 20),
            buildButtons(context),
          ],
        ),
      ),
    );

  }

  Widget buildKalanInternetCard(BuildContext context, int remaining, double faturaPrice) {
    return GestureDetector(
      onTap: () {
        _showSnackBar(context, 'Kalan İnternetiniz: $remaining MB');
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Text(
              'Kalan İnternet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('$remaining MB'),
            SizedBox(height: 10),
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              width: (remaining / 500) * 120,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKalanDakikaCard(BuildContext context, int remaining) {
    return GestureDetector(
      onTap: () {
        _showSnackBar(context, 'Kalan Dakikanız: $remaining DK');
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Text(
              'Kalan Dakikanız',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('$remaining DK'),
            SizedBox(height: 10),
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              width: (remaining / 1000) * 120,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKalanSMSCard(BuildContext context, int remaining) {
    return GestureDetector(
      onTap: () {
        _showSnackBar(context, 'Kalan SMS\'iniz: $remaining SMS');
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Text(
              'Kalan SMS\'iniz',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('$remaining SMS'),
            SizedBox(height: 10),
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              width: (remaining / 125) * 120,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFaturaBox(double price, BuildContext context) {
    // Ödeme miktarına göre renk hesapla
    Color lineColor;
    if (price < 50) {
      lineColor = Colors.green; // Örneğin, ödeme 50 TL'den azsa yeşil çizgi
    } else if (price < 100) {
      lineColor = Colors.yellow; // Örneğin, ödeme 100 TL'den azsa sarı çizgi
    } else {
      lineColor = Colors.red; // Geri kalan durumlar için kırmızı çizgi
    }
    return GestureDetector(
      onTap: () {
        _showSnackBar(context, 'Ödeme Miktarı: ₺$price');
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Text(
              'Ödeme Miktarı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('₺$price'),
            SizedBox(height: 10),
            Container(
              height: 5,
              width: 50, // Çizgi uzunluğunu buradan ayarlayabilirsiniz
              color: lineColor,
            ),
          ],
        ),
      ),
    );
  }
  Widget buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Geri Dön
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(
            'Geri Dön',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KampanyalarSayfasi()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(
            'Kampanyalar',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FaturaOdeSayfasi(guncelFatura)),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(
            'Fatura Öde',
            style: TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OdullerimSayfasi()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Text(
            'Ödüllerim',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class KampanyalarSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kampanyalar'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            // İlk sıra (Kampanya 1 ve Kampanya 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildKampanyaCard('Kampanya 1', '1000 Tl ve üzeri alışverişlerinize Şarj Kablosu hediye!', 'assets/kampanya1.png'),
                buildKampanyaCard('Kampanya 2', 'Enerjiniz Hiç Bitmesin!', 'assets/kampanya2.png'),
              ],
            ),
            SizedBox(height: 20),
            // İkinci sıra (Kampanya 3 ve Kampanya 4)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildKampanyaCard('Kampanya 3', 'Yenisi Gelsin ! ', 'assets/kampanya3.png'),
                buildKampanyaCard('Kampanya 4', 'Avantajlı PC Fiyatları!', 'assets/kampanya4.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKampanyaCard(String title, String description, String imagePath) {
    return Container(
      width: 300,
      height: 300,
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, //
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(description ?? 'Henüz bir açıklama eklenmedi.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FaturaOdeSayfasi extends StatefulWidget {
  final double guncelFatura;

  FaturaOdeSayfasi(this.guncelFatura);

  @override
  _FaturaOdeSayfasiState createState() => _FaturaOdeSayfasiState();
}

class _FaturaOdeSayfasiState extends State<FaturaOdeSayfasi> {
  TextEditingController kartNumarasiController = TextEditingController();
  TextEditingController kartSahibiController = TextEditingController();
  TextEditingController sonKullanmaController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fatura Öde'),
        centerTitle: true,
        backgroundColor: Colors.red, // Başlık arka plan rengi
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, //
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            // Kredi Kartı Önizleme
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kredi Kartı Önizleme'),
                  SizedBox(height: 10),
                  Text('Kart Numarası: ${kartNumarasiController.text}'),
                  Text('Kart Sahibi: ${kartSahibiController.text}'),
                  Text('Son Kullanma Tarihi: ${sonKullanmaController.text}'),
                  Text('CVV: ${cvvController.text}'),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Kart Numarası
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                controller: kartNumarasiController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Sadece sayı girişine izin ver
                ],
                maxLength: 16,
                decoration: InputDecoration(
                  labelText: 'Kart Numarası',
                ),
                onChanged: (value) {
                  setState(() {}); // Kart numarası değiştiğinde güncelle
                },
              ),
            ),
            SizedBox(height: 20),
            // Kart Sahibi
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                controller: kartSahibiController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')), // Sadece harf girişine izin ver
                ],
                decoration: InputDecoration(
                  labelText: 'Kart Sahibi',
                ),
                onChanged: (value) {
                  setState(() {}); // Kart sahibi değiştiğinde güncelle
                },
              ),
            ),
            SizedBox(height: 20),
            // Son Kullanma Tarihi
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                controller: sonKullanmaController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')), // Sadece sayı ve "/" girişine izin ver
                  LengthLimitingTextInputFormatter(5), // Maksimum 5 karakter
                ],
                decoration: InputDecoration(
                  labelText: 'Son Kullanma Tarihi (A.A/Y.Y)',
                ),
                onChanged: (value) {
                  setState(() {}); // Son kullanma tarihi değiştiğinde güncelle
                },
              ),
            ),
            SizedBox(height: 20),
            // CVV
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Sadece sayı girişine izin ver
                  LengthLimitingTextInputFormatter(3), // Maksimum 3 karakter
                ],
                decoration: InputDecoration(
                  labelText: 'CVV',
                ),
                onChanged: (value) {
                  setState(() {}); // CVV değiştiğinde güncelle
                },
              ),
            ),
            SizedBox(height: 21),
            // Fatura Öde Butonu
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(221),
                color: Colors.red, // Buton rengi
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Fatura öde
                  showPaymentDialog();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10), // Buton iç boşluğu
                ),
                child: Text('Fatura Öde', style: TextStyle(fontSize: 18)), // Buton metni boyutu
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentDialog() {
    TextEditingController verificationCodeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lütfen 532 526 27XX Numaralı Telefonuza Gelen Doğrulama Kodunu Girin.'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: verificationCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Doğrulama Kodu (0000)'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (verificationCodeController.text == '0000') {
                  showSuccessDialog();
                } else {
                  showFailureDialog();
                }
              },
              child: Text('Ödeme Yap'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ödeme Başarılı'),
          content: Text('Faturanız başarıyla ödendi.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ödeme Başarısız'),
          content: Text('Girilen doğrulama kodu yanlış. Lütfen tekrar deneyin.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}

class OdullerimSayfasi extends StatefulWidget {
  @override
  _OdullerimSayfasiState createState() => _OdullerimSayfasiState();
}

class _OdullerimSayfasiState extends State<OdullerimSayfasi> {
  bool kullaniciDenemeYapti = false;
  String kazanilanHediye = '';

  List<String> hediyeler = [
    '100 MB İnternet',
    '500 MB İnternet',
    '1000 MB İnternet',
    '100 SMS',
    '500 SMS',
    '1000 SMS',
    '100 Dakika',
    '500 Dakika',
    '1000 Dakika',
  ];

  String randomHediye() {
    Random random = Random();
    return hediyeler[random.nextInt(hediyeler.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ödüllerim'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  Text(
                    'Ödüllerim',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!kullaniciDenemeYapti) {
                        String kazanilan = randomHediye();
                        setState(() {
                          kullaniciDenemeYapti = true;
                          kazanilanHediye = kazanilan;
                        });
                        _showSnackBar(context, 'Tebrikler! $kazanilan kazandınız!');
                      }
                    },
                    child: Text('Şansını Dene!'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (kullaniciDenemeYapti)
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Text(
                      'Kazanılan Hediye',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      kazanilanHediye,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}


