// 駒の種類を定義
enum PieceType {
  king,
  queen,
  rook,
  bishop,
  gold,
  silver,
  knight,
  lance,
  pawn,
  dragon,
  horse,
  promKnight,
  promLance,
  promPawn,
  promSilver,
}

// 駒の色を定義
enum PieceColor { black, white }

// 駒の情報を管理するクラス
class Piece {
  final PieceType type; // 駒の種類
  final PieceColor color; // 駒の色
  bool isPromoted; // 成り駒かどうか

  Piece({required this.type, required this.color, this.isPromoted = false});

  String get imagePath {
    final colorStr = color == PieceColor.black ? 'black' : 'white';
    final typeStr = _getTypeString(type, isPromoted);
    final path = 'assets/images/pieces/${colorStr}_$typeStr.png';
    return path;
  }

  String _getTypeString(PieceType type, bool isPromoted) {
    // 成り駒の場合の処理
    if (isPromoted) {
      switch (type) {
        case PieceType.pawn:
          return 'prom_pawn'; // と金
        case PieceType.lance:
          return 'prom_lance'; // 成香
        case PieceType.knight:
          return 'prom_knight'; // 成桂
        case PieceType.silver:
          return 'prom_silver'; // 成銀
        case PieceType.rook:
          return 'dragon'; // 龍
        case PieceType.bishop:
          return 'horse'; // 馬
        default:
          return _getTypeString(type, false); // 成れない駒は通常の画像
      }
    }

    // 通常の駒の場合
    switch (type) {
      case PieceType.king:
        return 'king';
      case PieceType.queen:
        return 'king2';
      case PieceType.rook:
        return 'rook';
      case PieceType.bishop:
        return 'bishop';
      case PieceType.gold:
        return 'gold';
      case PieceType.silver:
        return 'silver';
      case PieceType.knight:
        return 'knight';
      case PieceType.lance:
        return 'lance';
      case PieceType.pawn:
        return 'pawn';
      case PieceType.dragon:
        return 'dragon';
      case PieceType.horse:
        return 'horse';
      case PieceType.promKnight:
        return 'prom_knight';
      case PieceType.promLance:
        return 'prom_lance';
      case PieceType.promPawn:
        return 'prom_pawn';
      case PieceType.promSilver:
        return 'prom_silver';
    }
  }
}
