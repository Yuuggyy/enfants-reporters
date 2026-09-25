import 'package:equatable/equatable.dart';

/// Statut éditorial d'un article dans le circuit de modération.
enum ArticleStatut { brouillon, soumis, valide, publie }

/// Brouillon d'article guidé au format 5W+H (Qui, Quoi, Où, Quand, Pourquoi).
class ArticleDraft extends Equatable {
  final String id;
  final String titre;
  final String qui;
  final String quoi;
  final String ou;
  final String quand;
  final String pourquoi;
  final String citation;
  final ArticleStatut statut;
  final DateTime dateCreation;

  const ArticleDraft({
    required this.id,
    required this.titre,
    required this.qui,
    required this.quoi,
    required this.ou,
    required this.quand,
    required this.pourquoi,
    required this.citation,
    required this.statut,
    required this.dateCreation,
  });

  ArticleDraft copyWith({ArticleStatut? statut}) => ArticleDraft(
        id: id,
        titre: titre,
        qui: qui,
        quoi: quoi,
        ou: ou,
        quand: quand,
        pourquoi: pourquoi,
        citation: citation,
        statut: statut ?? this.statut,
        dateCreation: dateCreation,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titre': titre,
        'qui': qui,
        'quoi': quoi,
        'ou': ou,
        'quand': quand,
        'pourquoi': pourquoi,
        'citation': citation,
        'statut': statut.index,
        'dateCreation': dateCreation.toIso8601String(),
      };

  factory ArticleDraft.fromJson(Map<String, dynamic> json) => ArticleDraft(
        id: json['id'] as String,
        titre: json['titre'] as String,
        qui: json['qui'] as String,
        quoi: json['quoi'] as String,
        ou: json['ou'] as String,
        quand: json['quand'] as String,
        pourquoi: json['pourquoi'] as String,
        citation: json['citation'] as String,
        statut: ArticleStatut.values[json['statut'] as int],
        dateCreation: DateTime.parse(json['dateCreation'] as String),
      );

  @override
  List<Object?> get props => [id, statut];
}
