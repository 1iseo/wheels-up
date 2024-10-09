import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HalamanSatu(),
  ));
}

class HalamanSatu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 360.0, // Lebar frame
          height: 800.0, // Tinggi frame
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black), // Menambahkan border untuk frame
          ),
          child: Stack(
            children: [
              // Ikon kembali di posisi x: 20.0, y: 66.0
              Positioned(
                left: 20.0, // Koordinat x
                top: 66.0, // Koordinat y
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),

              // Teks "Wheels Up" di posisi x: 128.0, y: 63.0
              Positioned(
                left: 128.0, // Koordinat x
                top: 63.0, // Koordinat y
                child: Text(
                  "Wheels Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0, // Ukuran teks untuk "Wheels Up"
                    fontWeight: FontWeight.w900, // Mengatur fontWeight
                  ),
                ),
              ),

              // Teks "LOGIN" di posisi x: 139.0, y: 115.0
              Positioned(
                left: 139.0, // Koordinat x
                top: 115.0, // Koordinat y
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w900, // Mengatur fontWeight
                  ),
                ),
              ),

              // Teks "Siap Menikmati Perjalananmu?" di posisi x: 107.0, y: 162.0
              Positioned(
                left: 107.0, // Koordinat x
                top: 162.0, // Koordinat y
                child: Text(
                  "Siap Menikmati Perjalananmu?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),

              // Kolom pertama di posisi x: 20.0, y: 201.0
              Positioned(
                left: 20.0, // Koordinat x
                top: 201.0, // Koordinat y
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey, // Warna latar belakang kolom pertama
                    borderRadius:
                        BorderRadius.circular(15.0), // Sudut melengkung
                  ),
                  child: Center(
                    child: Text(
                      "username", // Teks "username" di dalam kolom pertama
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),

              // Kolom kedua di posisi x: 20.0, y: 265.0
              Positioned(
                left: 20.0, // Koordinat x
                top: 265.0, // Koordinat y
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey, // Warna latar belakang kolom kedua
                    borderRadius:
                        BorderRadius.circular(15.0), // Sudut melengkung
                  ),
                  child: Center(
                    child: Text(
                      "password", // Teks "password" di dalam kolom kedua
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),

              // Teks "Lupa Password?" di posisi x: 24.0, y: 329.0
              Positioned(
                left: 24.0, // Koordinat x
                top: 329.0, // Koordinat y
                child: Text(
                  "Lupa Password?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),

              // Kolom baru dengan teks "login" di posisi x: 105.0, y: 357.0
              Positioned(
                left: 105.0, // Koordinat x
                top: 357.0, // Koordinat y
                child: Container(
                  height: 48.0, // Tinggi kolom
                  width: 150.0, // Lebar kolom
                  decoration: BoxDecoration(
                    color: Colors.black, // Warna latar belakang hitam
                    borderRadius:
                        BorderRadius.circular(15.0), // Sudut melengkung
                  ),
                  child: Center(
                    child: Text(
                      "login", // Teks "login" di dalam kolom
                      style: TextStyle(
                        color: Colors.white, // Warna teks putih
                        fontSize: 18.0, // Ukuran teks
                      ),
                    ),
                  ),
                ),
              ),

              // Teks "Belum punya akun?" dan "Sign Up" di posisi x: 99.0, y: 421.0 (satu baris)
              Positioned(
                left: 99.0, // Koordinat x
                top: 421.0, // Koordinat y
                child: RichText(
                  text: TextSpan(
                    text: "Belum punya akun? ", // Teks pertama
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up", // Teks kedua (Sign Up)
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.blue, // Warna teks Sign Up biru
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Garis horizontal dengan teks "atau" di tengah dengan width 320 dan height 15
              Positioned(
                left: 20.0, // Koordinat x
                top: 457.0, // Koordinat y
                child: Container(
                  width: 320.0, // Lebar garis
                  height: 15.0, // Tinggi container
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1, // Ketebalan garis
                          color: Colors.black, // Warna garis
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "atau", // Teks di tengah garis
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1, // Ketebalan garis
                          color: Colors.black, // Warna garis
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Kolom baru dengan ikon Google di posisi x: 20, y: 685
              Positioned(
                left: 20.0, // Koordinat x
                top: 493.0, // Koordinat y
                child: Container(
                  height: 48.0, // Tinggi kolom
                  width: 320.0, // Lebar kolom
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang putih
                    border: Border.all(
                      color: Colors.black, // Border hitam
                    ),
                    borderRadius: BorderRadius.circular(15.0), // Radius 15
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons
                            .account_circle, // Ikon Google (gunakan ikon Google sesuai kebutuhan)
                        color: Colors.black, // Warna ikon
                      ),
                      SizedBox(width: 10.0), // Jarak antara ikon dan teks
                      Text(
                        "Google", // Teks Google
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black, // Warna teks hitam
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
