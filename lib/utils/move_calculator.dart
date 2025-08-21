import '../models/piece.dart';
import '../models/board.dart';

class MoveCalculator {
  static List<List<bool>> getKingMovableMap(Board board, int row, int col) {
    final List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);
    if (piece != null) {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) continue;
          int nr = row + dr;
          int nc = col + dc;
          if (nr >= 0 &&
              nr < 9 &&
              nc >= 0 &&
              nc < 9 &&
              (board.getPiece(nr, nc) == null ||
                  board.getPiece(nr, nc)?.color != piece.color)) {
            map[nr][nc] = true;
          }
        }
      }
      return map;
    }
    return List.generate(9, (_) => List.filled(9, false));
  }

  static List<List<bool>> getPawnMovableMap(Board board, int row, int col) {
    final List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);

    if (piece != null) {
      if (piece.isPromoted) {
        // Gold
        return getGoldMovableMap(board, row, col);
      }
      // Pawn
      int direction = (piece.color == PieceColor.black) ? -1 : 1; // 黒は上向き、白は下向き
      int nr = row + direction;
      int nc = col;
      if (nr >= 0 &&
          nr < 9 &&
          nc >= 0 &&
          nc < 9 &&
          (board.getPiece(nr, nc) == null ||
              board.getPiece(nr, nc)?.color != piece.color)) {
        map[nr][nc] = true;
      }
    }
    return map;
  }

  static List<List<bool>> getGoldMovableMap(Board board, int row, int col) {
    final List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);

    if (piece != null) {
      int direction = (piece.color == PieceColor.black) ? -1 : 1; // 黒は上向き、白は下向き
      int nr = row + direction;
      int nc = col;

      if (nr >= 0 && nr < 9) {
        if (nc - 1 >= 0) {
          if (board.getPiece(nr, nc - 1) == null || // コマがない時
              (board.getPiece(nr, nc - 1) != null &&
                  board.getPiece(nr, nc - 1)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc - 1] = true;
          }
        }
        if (nc < 9) {
          if (board.getPiece(nr, nc) == null || // コマがない時
              (board.getPiece(nr, nc) != null &&
                  board.getPiece(nr, nc)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc] = true;
          }
        }
        if (nc + 1 < 9) {
          if (board.getPiece(nr, nc + 1) == null || // コマがない時
              (board.getPiece(nr, nc + 1) != null &&
                  board.getPiece(nr, nc + 1)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc + 1] = true;
          }
        }
      }
      // 後ろに動く
      nr = row - direction;
      if (nr >= 0 && nr < 9) {
        if (board.getPiece(nr, nc) == null || // コマがない時
            (board.getPiece(nr, nc) != null &&
                board.getPiece(nr, nc)?.color != piece.color) // コマがある時、かつ敵の駒のとき
            ) {
          map[nr][nc] = true;
        }
      }
      // 横に動く
      nr = row;
      if (nc - 1 >= 0) {
        if (board.getPiece(nr, nc - 1) == null || // コマがない時
            (board.getPiece(nr, nc - 1) != null &&
                board.getPiece(nr, nc - 1)?.color !=
                    piece.color) // コマがある時、かつ敵の駒のとき
            ) {
          map[nr][nc - 1] = true;
        }
      }
      if (nc + 1 < 9) {
        if (board.getPiece(nr, nc + 1) == null || // コマがない時
            (board.getPiece(nr, nc + 1) != null &&
                board.getPiece(nr, nc + 1)?.color !=
                    piece.color) // コマがある時、かつ敵の駒のとき
            ) {
          map[nr][nc + 1] = true;
        }
      }
    }
    return map;
  }

  static List<List<bool>> getSilverMovableMap(Board board, int row, int col) {
    final List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);

    if (piece != null) {
      if (piece.isPromoted) {
        // Gold
        return getGoldMovableMap(board, row, col);
      }
      // Silver
      int direction = (piece.color == PieceColor.black) ? -1 : 1; // 黒は上向き、白は下向き
      int nr = row + direction;
      int nc = col;

      if (nr >= 0 && nr < 9) {
        if (nc - 1 >= 0) {
          if (board.getPiece(nr, nc - 1) == null || // コマがない時
              (board.getPiece(nr, nc - 1) != null &&
                  board.getPiece(nr, nc - 1)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc - 1] = true;
          }
        }
        if (nc < 9) {
          if (board.getPiece(nr, nc) == null || // コマがない時
              (board.getPiece(nr, nc) != null &&
                  board.getPiece(nr, nc)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc] = true;
          }
        }
        if (nc + 1 < 9) {
          if (board.getPiece(nr, nc + 1) == null || // コマがない時
              (board.getPiece(nr, nc + 1) != null &&
                  board.getPiece(nr, nc + 1)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc + 1] = true;
          }
        }
      }
      // 後ろに動く
      nr = row - direction;
      nc = col + 1;
      if (nr >= 0 && nr < 9 && nc >= 0 && nc < 9) {
        if (board.getPiece(nr, nc) == null || // コマがない時
            (board.getPiece(nr, nc) != null &&
                board.getPiece(nr, nc)?.color != piece.color) // コマがある時、かつ敵の駒のとき
            ) {
          map[nr][nc] = true;
        }
      }

      nr = row - direction;
      nc = col - 1;
      if (nr >= 0 && nr < 9 && nc >= 0 && nc < 9) {
        if (board.getPiece(nr, nc) == null || // コマがない時
            (board.getPiece(nr, nc) != null &&
                board.getPiece(nr, nc)?.color != piece.color) // コマがある時、かつ敵の駒のとき
            ) {
          map[nr][nc] = true;
        }
      }
    }
    return map;
  }

  static List<List<bool>> getKnightMovableMap(Board board, int row, int col) {
    final List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);

    if (piece != null) {
      if (piece.isPromoted) {
        // Gold
        return getGoldMovableMap(board, row, col);
      }
      // Knight
      int direction = (piece.color == PieceColor.black) ? -2 : 2; // 黒は上向き、白は下向き
      int nr = row + direction;
      int nc = col;

      if (nr >= 0 && nr < 9) {
        if (nc - 1 >= 0) {
          if (board.getPiece(nr, nc - 1) == null || // コマがない時
              (board.getPiece(nr, nc - 1) != null &&
                  board.getPiece(nr, nc - 1)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc - 1] = true;
          }
        }

        if (nc + 1 < 9) {
          if (board.getPiece(nr, nc + 1) == null || // コマがない時
              (board.getPiece(nr, nc + 1) != null &&
                  board.getPiece(nr, nc + 1)?.color !=
                      piece.color) // コマがある時、かつ敵の駒のとき
              ) {
            map[nr][nc + 1] = true;
          }
        }
      }
    }
    return map;
  }

  static List<List<bool>> getLanceMovableMap(Board board, int row, int col) {
    final List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);

    if (piece != null) {
      if (piece.isPromoted) {
        // Gold
        return getGoldMovableMap(board, row, col);
      }
      // Lance
      int direction = (piece.color == PieceColor.black) ? -1 : 1; // 黒は上向き、白は下向き
      int nr = row + direction;
      int nc = col;
      bool before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nr = nr + direction;
      }
    }

    return map;
  }

  static List<List<bool>> getRookMovableMap(Board board, int row, int col) {
    List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);

    if (piece != null) {
      if (piece.isPromoted) {
        // King
        map = getKingMovableMap(board, row, col);
      }
      // Rook
      int direction = (piece.color == PieceColor.black) ? -1 : 1; // 黒は上向き、白は下向き
      int nr = row;
      int nc = col;

      // 前に動く
      nr = row + direction;
      nc = col;
      bool before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nr = nr + direction;
      }

      // 後ろに動く
      nr = row - direction;
      nc = col;
      before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nr = nr - direction;
      }

      // 左に動く
      nc = col - 1;
      nr = row;
      before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nc = nc - 1;
      }

      // 右に動く
      nc = col + 1;
      nr = row;
      before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nc = nc + 1;
      }
    }

    return map;
  }

  static List<List<bool>> getBishopMovableMap(Board board, int row, int col) {
    List<List<bool>> map = List.generate(9, (_) => List.filled(9, false));
    final piece = board.getPiece(row, col);

    if (piece != null) {
      if (piece.isPromoted) {
        // King
        map = getKingMovableMap(board, row, col);
      }
      // Bishop
      int nr = row;
      int nc = col;

      // 右前に動く
      nr = row + 1;
      nc = col + 1;
      bool before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nr = nr + 1;
        nc = nc + 1;
      }

      // 右後ろに動く
      nr = row - 1;
      nc = col + 1;
      before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nr = nr - 1;
        nc = nc + 1;
      }

      // 左前に動く
      nr = row + 1;
      nc = col - 1;
      before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nr >= 0 &&
            nr < 9 &&
            nc >= 0 &&
            nc < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nr = nr + 1;
        nc = nc - 1;
      }

      // 左後ろに動く
      nr = row - 1;
      nc = col - 1;
      before = true;
      for (int i = 1; i < 9 && before; i++) {
        if (nc >= 0 &&
            nc < 9 &&
            nr >= 0 &&
            nr < 9 &&
            (board.getPiece(nr, nc) == null ||
                board.getPiece(nr, nc)?.color != piece.color)) {
          map[nr][nc] = true;
          if (board.getPiece(nr, nc) != null &&
              board.getPiece(nr, nc)?.color != piece.color) {
            before = false;
          }
        } else {
          before = false;
        }
        nr = nr - 1;
        nc = nc - 1;
      }
    }

    return map;
  }

  static List<List<bool>> getMovableMap(Board board, int row, int col) {
    final piece = board.getPiece(row, col);
    if (piece == null) return List.generate(9, (_) => List.filled(9, false));

    print('=== 駒の移動計算 ===');
    print('位置: ($row, $col)');
    print('駒の種類: ${piece.type}');
    print('駒の色: ${piece.color}');

    switch (piece.type) {
      case PieceType.king:
        return getKingMovableMap(board, row, col);
      case PieceType.queen:
        return getKingMovableMap(board, row, col);
      case PieceType.pawn:
        return getPawnMovableMap(board, row, col);
      case PieceType.gold:
        return getGoldMovableMap(board, row, col);
      case PieceType.silver:
        return getSilverMovableMap(board, row, col);
      case PieceType.knight:
        return getKnightMovableMap(board, row, col);
      case PieceType.lance:
        return getLanceMovableMap(board, row, col);
      case PieceType.rook:
        return getRookMovableMap(board, row, col);
      case PieceType.bishop:
        return getBishopMovableMap(board, row, col);
      default:
        return List.generate(9, (_) => List.filled(9, false));
    }
  }
}
