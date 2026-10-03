import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String defaultBaseUrl = 'http://127.0.0.1:8000/api/v1';
  static const String serverRootUrl = 'http://127.0.0.1:8000';
  final String baseUrl;
  String? authToken;

  ApiService({this.baseUrl = defaultBaseUrl});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  // 0. Vérification de la santé du serveur
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$serverRootUrl/health'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[ApiService] Serveur indisponible: $e');
      return false;
    }
  }

  // 1. Authentification
  Future<Map<String, dynamic>> login(
    String identifier,
    String password, {
    String role = 'ADOLESCENT',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'identifiant_ou_email': identifier.trim(),
              'mot_de_passe_ou_otp': password.trim(),
              'role': role,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        authToken = data['access_token'];
        return data;
      } else {
        String errorMsg = 'Erreur de connexion (${response.statusCode})';
        try {
          final errBody = jsonDecode(response.body);
          if (errBody['detail'] != null) {
            errorMsg = errBody['detail'];
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('Serveur backend non joignable sur $serverRootUrl ($e)');
    }
  }

  // 2. Inscription multicanale
  Future<Map<String, dynamic>> registerAdolescent(Map<String, dynamic> adolescentData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/registrations/register'),
            headers: _headers,
            body: jsonEncode(adolescentData),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        String errorMsg = 'Erreur d\'inscription (${response.statusCode})';
        try {
          final errBody = jsonDecode(response.body);
          if (errBody['detail'] != null) {
            errorMsg = errBody['detail'].toString();
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('Impossible d\'enregistrer sur le backend ($e)');
    }
  }

  // 3. Notifications de l'encadreur
  Future<List<dynamic>> getEncadreurNotifications() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/notifications'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint('[ApiService] Erreur notifications: $e');
      return [];
    }
  }

  // 4. Validation / Confirmation d'une inscription par l'encadreur
  Future<Map<String, dynamic>> confirmRegistration(String adolescentId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registrations/confirm/$adolescentId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de confirmation : ${response.body}');
    }
  }

  Future<Map<String, dynamic>> validateRegistration(
    String adolescentId,
    String statut, {
    String? commentaire,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registrations/$adolescentId/validate'),
      headers: _headers,
      body: jsonEncode({
        'statut': statut,
        'commentaire_encadreur': commentaire,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de validation : ${response.body}');
    }
  }

  // Consentement parental
  Future<Map<String, dynamic>> updateParentalConsent(
    String adolescentId,
    String statutConsentement, {
    String mode = 'SMS / WhatsApp RapidPro',
  }) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/registrations/$adolescentId/consent?statut_consentement=$statutConsentement&mode=${Uri.encodeComponent(mode)}'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur consentement : ${response.body}');
    }
  }

  // 5. Statistiques désagrégées
  Future<Map<String, dynamic>> getDisaggregatedStats() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reports/disaggregated'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur statistiques : ${response.body}');
      }
    } catch (e) {
      debugPrint('[ApiService] Erreur getDisaggregatedStats: $e');
      rethrow;
    }
  }

  // 6. Signalement d'incident de sauvegarde (SLA 24h)
  Future<Map<String, dynamic>> reportSafeguardIncident(Map<String, dynamic> incidentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/safeguard/report'),
      headers: _headers,
      body: jsonEncode(incidentData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de signalement : ${response.body}');
    }
  }

  // 7. Simulation USSD GSM
  Future<Map<String, dynamic>> simulateUssdSession(Map<String, dynamic> ussdPayload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rapidpro/ussd/session'),
      headers: _headers,
      body: jsonEncode(ussdPayload),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur USSD : ${response.body}');
    }
  }

  // 8. Récupération des listes dynamiques (Adolescents, Clubs, Encadreurs)
  Future<List<dynamic>> getAdolescents() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/registrations'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint('[ApiService] getAdolescents: $e');
      return [];
    }
  }

  Future<List<dynamic>> getPendingRegistrations() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/registrations/pending'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getClubs() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/registrations/meta/clubs'), headers: _headers)
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getEncadreurs() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/registrations/meta/encadreurs'), headers: _headers)
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 9. Reportages Ponabana (Soumission, N1, N2)
  Future<List<dynamic>> getReportages() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/ponabana/reportages'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> submitReportage(Map<String, dynamic> reportageData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ponabana/reportages'),
      headers: _headers,
      body: jsonEncode(reportageData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur soumission reportage: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> reviewReportageN1(String reportageId, String avis, {bool approuve = true}) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/ponabana/reportages/$reportageId/review-n1?avis_encadreur=${Uri.encodeComponent(avis)}&approuve=$approuve'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur modération N1: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> publishReportageN2(String reportageId, String relecture) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/ponabana/reportages/$reportageId/publish-n2?relecture_ponabana=${Uri.encodeComponent(relecture)}'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur publication N2: ${response.body}');
    }
  }

  // 10. Incidents de Sauvegarde
  Future<List<dynamic>> getSafeguardIncidents() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/safeguard/incidents'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 11. Académie & Quiz
  Future<Map<String, dynamic>> submitQuiz(String moduleId, List<int> reponses) async {
    final response = await http.post(
      Uri.parse('$baseUrl/academy/submit-quiz'),
      headers: _headers,
      body: jsonEncode({
        'module_id': moduleId,
        'reponses': reponses,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur quiz: ${response.body}');
    }
  }

  // 12. Diffusion RapidPro
  Future<Map<String, dynamic>> sendRapidProBroadcast(String titre, String message, {String? canal, String? cible}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rapidpro/send-broadcast'),
      headers: _headers,
      body: jsonEncode({
        'titre': titre,
        'message': message,
        'canal': canal ?? 'WHATSAPP',
        'cible': cible ?? 'TOUS',
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur broadcast RapidPro: ${response.body}');
    }
  }

  // 13. Audit logs (Admin)
  Future<List<dynamic>> getAuditLogs() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/auth/audit-logs'), headers: _headers)
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
