import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showArtisticWarning(String message) {
    showDialog(
      context: context,
      builder: (context) => _ShakingDialog(message: message),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == 'admin1@gmail.com' && _passwordController.text == 'admin2') {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      } else {
        _showArtisticWarning('Las credenciales ingresadas son incorrectas.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://raw.githubusercontent.com/GarciaGalaviz0808/imgs/refs/heads/main/logo%20(1).png',
                    height: 180,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ADMINISTRADORES',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E2723),
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestión de Tienda',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: const Color(0xFF8D6E63),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo Administrativo',
                      prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF5D4037)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Correo requerido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF5D4037)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingrese Contraseña';
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('ACCEDER AL TALLER'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget personalizado para el diálogo con efecto de sacudida (Vibración visual)
class _ShakingDialog extends StatefulWidget {
  final String message;
  const _ShakingDialog({required this.message});

  @override
  State<_ShakingDialog> createState() => _ShakingDialogState();
}

class _ShakingDialogState extends State<_ShakingDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Definición de la sacudida (4 movimientos de lado a lado)
    _offsetAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 40), // Evita que abarque todo el ancho
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: const Color(0xFFF2E6DA),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400), // Ancho aumentado a 400px según lo solicitado
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animación Lottie de Advertencia Roja
                  SizedBox(
                    height: 90,
                    child: Lottie.network(
                      'https://lottie.host/802613d5-e2f6-490b-a621-e8e63b499159/eQ5K1yK7p3.json',
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.warning_amber_rounded,
                        size: 70,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¡ACCESO DENEGADO!',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFB71C1C),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: const Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C), // Rojo llamativo para errores
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('INTENTAR DE NUEVO', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
