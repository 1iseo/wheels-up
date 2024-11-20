import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WheelsUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // Automatically navigate to NextPage after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 360,
          height: 800,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/wheelsup_logo.png', // Replace with the actual path to your WheelsUp logo
                  width: 342,
                  height: 342,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to create a fade transition route
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

// Custom clipper to clip only the bottom part into a triangle
class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Draw the rectangle from the top to the middle
    path.lineTo(0,
        size.height * 0.65); // Go from top-left to slightly above bottom-left
    path.lineTo(size.width / 2, size.height); // Go to the bottom center
    path.lineTo(
        size.width, size.height * 0.65); // Go to slightly above bottom-right
    path.lineTo(size.width, 0); // Go to top-right
    path.close(); // Complete the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 360,
          height: 800,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, 0),
                  child: ClipPath(
                    clipper: BottomClipper(),
                    child: Image.asset(
                      'assets/jeep.png',
                      width: 360,
                      height: 500,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  'WheelsUp',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  'Offroad Anytime, Anywhere. \nBooking Mudah, Petualangan Tak Terbatas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 48,
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          "Let's Go!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'User Manual',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

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
              Positioned(
                left: 20.0,
                top: 66.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back when tapped
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 20, // Set width to 20
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                left: 115.0,
                top: 63.0,
                child: Text(
                  "Wheels Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Positioned(
                left: 139.0,
                top: 115.0,
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Positioned(
                left: 70.0,
                top: 162.0,
                child: Text(
                  "Siap Menikmati Perjalananmu?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 201.0,
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "username",
                      errorText: usernameError,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 265.0,
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "password",
                      errorText: passwordError,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
              Positioned(
                left: 24.0,
                top: 329.0,
                child: Text(
                  "Lupa Password?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
              Positioned(
                left: 105.0,
                top: 357.0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      usernameError = usernameController.text.isEmpty
                          ? 'Anda belum memasukkan data'
                          : null;
                      passwordError = passwordController.text.isEmpty
                          ? 'Anda belum memasukkan data'
                          : null;
                    });
                    if (usernameError == null && passwordError == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeFrame()),
                      );
                    }
                  },
                  child: Container(
                    height: 48.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        "login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 99.0,
                top: 421.0,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the Sign Up page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUP()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Belum punya akun? ",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                          ),
                        ),
                      ],
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
}

class SignUP extends StatefulWidget {
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _sebagaiValue = "Sebagai"; // Default value for "Sebagai"

  String? _nameError;
  String? _emailError;
  String? _usernameError;
  String? _passwordError;

  void _validateAndSubmit() {
    setState(() {
      _nameError =
          _nameController.text.isEmpty ? "Anda belum memasukkan data" : null;
      _emailError =
          _emailController.text.isEmpty ? "Anda belum memasukkan data" : null;
      _usernameError = _usernameController.text.isEmpty
          ? "Anda belum memasukkan data"
          : null;
      _passwordError = _passwordController.text.isEmpty
          ? "Anda belum memasukkan data"
          : null;
    });
  }

  void _showSebagaiDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Sebagai'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Pemilik Mobil'),
                onTap: () {
                  setState(() {
                    _sebagaiValue = 'Pemilik Mobil';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Penyewa Mobil'),
                onTap: () {
                  setState(() {
                    _sebagaiValue = 'Penyewa Mobil';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _goBack() {
    Navigator.pop(context); // Navigate back to the previous screen
  }

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
              Positioned(
                left: 20.0,
                top: 66.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back when tapped
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 20.0, // Increase the width of the touchable area
                        height:
                            66.0, // Increase the height of the touchable area
                        decoration: BoxDecoration(
                          shape:
                              BoxShape.circle, // Making the container circular
                          color: Colors.white, // Background color for the icon
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20, // Icon size
                          color: Colors.black, // Icon color
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // "Wheels Up" text in the center
              Positioned(
                left: 0,
                right: 0,
                top: 63.0,
                child: Text(
                  "Wheels Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // "Sign Up" text in the center
              Positioned(
                left: 0,
                right: 0,
                top: 115.0,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // "Siap Menikmati Perjalananmu?" text in the center
              Positioned(
                left: 0,
                right: 0,
                top: 162.0,
                child: Text(
                  "Siap Menikmati Perjalananmu?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                left: 20.0,
                top: 201.0,
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nama",
                        errorText: _nameError,
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 265.0,
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        errorText: _emailError,
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 329.0,
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Username",
                        errorText: _usernameError,
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 393.0,
                child: Container(
                  height: 48,
                  width: 320.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        errorText: _passwordError,
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      obscureText: true,
                    ),
                  ),
                ),
              ),
              // Sebagai Toggle Field
              Positioned(
                left: 20.0,
                top: 460.0,
                child: GestureDetector(
                  onTap: _showSebagaiDialog,
                  child: Container(
                    height: 48.0,
                    width: 320.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            _sebagaiValue, // Menampilkan nilai yang dipilih
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),

              // New Column with black background and "Sign Up" text
              Positioned(
                left: 105.0, // Centering the container horizontally
                top: 540.0, // Adjust top position as needed
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back to LoginPage
                  },
                  child: Container(
                    width: 150.0, // Width set to 150
                    height: 48.0, // Height set to 48
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.circular(15.0), // Radius set to 15.0
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 105.0,
                top: 595.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(
                        context); // Navigate to login page or any other action
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Sudah punya akun? ",
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(fontSize: 12.0, color: Colors.blue),
                        ),
                      ],
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
}

class HomeFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmptyPage(),
    );
  }
}

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          color: Colors.white, // Frame with white color
          child: Stack(
            children: [
              // Text "WheelsUp" at x: 127, y: 63
              Positioned(
                left: 127,
                top: 30,
                child: Text(
                  'WheelsUp',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Text color
                  ),
                ),
              ),
              // Transparent column with icon and text at x: 20, y: 107
              Positioned(
                left: 60,
                top: 80,
                child: Container(
                  width: 280,
                  height: 49,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Transparent color
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 40,
                        color: Colors.black, // Icon color
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Halo!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black, // Text color
                            ),
                          ),
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Text color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 35,
                top: 185,
                child: Text(
                  'Populer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Scrollable list below "Populer" text
              Positioned(
                left: 0,
                top: 210,
                child: Container(
                  width: 360,
                  height: 550,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(20, (index) {
                        return GestureDetector(
                          child: Container(
                            width: 321,
                            height: 227,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 320,
                                  height: 135,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          'https://via.placeholder.com/320x135'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Kendaraan ${index + 1}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Harga: Rp. ${(index + 1) * 100000}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          // Tambahkan aksi berdasarkan pilihan
                                          if (value == 'edit') {
                                            print('Edit item ${index + 1}');
                                            // Navigasi ke halaman edit atau tampilkan dialog
                                          } else if (value == 'delete') {
                                            print('Hapus item ${index + 1}');
                                            // Logika untuk menghapus item
                                          } else if (value == 'add') {
                                            print('Tambah item baru');
                                            // Logika untuk menambah item baru
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Hapus'),
                                          ),
                                          PopupMenuItem(
                                            value: 'add',
                                            child: Text('Tambah'),
                                          ),
                                        ],
                                        child: Icon(Icons.more_vert),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Text(
                                    'Lokasi: Lokasi ${index + 1}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),

              // Bottom navigation bar
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 360,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.home, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeFrame()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_box, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RiwayatChatPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.history, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RiwayatPemesananPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilPage()));
                        },
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

// Method to show filter dialog
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        _buildFilterColumn('Murah'),
                        _buildFilterColumn('Terjamin'),
                        _buildFilterColumn('Nyaman'),
                      ],
                    ),
                    Column(
                      children: [
                        _buildFilterColumn('Berkualitas'),
                        _buildFilterColumn('Aman'),
                        _buildFilterColumn('Terdekat'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Apply Filters'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Helper method to create filter columns
  Widget _buildFilterColumn(String label) {
    return Container(
      width: 90,
      height: 30,
      margin:
          EdgeInsets.only(bottom: 8), // Menambahkan jarak antara kolom filter
      decoration: BoxDecoration(
        color: Colors.blueGrey[100], // Background color
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  final String email = "user@example.com";

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
                left: 20.0, // x coordinate
                top: 25.0, // y coordinate
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context); // Pop to go back to the previous page
                  },
                ),
              ),

              // Wheels Up Text
              Positioned(
                left: 128.0,
                top: 25.0,
                child: Text(
                  "Wheels Up",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Account Circle Icon
              Positioned(
                left: 120.0,
                top: 70.0,
                child: Icon(
                  Icons.account_circle,
                  size: 120.0, // Size of the icon
                  color: Colors.black,
                ),
              ),

              // Email Text Centered
              Positioned(
                left: 100.0,
                top: 240.0, // Position below the account icon
                child: Center(
                  child: Text(
                    email, // Display the email
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // First Column (Edit Profil)
              _buildClickableColumn(
                context,
                "Edit Profil",
                300.0,
                Colors.black,
                EditProfileFrame(), // Navigate to EditProfileFrame
              ),

              // Second Column (Ganti Akun)
              _buildClickableColumn(
                context,
                "Ganti Akun",
                360.0,
                Colors.black,
                LoginPage(), // Navigate to GantiAkunPage
              ),

              // Third Column with red text and icon (Log Out)
              _buildClickableColumn(
                context,
                "Log Out",
                420.0,
                Colors.red,
                LoginPage(), // Navigate to LoginPage
              ),

              // Bottom Navigation Bar
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 360,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.home, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeFrame()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_box, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RiwayatChatPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.history, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RiwayatPemesananPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilPage()));
                        },
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

  // Function to build columns with text and icon
  Positioned _buildClickableColumn(
    BuildContext context,
    String text,
    double top,
    Color textColor,
    Widget page,
  ) {
    return Positioned(
      left: 20.0,
      top: top,
      child: GestureDetector(
        onTap: () {
          // Navigate to the corresponding page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          width: 320.0,
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor, // Use the passed color
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                  color: textColor, // Use the passed color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// EditProfileFrame page
class EditProfileFrame extends StatefulWidget {
  @override
  _EditProfileFrameState createState() => _EditProfileFrameState();
}

class _EditProfileFrameState extends State<EditProfileFrame> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _nomorSIMController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();

  String _errorNama = '';
  String _errorEmail = '';
  String _errorNomorTelepon = '';
  String _errorNomorSIM = '';
  String _errorPassword = '';
  String _errorKonfirmasiPassword = '';

  void _simpan() {
    setState(() {
      // Reset error messages
      _errorNama = '';
      _errorEmail = '';
      _errorNomorTelepon = '';
      _errorNomorSIM = '';
      _errorPassword = '';
      _errorKonfirmasiPassword = '';

      // Check if fields are empty
      if (_namaController.text.isEmpty) {
        _errorNama = 'Anda belum memasukkan data';
      }
      if (_emailController.text.isEmpty) {
        _errorEmail = 'Anda belum memasukkan data';
      }
      if (_nomorTeleponController.text.isEmpty) {
        _errorNomorTelepon = 'Anda belum memasukkan data';
      }
      if (_nomorSIMController.text.isEmpty) {
        _errorNomorSIM = 'Anda belum memasukkan data';
      }
      if (_passwordController.text.isEmpty) {
        _errorPassword = 'Anda belum memasukkan data';
      }
      if (_konfirmasiPasswordController.text.isEmpty) {
        _errorKonfirmasiPassword = 'Anda belum memasukkan data';
      }

      // If no errors, navigate to ViewProfilePage
      if (_errorNama.isEmpty &&
          _errorEmail.isEmpty &&
          _errorNomorTelepon.isEmpty &&
          _errorNomorSIM.isEmpty &&
          _errorPassword.isEmpty &&
          _errorKonfirmasiPassword.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfilePage(
              nama: _namaController.text,
              email: _emailController.text,
              nomorTelepon: _nomorTeleponController.text,
              nomorSIM: _nomorSIMController.text,
              password: _passwordController.text,
            ),
          ),
        );
      }
    });
  }

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
              // Back Icon
              Positioned(
                left: 20.0,
                top: 58.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back when tapped
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20.0,
                  ),
                ),
              ),

              // Centering Wheels Up Text
              Positioned(
                left: 0,
                right: 0,
                top: 58.0,
                child: Center(
                  child: Text(
                    "Wheels Up",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              // Centering Edit Profilmu Text
              Positioned(
                left: 0,
                right: 0,
                top: 107.0,
                child: Center(
                  child: Text(
                    "Edit Profilmu",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              // Adding account_circle icon above the first column
              Positioned(
                left: 120.0,
                top: 150.0,
                child: Icon(
                  Icons.account_circle,
                  size: 100.0,
                  color: Colors.black,
                ),
              ),

              // Editable TextFields
              _buildTextField(_namaController, "Nama", 267.0, _errorNama),
              _buildTextField(_emailController, "Email", 331.0, _errorEmail),
              _buildTextField(_nomorTeleponController, "Nomor Telepon", 395.0,
                  _errorNomorTelepon),
              _buildTextField(
                  _nomorSIMController, "Nomor SIM", 459.0, _errorNomorSIM),
              _buildTextField(
                  _passwordController, "Password", 523.0, _errorPassword),
              _buildTextField(_konfirmasiPasswordController,
                  "Konfirmasi Password", 587.0, _errorKonfirmasiPassword),

              // Simpan Button
              Positioned(
                left: 105.0,
                top: 659.0, // Position for the button
                child: GestureDetector(
                  onTap: _simpan, // Call the _simpan function when tapped
                  child: Container(
                    width: 150.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
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

  // Function to build editable text fields
  Positioned _buildTextField(TextEditingController controller, String hintText,
      double top, String errorText) {
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
        child: TextField(
          controller: controller, // Set the controller for the text field
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText.isNotEmpty
                ? errorText
                : null, // Show error message if exists
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
    );
  }
}

class ViewProfilePage extends StatelessWidget {
  final String nama;
  final String email;
  final String nomorTelepon;
  final String nomorSIM;
  final String password;

  ViewProfilePage({
    required this.nama,
    required this.email,
    required this.nomorTelepon,
    required this.nomorSIM,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Hide default AppBar
      ),
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Icon arrow back with navigation
              Positioned(
                left: 20,
                top: 66,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back when tapped
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 20, // Set width to 20
                    color: Colors.black,
                  ),
                ),
              ),
              // Text "WheelsUp"
              Positioned(
                left: 0,
                top: 50, // Set vertical position to center
                right: 0,
                child: Center(
                  child: Text(
                    "WheelsUp",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Text "Profilmu"
              Positioned(
                left: 0,
                top: 90, // Set vertical position to center
                right: 0,
                child: Center(
                  child: Text(
                    "Profilmu",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Icon account_circle
              Positioned(
                left: 130,
                top: 145,
                child: Container(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.account_circle,
                    size: 100, // Set width and height
                  ),
                ),
              ),
              // Display data below account_circle icon
              Positioned(
                left: 20,
                top: 250,
                child: Column(
                  children: [
                    _buildDataColumn(nama),
                    _buildDataColumn(email),
                    _buildDataColumn(nomorTelepon),
                    _buildDataColumn(nomorSIM),
                    _buildDataColumn(password),
                    _buildEditProfileColumn(context), // New edit profile column
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build data display columns without labels
  Widget _buildDataColumn(String data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10), // Space between columns
      child: Container(
        width: 320, // Column width
        height: 48, // Column height
        decoration: BoxDecoration(
          color: Colors.white, // White background
          border: Border.all(color: Colors.black, width: 1), // Black border
          borderRadius: BorderRadius.circular(15), // Radius 15
        ),
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16), // Left padding for alignment
              child: Text(
                data, // Display data only
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Optional: Use bold for data
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the Edit Profile column
  Widget _buildEditProfileColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10), // Space between columns
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditProfileFrame()), // Navigate to EditProfileFrame
          );
        },
        child: Container(
          width: 320, // Column width
          height: 48, // Column height
          decoration: BoxDecoration(
            color: Colors.white, // White background
            border: Border.all(color: Colors.black, width: 1), // Black border
            borderRadius: BorderRadius.circular(15), // Radius 15
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16), // Left padding
                child: Text(
                  "Edit Profil", // Edit Profil text
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold, // Optional: Use bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16), // Right padding
                child: Icon(Icons.arrow_forward_ios), // Arrow forward icon
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RiwayatPemesananPage extends StatefulWidget {
  @override
  _RiwayatPemesananPageState createState() => _RiwayatPemesananPageState();
}

class _RiwayatPemesananPageState extends State<RiwayatPemesananPage> {
  List<String> _statusOptions = [
    'Mobil sudah dikembalikan',
    'Mobil belum dikembalikan',
  ];
  String? _selectedStatus; // Status yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0, // Hide default AppBar
        ),
        body: Center(
            child: Container(
                width: 360,
                height: 800,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(children: [
                  // Icon back
                  Positioned(
                    left: 20,
                    top: 50,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Navigate back when tapped
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Text "WheelsUp"
                  Positioned(
                    left: 0,
                    top: 50,
                    right: 0,
                    child: Center(
                      child: Text(
                        "WheelsUp",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Text 'Riwayat Pemesanan'
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Text(
                      'Riwayat Pemesanan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Icon account circular
                  Positioned(
                    top: 120,
                    left: 22,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.account_circle,
                          size: 55, color: Colors.grey[700]),
                    ),
                  ),
                  // Text 'Nama Kendaraan'
                  Positioned(
                    top: 125,
                    left: 85,
                    child: Text(
                      'Nama Kendaraan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  // Icon rating
                  Positioned(
                    top: 150,
                    left: 85,
                    child: Row(
                      children: List.generate(
                        5,
                        (index) =>
                            Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                    ),
                  ),
                  // Text 'Pemilik Kendaraan'
                  Positioned(
                    top: 180,
                    left: 31,
                    child: Text(
                      'Nama penyewa kendaraan',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  // Icon chat bubble
                  Positioned(
                    right: 40,
                    top: 180.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.chat_bubble,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(), // Update this to your ChatPage class
                          ),
                        );
                      },
                    ),
                  ),
                  // Frame utama untuk proses pemesanan
                  Positioned(
                    top: 240,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Proses 1: Mobil telah dipesan
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.assignment,
                                      color: Colors.grey[700], size: 24),
                                  Container(
                                    height: 40,
                                    width: 2,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mobil telah dipesan!',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '12 Oktober 2024',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Jarak antar proses
                          // Proses 2: Mobil sedang digunakan
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.directions_car,
                                      color: Colors.grey[700], size: 24),
                                  Container(
                                    height: 40,
                                    width: 2,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Mobil sedang digunakan',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Jarak antar proses
                          // Proses 3: Mobil sudah dikembalikan dengan DropdownButton
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.house,
                                  color: Colors.grey[700], size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedStatus,
                                    hint: Text(
                                      'Pilih Status Pengembalian',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.black),
                                    items: _statusOptions.map((String status) {
                                      return DropdownMenuItem<String>(
                                        value: status,
                                        child: Text(status,
                                            style: TextStyle(fontSize: 16)),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedStatus = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Masukkan Tanggal',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Tambahkan fungsi simpan di sini
                              },
                              child: Text('Simpan'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]))));
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Tinggi AppBar khusus
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "WheelsUp",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header atau informasi tambahan (opsional)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 28, color: Colors.grey[700]),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama Pemilik Kendaraan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Aktif 5 menit yang lalu",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.grey[600]),
              ],
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),

          // Daftar pesan
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: 10, // Ganti sesuai jumlah pesan
              itemBuilder: (context, index) {
                bool isSender = index % 2 == 0; // Pesan bergantian kiri/kanan
                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSender
                          ? Colors.blue[100]
                          : Colors.grey[300], // Warna bubble
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft:
                            isSender ? Radius.circular(12) : Radius.circular(0),
                        bottomRight:
                            isSender ? Radius.circular(0) : Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      isSender
                          ? "Pesan dari pengirim $index"
                          : "Pesan dari penerima $index",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input pesan
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Logika untuk mengirim pesan
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          color: Colors.white,
          child: Stack(
            children: [
              // Judul "WheelsUp"
              Positioned(
                left: 127,
                top: 30,
                child: Text(
                  'WheelsUp',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Tombol back
              Positioned(
                left: 20,
                top: 25,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(
                        context); // Pop untuk kembali ke halaman sebelumnya
                  },
                ),
              ),

              // Profil Pengguna
              Positioned(
                top: 90,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Nama Pengguna",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Kolom Input "Nama Mobil"
              Positioned(
                top: 180,
                left: 20,
                child: _buildInputField("Nama Mobil", false),
              ),

              // Kolom Input "Harga"
              Positioned(
                top: 240,
                left: 20,
                child: _buildInputField("Harga", false),
              ),

              // Kolom Input "Alamat"
              Positioned(
                top: 300,
                left: 20,
                child: _buildInputField("Alamat", false),
              ),

              // Teks "Masukkan deskripsi di bawah"
              Positioned(
                top: 350,
                left: 20,
                child: Text(
                  "Masukkan deskripsi di bawah",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Kolom Input "Deskripsi"
              Positioned(
                top: 380,
                left: 20,
                child: _buildInputField("Deskripsi", true, height: 177),
              ),

              // Kolom Input "Masukkan Foto Properti"
              Positioned(
                top: 580,
                left: 20,
                child: Container(
                  width: 320,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.camera_alt, color: Colors.grey[600]),
                      ),
                      Expanded(
                        child: Text(
                          "Masukkan Foto Properti",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol "Simpan"
              Positioned(
                top: 650,
                left: 105,
                child: SizedBox(
                  width: 150,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika untuk menyimpan data
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Navigation Bar
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 360,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.home, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeFrame()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_box, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RiwayatChatPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.history, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RiwayatPemesananPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilPage()));
                        },
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

  // Widget untuk membangun kolom input
  Widget _buildInputField(String hintText, bool isMultiline,
      {double height = 48}) {
    return Container(
      width: 320,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: TextField(
        maxLines: isMultiline ? null : 1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}

class RiwayatChatPage extends StatelessWidget {
  // Sample list of users with the last message
  final List<Map<String, String>> chatUsers = [
    {
      'name': 'John Doe',
      'lastMessage': 'Hey, how are you?',
      'image': 'assets/user1.jpg',
    },
    {
      'name': 'Jane Smith',
      'lastMessage': 'Let\'s meet up later!',
      'image': 'assets/user2.jpg',
    },
    {
      'name': 'Alex Brown',
      'lastMessage': 'Got your message!',
      'image': 'assets/user3.jpg',
    },
    // Add more users as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          child: Column(
            children: [
              SizedBox(height: 20),
              // Text "Riwayat Chat"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Riwayat Chat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // List of chat users
              Expanded(
                child: ListView.builder(
                  itemCount: chatUsers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage(chatUsers[index]['image'] ?? ''),
                      ),
                      title: Text(chatUsers[index]['name'] ?? ''),
                      subtitle: Text(chatUsers[index]['lastMessage'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.chat_bubble, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        },
                      ),
                      onTap: () {
                        // Logic to open the chat with the user
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatPage()),
                        );
                      },
                    );
                  },
                ),
              ),

              // Bottom Navigation Bar
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 360,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.home, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeFrame()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_box, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RiwayatChatPage()));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.history, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RiwayatPemesananPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilPage()));
                        },
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
