import 'package:flutter/material.dart';
import '../models/board.dart';
import '../models/piece.dart';
import '../utils/move_calculator.dart';
import 'dart:math';

// 駒のグループを表すクラス（ファイルの最上部に移動）
class _PieceGroup {
  final List<Piece> pieces;
  _PieceGroup(this.pieces);
}

class ShogiBoard extends StatefulWidget {
  const ShogiBoard({super.key});

  @override
  State<ShogiBoard> createState() => _ShogiBoardState();
}

class _ShogiBoardState extends State<ShogiBoard> {
  late Board board;

  // 駒の選択状態と移動候補
  int? selectedRow;
  int? selectedCol;
  List<List<bool>>? movableMap;

  // 持ち駒の選択状態を追加
  Piece? selectedCapturedPiece;
  PieceColor? selectedCapturedPieceColor;

  @override
  void initState() {
    super.initState();
    board = Board();
    selectedRow = null;
    selectedCol = null;
    movableMap = null;
    selectedCapturedPiece = null;
    selectedCapturedPieceColor = null;
  }

  // 成り駒の選択ダイアログを表示
  Future<bool?> _showPromotionDialog(
    Piece piece,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
  ) async {
    // 成れる駒かどうかチェック
    if (!_canPromote(piece, fromRow, fromCol, toRow, toCol)) {
      return false; // 成れない場合は成らない
    }

    // 移動先に玉や王がある場合は成らない
    final targetPiece = board.getPiece(toRow, toCol);
    if (targetPiece != null &&
        (targetPiece.type == PieceType.king ||
            targetPiece.type == PieceType.queen)) {
      return false; // 玉や王を取る場合は成らない
    }

    // 強制的に成るかどうかのチェック
    if (_isForcedPromotion(piece, toRow, toCol)) {
      return true; // 成る
    } else {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('成りますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('成る'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('成らない'),
              ),
            ],
          );
        },
      );
    }
  }

  // 駒が成れるかどうかを判定
  bool _canPromote(
    Piece piece,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
  ) {
    // 成れる駒の種類
    final promotablePieces = [
      PieceType.pawn, // 歩兵
      PieceType.lance, // 香車
      PieceType.knight, // 桂馬
      PieceType.silver, // 銀
      PieceType.rook, // 飛車
      PieceType.bishop, // 角
    ];

    // 成れる駒かチェック
    if (!promotablePieces.contains(piece.type)) {
      return false;
    }
    // 成り駒の場合は成れない
    if (piece.isPromoted) {
      return false;
    }

    // 敵陣に入った場合成れる
    if (piece.color == PieceColor.black && toRow <= 2) return true;
    if (piece.color == PieceColor.white && toRow >= 6) return true;
    // 敵陣から移動する場合成れる
    if (piece.color == PieceColor.black && fromRow <= 2) return true;
    if (piece.color == PieceColor.white && fromRow >= 6) return true;

    return false;
  }

  // 強制的に成るかどうかを判定
  bool _isForcedPromotion(Piece piece, int toRow, int toCol) {
    // 強制的に成る駒の種類
    final promotablePieces = [
      PieceType.pawn, // 歩兵
      PieceType.lance, // 香車
      PieceType.knight, // 桂馬
    ];

    // 成れる駒かチェック
    if (!promotablePieces.contains(piece.type)) {
      return false;
    }
    // 成り駒の場合は成れない
    if (piece.isPromoted) {
      return false;
    }

    // 歩兵と香車の場合は1段目に入ったら成る
    // 桂馬の場合は2段目に入ったら成る
    if (piece.type == PieceType.pawn || piece.type == PieceType.lance) {
      if (piece.color == PieceColor.black && toRow <= 0) return true;
      if (piece.color == PieceColor.white && toRow >= 8) return true;
    }
    if (piece.type == PieceType.knight) {
      if (piece.color == PieceColor.black && toRow <= 1) return true;
      if (piece.color == PieceColor.white && toRow >= 7) return true;
    }

    return false;
  }

  // 持ち駒を打てるかどうかを判定
  bool _canDropPiece(Piece piece, int toRow, int toCol) {
    print(
      '_canDropPiece: ${piece.type} (${piece.color}) を ($toRow, $toCol) に打てるかチェック',
    );

    // 歩兵、香車、桂馬の制限をチェック
    if (piece.type == PieceType.pawn || piece.type == PieceType.lance) {
      // 歩兵と香車は1段目には打てない
      if (piece.color == PieceColor.black && toRow <= 0) {
        print('歩兵/香車を黒側1段目に打とうとしているため、false');
        return false;
      }
      if (piece.color == PieceColor.white && toRow >= 8) {
        print('歩兵/香車を白側9段目に打とうとしているため、false');
        return false;
      }
    }
    if (piece.type == PieceType.knight) {
      // 桂馬は2段目以上には打てない
      if (piece.color == PieceColor.black && toRow <= 1) {
        print('桂馬を黒側2段目以上に打とうとしているため、false');
        return false;
      }
      if (piece.color == PieceColor.white && toRow >= 7) {
        print('桂馬を白側8段目以上に打とうとしているため、false');
        return false;
      }
    }

    print('制限に引っかからないため、true');
    return true;
  }

  void _onCellTap(int row, int col) async {
    // 持ち駒が選択されている場合は、盤面に打つ
    if (selectedCapturedPiece != null && selectedCapturedPieceColor != null) {
      // 手番チェック：持ち駒を打つのは現在の手番の人だけ
      if (selectedCapturedPieceColor != board.getCurrentPlayer()) {
        _showNotYourTurnDialog();
        return;
      }

      _onBoardTapForDrop(row, col);
      return;
    }

    final piece = board.getPiece(row, col);

    // 移動候補マスをタップした場合、駒を移動
    if (selectedRow != null &&
        selectedCol != null &&
        movableMap != null &&
        movableMap![row][col]) {
      final movingPiece = board.getPiece(selectedRow!, selectedCol!);
      if (movingPiece != null) {
        // 手番チェック：駒を動かすのは現在の手番の人だけ
        if (movingPiece.color != board.getCurrentPlayer()) {
          _showNotYourTurnDialog();
          return;
        }

        // 成り駒の選択
        final shouldPromote = await _showPromotionDialog(
          movingPiece,
          selectedRow!,
          selectedCol!,
          row,
          col,
        );

        setState(() {
          // 成り駒の処理（移動前に設定）
          if (shouldPromote == true) {
            movingPiece.isPromoted = true;
          }

          // 駒を移動（駒を取る処理を含む）
          final capturedPiece = board.movePiece(
            selectedRow!,
            selectedCol!,
            row,
            col,
          );

          // 取った駒がある場合はログ出力（デバッグ用）
          if (capturedPiece != null) {
            print('駒を取った: ${capturedPiece.type}');
          }

          selectedRow = null;
          selectedCol = null;
          movableMap = null;
          selectedCapturedPiece = null;
          selectedCapturedPieceColor = null;

          // 手番を交代
          _switchTurn();

          // ゲーム終了チェック
          _checkGameOver();
        });
      }
      return;
    }

    // 駒を選択
    if (piece != null) {
      // 手番チェック：駒を選択するのは現在の手番の人だけ
      if (piece.color != board.getCurrentPlayer()) {
        _showNotYourTurnDialog();
        return;
      }

      setState(() {
        selectedRow = row;
        selectedCol = col;
        movableMap = MoveCalculator.getMovableMap(board, row, col);
      });
      return;
    }

    // それ以外は選択解除（持ち駒の選択も含む）
    setState(() {
      selectedRow = null;
      selectedCol = null;
      movableMap = null;
      selectedCapturedPiece = null;
      selectedCapturedPieceColor = null;
    });
  }

  // 持ち駒を打つ処理を追加
  void _onCapturedPieceTap(Piece piece, PieceColor color) {
    // 手番チェック：持ち駒を選択するのは現在の手番の人だけ
    if (color != board.getCurrentPlayer()) {
      _showNotYourTurnDialog();
      return;
    }

    print('持ち駒タップ: ${piece.type}, ${color}');
    setState(() {
      // 同じ持ち駒が既に選択されている場合は選択をキャンセル
      if (selectedCapturedPiece == piece &&
          selectedCapturedPieceColor == color) {
        selectedCapturedPiece = null;
        selectedCapturedPieceColor = null;
      } else {
        // 持ち駒を選択状態にする
        selectedCapturedPiece = piece;
        selectedCapturedPieceColor = color;
      }
      selectedRow = null;
      selectedCol = null;
      movableMap = null;
    });
  }

  // 持ち駒を盤面に打つ処理
  void _onBoardTapForDrop(int row, int col) {
    if (selectedCapturedPiece != null && selectedCapturedPieceColor != null) {
      // 移動先が空いているかチェック
      if (board.getPiece(row, col) != null ||
          (selectedCapturedPiece!.type == PieceType.pawn &&
              board.isPawnDouble(selectedCapturedPieceColor!, col))) {
        // 駒を打てない場合のダイアログ表示
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('そこには駒を打つことができません'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // 持ち駒を打てるかどうかの制限チェック
      print('制限チェック: ${selectedCapturedPiece!.type} を ($row, $col) に打とうとしています');
      // 制限チェック用の仮の駒を作成（正しい色を使用）
      final tempPiece = Piece(
        type: selectedCapturedPiece!.type,
        color: selectedCapturedPieceColor!,
        isPromoted: false,
      );
      final canDrop = _canDropPiece(tempPiece, row, col);
      print('制限チェック結果: $canDrop');
      if (!canDrop) {
        // 制限により駒を打てない場合のダイアログ表示
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('そこには駒を打つことができません'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // 持ち駒の色を正しく設定してから盤面に配置
      final pieceToDrop = Piece(
        type: selectedCapturedPiece!.type,
        color: selectedCapturedPieceColor!,
        isPromoted: false,
      );

      // 持ち駒を盤面に配置
      board.dropPiece(pieceToDrop, selectedCapturedPiece!, row, col);

      setState(() {
        selectedCapturedPiece = null;
        selectedCapturedPieceColor = null;

        // 手番を交代
        _switchTurn();

        // ゲーム終了チェック
        _checkGameOver();
      });
    }
  }

  // ゲーム終了チェック
  void _checkGameOver() {
    if (board.isGameOver()) {
      final winner = board.getWinner();
      if (winner != null) {
        _showGameOverDialog(winner);
      }
    }
  }

  // ゲーム終了ダイアログを表示
  void _showGameOverDialog(PieceColor winner) {
    showDialog(
      context: context,
      barrierDismissible: false, // ダイアログ外タップで閉じない
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('対局終了'),
          content: Text(
            winner == PieceColor.black
                ? '${board.blackPlayerName}の勝ち！'
                : '${board.whitePlayerName}の勝ち！',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('新しい対局'),
            ),
          ],
        );
      },
    );
  }

  // ゲームをリセット
  void _resetGame() {
    setState(() {
      board = Board();
      selectedRow = null;
      selectedCol = null;
      movableMap = null;
      selectedCapturedPiece = null;
      selectedCapturedPieceColor = null;
    });
  }

  // 手番表示を修正
  Widget _buildTurnIndicator() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
        color: board.getCurrentPlayer() == PieceColor.black
            ? Colors.black87
            : Colors.white,
      ),
      child: Column(
        children: [
          Text(
            '${board.getCurrentPlayerName()}の手番',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: board.getCurrentPlayer() == PieceColor.black
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 手番を交代する処理を追加
  void _switchTurn() {
    board.switchPlayer();
    setState(() {});
  }

  // 手番でない場合のダイアログを表示
  void _showNotYourTurnDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('手番ではありません'),
          content: Text('現在は${board.getCurrentPlayerName()}の手番です。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 手番表示を上部に追加
          _buildTurnIndicator(),
          const SizedBox(height: 16),

          // 既存のレイアウト
          Row(
            children: [
              // 左側：白の持ち駒表示エリア
              SizedBox(
                width: 120,
                child: Column(
                  children: [
                    // 白の持ち駒
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${board.whitePlayerName}の持ち駒',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 同じ駒をグループ化して重ねて表示
                          ..._getGroupedCapturedPieces(
                            board.getCapturedPieces(PieceColor.white),
                          ).map((group) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print(
                                    '白の持ち駒タップ: ${group.pieces[0].type}',
                                  ); // デバッグログ
                                  _onCapturedPieceTap(
                                    group.pieces[0],
                                    PieceColor.white,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          selectedCapturedPiece ==
                                                  group.pieces[0] &&
                                              selectedCapturedPieceColor ==
                                                  PieceColor.white
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: SizedBox(
                                    // SizedBoxで明示的なサイズを指定
                                    width: 100, // 複数の駒が重なることを考慮した幅
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        for (
                                          int i = 0;
                                          i < group.pieces.length;
                                          i++
                                        )
                                          Positioned(
                                            left: i * 10.0,
                                            child: Transform.rotate(
                                              angle: 3.14159,
                                              child: Image.asset(
                                                group.pieces[i].imagePath,
                                                width: 50,
                                                height: 50,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Text(
                                                        _getPieceDisplayName(
                                                          group.pieces[i],
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          if (board.getCapturedPieces(PieceColor.white).isEmpty)
                            const Text(
                              'なし',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          // ヘルプテキストを追加
                          if (board
                              .getCapturedPieces(PieceColor.white)
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'タップで選択/キャンセル',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 400), // 下部にスペースを追加（白を下げる）
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // 中央：将棋盤エリア
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Column(
                    children: [
                      // 上部の横軸ラベル（一-九）
                      Row(
                        children: [
                          const SizedBox(width: 20), // 左上の空白
                          ...List.generate(9, (index) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  _getHorizontalLabel(8 - index),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // 将棋盤本体
                      Expanded(
                        child: Row(
                          children: [
                            // 将棋盤のグリッド
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.brown,
                                    width: 2.0,
                                  ),
                                  color: const Color(
                                    0xFFF4E4BC,
                                  ), // decoration内に移動
                                ),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 9,
                                      ),
                                  itemCount: 81,
                                  itemBuilder: (context, index) {
                                    final row = index ~/ 9;
                                    final col = index % 9;
                                    final piece = board.getPiece(row, col);
                                    final isSelected =
                                        (row == selectedRow &&
                                        col == selectedCol);
                                    final isMovable =
                                        movableMap != null &&
                                        movableMap![row][col];
                                    return GestureDetector(
                                      onTap: () => _onCellTap(row, col),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.yellow[200]
                                              : isMovable
                                              ? Colors.lightBlue[100]
                                              : const Color(0xFFF4E4BC),
                                          border: Border.all(
                                            color: Colors.brown,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: piece != null
                                            ? Image.asset(
                                                piece.imagePath,
                                                fit: BoxFit.contain,
                                                width: 30,
                                                height: 30,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              _getPieceDisplayName(
                                                                piece,
                                                              ),
                                                              style: const TextStyle(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .brown,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            if (piece
                                                                .isPromoted)
                                                              const Text(
                                                                '成',
                                                                style: TextStyle(
                                                                  fontSize: 6,
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                              )
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // 右側の縦軸ラベル（1-9）
                            Column(
                              children: List.generate(9, (index) {
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // 右側：黒の持ち駒表示エリア
              SizedBox(
                width: 120,
                child: Column(
                  children: [
                    const SizedBox(height: 400), // 上部にスペースを追加（黒を上げる）
                    // 黒の持ち駒
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xFFF4E4BC),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${board.blackPlayerName}の持ち駒',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 同じ駒をグループ化して重ねて表示
                          ..._getGroupedCapturedPieces(
                            board.getCapturedPieces(PieceColor.black),
                          ).map((group) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print(
                                    '黒の持ち駒タップ: ${group.pieces[0].type}',
                                  ); // デバッグログ
                                  _onCapturedPieceTap(
                                    group.pieces[0],
                                    PieceColor.black,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          selectedCapturedPiece ==
                                                  group.pieces[0] &&
                                              selectedCapturedPieceColor ==
                                                  PieceColor.black
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: SizedBox(
                                    // SizedBoxで明示的なサイズを指定
                                    width: 100, // 複数の駒が重なることを考慮した幅
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        for (
                                          int i = 0;
                                          i < group.pieces.length;
                                          i++
                                        )
                                          Positioned(
                                            left: i * 8.0,
                                            child: Transform.rotate(
                                              angle: 3.14159,
                                              child: Image.asset(
                                                group.pieces[i].imagePath,
                                                width: 50,
                                                height: 50,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Text(
                                                        _getPieceDisplayName(
                                                          group.pieces[i],
                                                        ),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          if (board.getCapturedPieces(PieceColor.black).isEmpty)
                            const Text(
                              'なし',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          // ヘルプテキストを追加
                          if (board
                              .getCapturedPieces(PieceColor.black)
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'タップで選択/キャンセル',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getHorizontalLabel(int index) {
    const labels = ['一', '二', '三', '四', '五', '六', '七', '八', '九'];
    return labels[index];
  }

  String _getPieceDisplayName(Piece piece) {
    if (piece.isPromoted) {
      // 成り駒の日本語名を返す
      switch (piece.type) {
        case PieceType.pawn:
          return 'と';
        case PieceType.lance:
          return '成香';
        case PieceType.knight:
          return '成桂';
        case PieceType.silver:
          return '成銀';
        case PieceType.rook:
          return '龍';
        case PieceType.bishop:
          return '馬';
        default:
          return piece.type.toString().split('.').last;
      }
    }

    // 通常の駒の日本語名を返す
    switch (piece.type) {
      case PieceType.pawn:
        return '歩';
      case PieceType.lance:
        return '香';
      case PieceType.knight:
        return '桂';
      case PieceType.silver:
        return '銀';
      case PieceType.gold:
        return '金';
      case PieceType.king:
        return '王';
      case PieceType.queen:
        return '玉';
      case PieceType.rook:
        return '飛';
      case PieceType.bishop:
        return '角';
      default:
        return piece.type.toString().split('.').last;
    }
  }

  // 同じ種類の駒をグループ化するヘルパーメソッド
  List<_PieceGroup> _getGroupedCapturedPieces(List<Piece> pieces) {
    final Map<String, List<Piece>> groups = {};

    for (final piece in pieces) {
      final key = '${piece.type}_${piece.isPromoted}';
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(piece);
    }

    return groups.values.map((pieces) => _PieceGroup(pieces)).toList();
  }
}
