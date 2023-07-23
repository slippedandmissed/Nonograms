import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonograms/game.dart';
import 'package:nonograms/import_settings_page.dart';
import 'package:nonograms/nonogram.dart';

enum PanType { filling, unfilling, blocking, unblocking, nop }

List<int> calculateHints(List<CellState> cells) {
  bool inSpan = false;
  int spanLength = 0;
  final result = <int>[];
  for (final cell in cells) {
    switch (cell) {
      case CellState.filled:
        inSpan = true;
        spanLength++;
        break;
      default:
        if (inSpan) {
          inSpan = false;
          result.add(spanLength);
          spanLength = 0;
        }
        break;
    }
  }
  if (inSpan) {
    result.add(spanLength);
  }
  return result.isEmpty ? [0] : result;
}

List<List<CellState>> transpose(List<List<CellState>> grid) {
  return List.generate(
      grid[0].length, (index) => grid.map((e) => e[index]).toList());
}

bool listsEqual<T>(
  List<T> a,
  List<T> b, {
  bool Function(T a, T b)? equals,
}) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if ((equals == null && a[i] != b[i]) ||
        (equals != null && !equals(a[i], b[i]))) return false;
  }
  return true;
}

bool doesWin(List<List<CellState>> solution, List<List<CellState>> progress) {
  return listsEqual(
    progress,
    solution,
    equals: (a, b) => listEquals(
        a.map((e) => e == CellState.filled ? e : CellState.empty).toList(), b),
  );
}

List<bool> calculateMatches(List<List<CellState>> grid, List<List<int>> hints) {
  return List.generate(hints.length,
      (index) => listsEqual(calculateHints(grid[index]), hints[index]));
}

class History {
  final _history = <List<List<CellState>>>[];
  int _index = -1;

  void push(List<List<CellState>> state) {
    if (canPop()) {
      if (listsEqual(
        state,
        _history[_index],
        equals: (a, b) => listEquals(a, b),
      )) {
        return;
      }
    }
    if (canUnpop()) {
      _history.removeRange(_index + 1, _history.length);
    }
    _history.add([
      ...state.map((e) => [...e])
    ]);
    _index++;
  }

  bool canPop() {
    return _index > 0;
  }

  List<List<CellState>> pop() {
    return [
      ..._history[--_index].map((e) => [...e])
    ];
  }

  bool canUnpop() {
    return _index < _history.length - 1;
  }

  List<List<CellState>> unpop() {
    return [
      ..._history[++_index].map((e) => [...e])
    ];
  }
}

@RoutePage()
class PlayPage extends ConsumerStatefulWidget {
  final String gameId;
  final Nonogram solution;
  final Nonogram progress;
  final int kernelX, kernelY;
  const PlayPage(
      {super.key,
      required this.gameId,
      required this.solution,
      required this.progress,
      required this.kernelX,
      required this.kernelY});

  final headingSize = 100.0;
  final maxGridWidth = 250.0;
  final maxGridHeight = 450.0;
  final cellBorderWidth = 1.0;
  final borderWidth = 2.0;
  final hintColor = const Color.fromARGB(255, 190, 235, 255);
  final hintTextColor = Colors.black;

