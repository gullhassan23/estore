import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class texTsTyle {
  static TextStyle buildTextField(
    Color color,
    double size,
  ) {
    return GoogleFonts.montserrat(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle buildTextsmallField(
    Color color,
    double size,
  ) {
    return GoogleFonts.federo(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  }
}
