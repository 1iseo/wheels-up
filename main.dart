import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HalamanKolom(),
  ));
}

class HalamanKolom extends StatefulWidget {
  @override
  _HalamanKolomState createState() => _HalamanKolomState();
}

class _HalamanKolomState extends State<HalamanKolom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 360.0, // Frame width
          height: 800.0, // Frame height
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black), // Border for the frame
          ),
          child: Stack(
            children: [
              // Back Icon
              Positioned(
                left: 20.0,
                top: 66.0,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20.0,
                  ),
                ),
              ),

              // Wheels Up Text
              Positioned(
                left: 135.0,
                top: 63.0,
                child: Container(
                  width: 105.0,
                  height: 20.0,
                  child: Text(
                    "Wheels Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              // Sign Up Text
              Positioned(
                left: 130.0,
                top: 115.0,
                child: Container(
                  width: 121.0,
                  height: 39.0,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              // Subheading
              Positioned(
                left: 107.0,
                top: 162.0,
                child: Text(
                  "Siap Menikmati Perjalananmu?",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),

              // Name Input Field
              Positioned(
                left: 20.0,
                top: 201.0,
                child: Container(
                  width: 320.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nama',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              ),

              // Email Input Field
              Positioned(
                left: 20.0,
                top: 265.0,
                child: Container(
                  width: 320.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              ),

              // Username Input Field
              Positioned(
                left: 20.0,
                top: 329.0,
                child: Container(
                  width: 320.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              ),

              // Password Input Field
              Positioned(
                left: 20.0,
                top: 393.0,
                child: Container(
                  width: 320.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              ),

              // Sebagai Toggle Field
              Positioned(
                left: 20.0,
                top: 460.0,
                child: GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman baru ketika "Sebagai" di-klik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PemilikMobilPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 310.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.black),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Sebagai',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // "Lupa Password?" Text
              Positioned(
                left: 24.0,
                top: 521.0,
                child: Text(
                  "Lupa Password?",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                  ),
                ),
              ),

              // Sign Up Button (x: 105, y: 564, width: 150, height: 48)
              Positioned(
                left: 105.0,
                top: 564.0,
                child: Container(
                  width: 150.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),

              // "Sudah punya akun? Login" Text (x: 105, y: 628, width: 150, height: 15)
              Positioned(
                left: 117.0,
                top: 628.0,
                child: RichText(
                  text: TextSpan(
                    text: "Sudah punya akun? ",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider with "atau" (x: 20, y: 664, width: 320, height: 15)
              Positioned(
                left: 20.0,
                top: 664.0,
                child: Container(
                  width: 320.0,
                  height: 15.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "atau",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Google Sign Up Button (x: 20, y: 700)
              Positioned(
                left: 20.0,
                top: 700.0,
                child: Container(
                  height: 48.0,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Google",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
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

class PemilikMobilPage extends StatefulWidget {
  @override
  _PemilikMobilPageState createState() => _PemilikMobilPageState();
}

class _PemilikMobilPageState extends State<PemilikMobilPage> {
  bool _isPemilikSelected = false; // Menandai apakah "Pemilik Mobil" dipilih
  bool _isPenyewaSelected = false; // Menandai apakah "Penyewa Mobil" dipilih
  bool _showBothOptions = true; // Mengontrol tampilan kedua kolom

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 360.0,
          height: 800.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Stack(
            children: [
              // Back Icon
              Positioned(
                left: 20.0,
                top: 66.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20.0,
                  ),
                ),
              ),

              // Wheels Up Text
              Positioned(
                left: 128.0,
                top: 63.0,
                child: Text(
                  "Wheels Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              // Sign Up Text
              Positioned(
                left: 120.0,
                top: 115.0,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              // Subheading
              Positioned(
                left: 107.0,
                top: 162.0,
                child: Text(
                  "Siap Menikmati Perjalananmu?",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),

              // Name Input Field
              _buildTextField("Nama", 201.0),

              // Email Input Field
              _buildTextField("Email", 265.0),

              // Username Input Field
              _buildTextField("Username", 329.0),

              // Password Input Field
              _buildTextField("Password", 393.0, obscureText: true),

              // Menampilkan kedua pilihan jika _showBothOptions true
              if (_showBothOptions) ...[
                _buildRoleField("Pemilik Mobil", 460.0, onTap: () {
                  setState(() {
                    _isPemilikSelected = true;
                    _isPenyewaSelected = false;
                    _showBothOptions = false;
                  });
                }),
                _buildRoleField("Penyewa Mobil", 507.0, onTap: () {
                  setState(() {
                    _isPemilikSelected = false;
                    _isPenyewaSelected = true;
                    _showBothOptions = false;
                  });
                }),
              ],

              // Menampilkan opsi yang dipilih dengan ikon dropdown
              if (!_showBothOptions && _isPemilikSelected)
                _buildSelectedRoleField("Pemilik Mobil", 460.0, onTap: () {
                  setState(() {
                    _showBothOptions = true; // Menampilkan kembali kedua opsi
                  });
                }),

              if (!_showBothOptions && _isPenyewaSelected)
                _buildSelectedRoleField("Penyewa Mobil", 460.0, onTap: () {
                  setState(() {
                    _showBothOptions = true; // Menampilkan kembali kedua opsi
                  });
                }),

              // Sign Up Button
              Positioned(
                left: 105.0,
                top: 570.0,
                child: GestureDetector(
                  onTap: () {
                    // Handle Sign Up action
                  },
                  child: Container(
                    width: 150.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // "Sudah punya akun? Login" Text
              Positioned(
                left: 105.0,
                top: 628.0, // Positioning below Sign Up Button
                child: RichText(
                  text: TextSpan(
                    text: "Sudah punya akun? ",
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider with "atau"
              Positioned(
                left: 20.0,
                top: 654.0, // Positioning below "Login" Text
                child: Container(
                  width: 320.0,
                  height: 15.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "atau",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Google Sign Up Button
              Positioned(
                left: 20.0,
                top: 690.0, // Positioning below the "atau" divider
                child: Container(
                  height: 48.0,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Google",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
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

  // Function to create text fields
  Widget _buildTextField(String hintText, double top,
      {bool obscureText = false}) {
    return Positioned(
      left: 20.0,
      top: top,
      child: Container(
        width: 320.0,
        height: 48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
    );
  }

  // Function to create role selection fields
  Widget _buildRoleField(String role, double top, {required Function() onTap}) {
    return Positioned(
      left: 20.0,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 310.0,
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    role,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create selected role fields with dropdown icon
  Widget _buildSelectedRoleField(String role, double top,
      {required Function() onTap}) {
    return Positioned(
      left: 20.0,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 310.0,
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    role,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.arrow_drop_down_sharp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