  @override
  ConsumerState<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends ConsumerState<PlayPage> {
  late List<List<CellState>> _work;
  late List<List<int>> _rowHints;
  late List<List<int>> _columnHints;

  bool _isBlockingSelected = false;
  final _history = History();

  var _panningCellX = 0, _panningCellY = 0;
  var _panType = PanType.nop;

  @override
  void initState() {
    super.initState();
    _work = [
      ...widget.solution.solution.map((e) => [...e])
    ];
    _history.push(_work);
    _rowHints = widget.solution.solution.map((e) => calculateHints(e)).toList();
    _columnHints = transpose(widget.solution.solution)
        .map((e) => calculateHints(e))
        .toList();
  }

  CellState calculateNewCellState(CellState state) {
    switch (_panType) {
      case PanType.nop:
        return state;
      case PanType.filling:
        return state == CellState.blocked ? state : CellState.filled;
      case PanType.unfilling:
        return state == CellState.blocked ? state : CellState.empty;
      case PanType.blocking:
        return state == CellState.filled ? state : CellState.blocked;
      case PanType.unblocking:
        return state == CellState.filled ? state : CellState.empty;
    }
  }

  Future<void> save() async {
    final storedGames = ref.read(storedGamesProvider);
    final game = await storedGames.getGame(widget.gameId);
    final kernel = game.progress.kernels[widget.kernelY][widget.kernelX];
    game.progress.kernels[widget.kernelY][widget.kernelX] =
        kernel.copyWith(solution: _work);
    await storedGames.storeGame(game);
  }

  @override
  Widget build(BuildContext context) {
    var gridWidth = widget.maxGridWidth;
    var cellSize =
        (gridWidth - 2 * widget.borderWidth) / widget.solution.gridWidth;
    var gridHeight =
        cellSize * widget.solution.gridHeight + 2 * widget.borderWidth;
    if (gridHeight > widget.maxGridHeight) {
      gridHeight = widget.maxGridHeight;
      cellSize =
          (gridHeight - 2 * widget.borderWidth) / widget.solution.gridHeight;
      gridWidth = cellSize * widget.solution.gridWidth + 2 * widget.borderWidth;
    }

    final borderSide = BorderSide(
      color: Colors.black,
      width: widget.borderWidth,
    );

    final rowsComplete = calculateMatches(_work, _rowHints);
    final columnsComplete = calculateMatches(transpose(_work), _columnHints);

    final allComplete =
        [...rowsComplete, ...columnsComplete].every((element) => element);
    final win = allComplete ? doesWin(widget.solution.solution, _work) : false;

    final hintColor =
        allComplete ? (win ? Colors.green : Colors.red) : widget.hintColor;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                setState(() {
                  for (final row in _work) {
                    for (int i = 0; i < row.length; i++) {
                      row[i] = CellState.empty;
                    }
                  }
                  _history.push(_work);
                });
                await save();
              },
              child: const Icon(Icons.delete_forever),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: widget.headingSize,
                height: widget.headingSize,
              ),
              Container(
                width: gridWidth,
                height: widget.headingSize,
                decoration: BoxDecoration(
                  border: Border(
                    top: borderSide,
                    left: borderSide,
                    right: borderSide,
                  ),
                  color: hintColor,
                ),
                child: Row(
                  children: [
                    for (int i = 0; i < widget.solution.gridWidth; i++)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: widget.cellBorderWidth),
                        ),
                        width: cellSize,
                        child: Column(children: [
                          for (final hint in _columnHints[i])
                            Text(
                              "$hint",
                              style: TextStyle(
                                  color: columnsComplete[i]
                                      ? Colors.grey
                                      : widget.hintTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                        ]),
                      )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: widget.headingSize,
                height: gridHeight,
                decoration: BoxDecoration(
                  border: Border(
                    left: borderSide,
                    top: borderSide,
                    bottom: borderSide,
                  ),
                  color: hintColor,
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < widget.solution.gridHeight; i++)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: widget.cellBorderWidth),
                        ),
                        height: cellSize,
                        child: Row(
                          children: [
                            for (final hint in _rowHints[i])
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  "$hint",
                                  style: TextStyle(
                                    color: rowsComplete[i]
                                        ? Colors.grey
                                        : widget.hintTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              GestureDetector(
                onPanEnd: (details) async {
                  setState(() {
                    _history.push(_work);
                  });
                  await save();
                },
                onPanCancel: () async {
                  setState(() {
                    _history.push(_work);
                  });
                  await save();
                },
                onPanDown: (details) {
                  final cellX = (details.localPosition.dx / cellSize).floor();
                  final cellY = (details.localPosition.dy / cellSize).floor();
                  final state = _work[cellY][cellX];
                  final PanType panType;
                  switch (state) {
                    case CellState.empty:
                      panType = _isBlockingSelected
                          ? PanType.blocking
                          : PanType.filling;
                      break;
                    case CellState.filled:
                      panType =
                          _isBlockingSelected ? PanType.nop : PanType.unfilling;
                      break;
                    case CellState.blocked:
                      panType = _isBlockingSelected
                          ? PanType.unblocking
                          : PanType.nop;
                      break;
                  }
                  setState(() {
                    _panningCellX = cellX;
                    _panningCellY = cellY;
                    _panType = panType;
                  });
                  final newState = calculateNewCellState(state);
                  if (state != newState) {
                    setState(() {
                      _work[cellY][cellX] = newState;
                    });
                  }
                },
                onPanUpdate: (details) {
                  final cellX = (details.localPosition.dx / cellSize).floor();
                  final cellY = (details.localPosition.dy / cellSize).floor();
                  if (cellX != _panningCellX && cellY != _panningCellY) return;
                  final state = _work[cellY][cellX];
                  final newState = calculateNewCellState(state);
                  if (state != newState) {
                    setState(() {
                      _work[cellY][cellX] = newState;
                    });
                  }
                },
                child: Container(
                  width: gridWidth,
                  height: gridHeight,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      borderSide,
                    ),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.solution.gridHeight; i++)
                        Row(
                          children: [
                            for (int j = 0; j < widget.solution.gridWidth; j++)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: widget.cellBorderWidth),
                                  color: _work[i][j] == CellState.filled
                                      ? Colors.deepPurple
                                      : Colors.white,
                                ),
                                width: cellSize,
                                height: cellSize,
                                child: _work[i][j] == CellState.blocked
                                    ? CustomPaint(painter: BlockCrossPainter())
                                    : null,
                              )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                isSelected: _isBlockingSelected ? [false, true] : [true, false],
                children: [
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black, width: widget.cellBorderWidth),
                      color: Colors.deepPurple,
                    ),
                  ),
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black, width: widget.cellBorderWidth),
                      color: Colors.white,
                    ),
                    child: CustomPaint(painter: BlockCrossPainter()),
                  ),
                ],
                onPressed: (index) {
                  setState(() {
                    _isBlockingSelected = index == 1;
                  });
                },
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: _history.canPop()
                    ? () async {
                        setState(() {
                          _work = _history.pop();
                        });
                        await save();
                      }
                    : null,
                child: const Icon(Icons.undo),
              ),
              TextButton(
                onPressed: _history.canUnpop()
                    ? () async {
                        setState(() {
                          _work = _history.unpop();
                        });
                        await save();
                      }
                    : null,
                child: const Icon(Icons.redo),
              ),
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
