import '../models/club.dart';
import '../seed/seed_data.dart';

/// Annuaire des clubs d'enfants reporters par province.
class ClubRepository {
  List<Club> get clubs => SeedData.clubs;

  List<Club> parProvince(String province) =>
      SeedData.clubs.where((c) => c.province == province).toList();

  Set<String> get provinces {
    final s = <String>{};
    for (final c in SeedData.clubs) {
      s.add(c.province);
    }
    return s;
  }
}
