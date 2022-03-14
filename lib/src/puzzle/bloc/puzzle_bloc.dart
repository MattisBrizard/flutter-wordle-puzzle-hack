// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:puzzle_hack/src/entities/position.dart';
import 'package:puzzle_hack/src/entities/puzzle.dart';
import 'package:puzzle_hack/src/entities/tile.dart';
import 'package:puzzle_hack/src/words/words.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(
    this._size, {
    this.random,
  }) : super(const PuzzleState()) {
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  final int _size;

  final Random? random;

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleReset(
    PuzzleReset event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _generatePuzzle(_size, event.localeIdentifier);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, String localeIdentifier) {
    final words = _wordsFromLocale(size, localeIdentifier);
    final currentPositions = <Position>[];
    final correctPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          currentPositions.add(whitespacePosition);
          correctPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          currentPositions.add(position);
          correctPositions.add(position);
        }
      }
    }

    currentPositions.shuffle(random);

    List<Tile> tiles = _getTileListFromPositions(
      size,
      words,
      correctPositions,
      currentPositions,
    );

    Puzzle puzzle = Puzzle(tiles: tiles);

    // Assign the tiles new current positions until the puzzle is solvable and
    // zero tiles are in their correct position.
    while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
      currentPositions.shuffle(random);
      tiles = _getTileListFromPositions(
        size,
        words,
        correctPositions,
        currentPositions,
      );
      puzzle = Puzzle(tiles: tiles);
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<String> words,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final letters = words
        .map((e) => e.split(''))
        .expand(
          (element) => element,
        )
        .toList();

    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            letter: '',
            correctPosition: whitespacePosition,
            correctUnauthorizedPositions: const [],
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            letter: letters[i - 1],
            correctUnauthorizedPositions: [
              // Filters other correct position but not authorized as
              // the configuration may be not solvable.
              ...letters
                  .allIndexesWhere((element) => element == letters[i - 1])
                  .where((element) => element != i - 1)
                  .map((e) => Position.fromInt(value: e, size: size))
            ],
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }
}

extension _ListExtensions<T> on List<T> {
  List<int> allIndexesWhere(bool Function(T element) test) {
    final indexes = <int>[];
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        indexes.add(i);
      }
    }
    return indexes;
  }
}

List<String> _wordsFromLocale(int size, String localeIdentifier) {
  final rand = Random();
  final words = <String>[];
  final localizedFiveLettersWords = fiveLettersWordsMap[localeIdentifier]!;
  final localizedFourLettersWords = fourLettersWordsMap[localeIdentifier]!;
  for (int i = 0; i < size; i++) {
    if (i == size - 1) {
      words.add(
        localizedFourLettersWords[rand.nextInt(
          localizedFourLettersWords.length,
        )],
      );
    } else {
      words.add(
        localizedFiveLettersWords[rand.nextInt(
          localizedFiveLettersWords.length,
        )],
      );
    }
  }

  return words;
}
