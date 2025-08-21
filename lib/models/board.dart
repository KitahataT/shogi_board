import 'piece.dart';
import 'dart:math';

class Board {
  // 9x9の盤面を管理（nullは空マス）
  late List<List<Piece?>> board;

  // 持ち駒を管理
  List<Piece> blackCapturedPieces = [];
  List<Piece> whiteCapturedPieces = [];

  // 先手後手を管理
  PieceColor currentPlayer = PieceColor.black; // デフォルトは黒が先手

  // プレイヤーの名前を管理
  String blackPlayerName = '先手';
  String whitePlayerName = '後手';

  Board() {
    _initializeBoard();
    _randomizeFirstPlayer();
  }

  void _initializeBoard() {
    board = List.generate(9, (row) => List.generate(9, (col) => null));
    _setupInitialPosition();
  }

  void _setupInitialPosition() {
    // 黒側（下側）の配置
    board[8][0] = Piece(
      type: PieceType.lance,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][1] = Piece(
      type: PieceType.knight,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][2] = Piece(
      type: PieceType.silver,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][3] = Piece(
      type: PieceType.gold,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][4] = Piece(
      type: PieceType.king,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][5] = Piece(
      type: PieceType.gold,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][6] = Piece(
      type: PieceType.silver,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][7] = Piece(
      type: PieceType.knight,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[8][8] = Piece(
      type: PieceType.lance,
      color: PieceColor.black,
      isPromoted: false,
    );

    // 黒側の飛車と角
    board[7][1] = Piece(
      type: PieceType.bishop,
      color: PieceColor.black,
      isPromoted: false,
    );
    board[7][7] = Piece(
      type: PieceType.rook,
      color: PieceColor.black,
      isPromoted: false,
    );

    // 黒側の歩兵
    for (int i = 0; i < 9; i++) {
      board[6][i] = Piece(
        type: PieceType.pawn,
        color: PieceColor.black,
        isPromoted: false,
      );
    }

    // 白側（上側）の配置
    board[0][0] = Piece(
      type: PieceType.lance,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][1] = Piece(
      type: PieceType.knight,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][2] = Piece(
      type: PieceType.silver,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][3] = Piece(
      type: PieceType.gold,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][4] = Piece(
      type: PieceType.queen,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][5] = Piece(
      type: PieceType.gold,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][6] = Piece(
      type: PieceType.silver,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][7] = Piece(
      type: PieceType.knight,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[0][8] = Piece(
      type: PieceType.lance,
      color: PieceColor.white,
      isPromoted: false,
    );

    // 白側の飛車と角
    board[1][1] = Piece(
      type: PieceType.rook,
      color: PieceColor.white,
      isPromoted: false,
    );
    board[1][7] = Piece(
      type: PieceType.bishop,
      color: PieceColor.white,
      isPromoted: false,
    );

    // 白側の歩兵
    for (int i = 0; i < 9; i++) {
      board[2][i] = Piece(
        type: PieceType.pawn,
        color: PieceColor.white,
        isPromoted: false,
      );
    }
  }

  // 駒を移動（駒を取る処理を含む）
  Piece? movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    // 移動先に駒がある場合は、その駒を取る
    final capturedPiece = board[toRow][toCol];

    if (capturedPiece != null) {
      // 取った駒を成り駒から通常の駒に戻す
      final normalPiece = Piece(
        type: _getNormalPieceType(capturedPiece.type),
        color: capturedPiece.color,
        isPromoted: false,
      );

      // 取った駒を適切な持ち駒リストに追加
      if (capturedPiece.color == PieceColor.black) {
        whiteCapturedPieces.add(normalPiece);
      } else {
        blackCapturedPieces.add(normalPiece);
      }
      print('黒の持ち駒リスト: ${blackCapturedPieces.map((e) => e.type).toList()}');
      print('白の持ち駒リスト: ${whiteCapturedPieces.map((e) => e.type).toList()}');
    }

    // 駒を移動
    board[toRow][toCol] = board[fromRow][fromCol];
    board[fromRow][fromCol] = null;

    return capturedPiece;
  }

  // 成り駒を通常の駒の種類に戻す
  PieceType _getNormalPieceType(PieceType promotedType) {
    switch (promotedType) {
      case PieceType.pawn:
        return PieceType.pawn; // 歩兵は成っても歩兵
      case PieceType.lance:
        return PieceType.lance; // 香車は成っても香車
      case PieceType.knight:
        return PieceType.knight; // 桂馬は成っても桂馬
      case PieceType.silver:
        return PieceType.silver; // 銀は成っても銀
      case PieceType.rook:
        return PieceType.rook; // 飛車は成っても飛車
      case PieceType.bishop:
        return PieceType.bishop; // 角は成っても角
      default:
        return promotedType; // その他の駒はそのまま
    }
  }

  // 持ち駒を取得
  List<Piece> getCapturedPieces(PieceColor color) {
    return color == PieceColor.black
        ? blackCapturedPieces
        : whiteCapturedPieces;
  }

  // 持ち駒を打つ
  void dropPiece(Piece piece, Piece capturedPiece, int toRow, int toCol) {
    if (board[toRow][toCol] == null) {
      board[toRow][toCol] = piece;

      // 持ち駒リストから削除
      if (piece.color == PieceColor.black) {
        blackCapturedPieces.remove(capturedPiece);
      } else {
        whiteCapturedPieces.remove(capturedPiece);
      }
    }
  }

  // 指定位置の駒を取得
  Piece? getPiece(int row, int col) {
    if (row >= 0 && row < 9 && col >= 0 && col < 9) {
      return board[row][col];
    }
    return null;
  }

  // 指定位置に駒を設置
  void setPiece(int row, int col, Piece? piece) {
    if (row >= 0 && row < 9 && col >= 0 && col < 9) {
      board[row][col] = piece;
    }
  }

  // 玉/王が取られたかチェック
  bool isKingCaptured(PieceColor color) {
    // 盤面上に玉/王が存在するかチェック
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        final piece = board[row][col];
        if (piece != null &&
            piece.color == color &&
            (piece.type == PieceType.king || piece.type == PieceType.queen)) {
          return false; // 玉/王が存在する
        }
      }
    }
    return true; // 玉/王が存在しない（取られた）
  }

  // 二歩のチェック
  bool isPawnDouble(PieceColor color, int toCol) {
    // 同じ列に歩兵が存在するかチェック
    for (int row = 0; row < 9; row++) {
      final piece = board[row][toCol];
      if (piece != null &&
          piece.color == color &&
          (piece.type == PieceType.pawn && piece.isPromoted == false)) {
        return true; // 歩兵が存在する
      }
    }
    return false; // 歩兵が存在しない
  }

  // ゲーム終了判定
  bool isGameOver() {
    return isKingCaptured(PieceColor.black) || isKingCaptured(PieceColor.white);
  }

  // 勝者を取得
  PieceColor? getWinner() {
    if (isKingCaptured(PieceColor.black)) {
      return PieceColor.white; // 白の勝ち
    } else if (isKingCaptured(PieceColor.white)) {
      return PieceColor.black; // 黒の勝ち
    }
    return null; // まだゲーム終了していない
  }

  // ランダムに先手後手を決める
  void _randomizeFirstPlayer() {
    final random = Random();
    currentPlayer = random.nextBool() ? PieceColor.black : PieceColor.white;

    // 先手後手の名前を設定
    if (currentPlayer == PieceColor.black) {
      blackPlayerName = '先手';
      whitePlayerName = '後手';
    } else {
      blackPlayerName = '後手';
      whitePlayerName = '先手';
    }
  }

  // 先手の名前を取得
  String getFirstPlayerName() {
    return blackPlayerName == '先手' ? blackPlayerName : whitePlayerName;
  }

  // 後手の名前を取得
  String getSecondPlayerName() {
    return blackPlayerName == '後手' ? blackPlayerName : whitePlayerName;
  }

  // 現在の手番の名前を取得
  String getCurrentPlayerName() {
    return currentPlayer == PieceColor.black
        ? blackPlayerName
        : whitePlayerName;
  }

  // 手番を交代
  void switchPlayer() {
    currentPlayer = currentPlayer == PieceColor.black
        ? PieceColor.white
        : PieceColor.black;
  }

  // 現在の手番を取得
  PieceColor getCurrentPlayer() {
    return currentPlayer;
  }
}
