import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'product_management_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Expandido
          Stack(
            children: [
              Container(
                height: 300, // Header más alto
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://raw.githubusercontent.com/GarciaGalaviz0808/imgs/refs/heads/main/header.PNG'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      const Color(0xFF3E2723).withOpacity(0.4),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ),
              Center(
                child: Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Hero(
                    tag: 'logo',
                    child: Image.network(
                      'https://raw.githubusercontent.com/GarciaGalaviz0808/imgs/refs/heads/main/logo%20(1).png',
                      height: 180, // Logo mucho más grande como solicitado
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Galería Principal',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Bienvenido al centro de administración',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: const Color(0xFF5D4037).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const ProductManagementScreen()),
                          );
                        },
                        child: Container(
                          width: 400,
                          height: 85,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5D4037),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3E2723).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.brush_rounded, color: Colors.white, size: 28),
                              const SizedBox(width: 15),
                              Text(
                                'GESTIONAR PRODUCTOS',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
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
          ),
        ],
      ),
    );
  }
}
