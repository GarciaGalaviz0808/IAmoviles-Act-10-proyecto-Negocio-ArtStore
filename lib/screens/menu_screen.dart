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
          LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              bool isMobile = screenWidth < 600;
              return Stack(
                children: [
                  Container(
                    height: isMobile ? 180 : 300, // Header más bajo en móvil
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://raw.githubusercontent.com/GarciaGalaviz0808/imgs/refs/heads/main/header.PNG'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: isMobile ? 180 : 300,
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
                    top: isMobile ? 35 : 50,
                    right: 20,
                    child: IconButton(
                      icon: Icon(Icons.logout_rounded, color: Colors.white, size: isMobile ? 24 : 28),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ),
                  // Logo en la esquina superior izquierda
                  Positioned(
                    top: isMobile ? 30 : 40,
                    left: 20,
                    child: Hero(
                      tag: 'logo',
                      child: Image.network(
                        'https://raw.githubusercontent.com/GarciaGalaviz0808/imgs/refs/heads/main/logo%20(1).png',
                        height: isMobile ? 50 : 90, 
                      ),
                    ),
                  ),
                  // Nombre del negocio centrado
                  Container(
                    height: isMobile ? 180 : 300,
                    alignment: Alignment.center,
                    child: Text(
                      'ArtStore',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: isMobile ? 45 : 70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: isMobile ? 1.5 : 3.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Galería Principal',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: MediaQuery.of(context).size.width < 600 ? 32 : 48
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Bienvenido al centro de administración',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: const Color(0xFF5D4037).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const ProductManagementScreen()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
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
                                  fontSize: 14,
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
