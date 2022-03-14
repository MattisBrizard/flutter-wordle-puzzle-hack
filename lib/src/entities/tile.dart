import 'package:equatable/equatable.dart';
import 'package:puzzle_hack/src/entities/position.dart';

/// {@template tile}
/// Model for a puzzle tile.
/// {@endtemplate}
class Tile extends Equatable {
  /// {@macro tile}
  const Tile({
    required this.letter,
    required this.value,
    required this.correctPosition,
    required this.correctUnauthorizedPositions,
    required this.currentPosition,
    this.isWhitespace = false,
  });

  /// The letter of the [Tile].
  final String letter;

  /// Value representing the correct position of [Tile] in a list.
  final int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in the
  /// correct position to complete the puzzle.
  final Position correctPosition;

  /// The 2D [Position] of the [Tile] that are theorically correct.
  /// But not authorized to be able to solve the puzzle.
  final List<Position> correctUnauthorizedPositions;

  /// The current 2D [Position] of the [Tile].
  final Position currentPosition;

  bool get isInCorrectPosition =>
      positionState.status == TilePositionStatus.correct &&
      !positionState.isPositionUnauthorized;

  List<Position> get _allCorrectPositions => [
        correctPosition,
        ...correctUnauthorizedPositions,
      ];

  TilePositionState get positionState {
    final isCurrentPositionUnauthorized = correctUnauthorizedPositions.contains(
          currentPosition,
        ) ||
        correctUnauthorizedPositions.any(
          (element) =>
              element.y != correctPosition.y && element.y == currentPosition.y,
        );
    if (_allCorrectPositions.contains(currentPosition)) {
      return TilePositionState(
        status: TilePositionStatus.correct,
        isPositionUnauthorized: isCurrentPositionUnauthorized,
      );
    } else if (_allCorrectPositions.any(
      (element) => element.y == currentPosition.y,
    )) {
      return TilePositionState(
        status: TilePositionStatus.inWord,
        isPositionUnauthorized: isCurrentPositionUnauthorized,
      );
    }
    return TilePositionState(
      status: TilePositionStatus.notInWord,
      isPositionUnauthorized: isCurrentPositionUnauthorized,
    );
  }

  /// Denotes if the [Tile] is the whitespace tile or not.
  final bool isWhitespace;

  /// Create a copy of this [Tile] with updated current position.
  Tile copyWith({required Position currentPosition}) {
    return Tile(
      letter: letter,
      value: value,
      correctUnauthorizedPositions: correctUnauthorizedPositions,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
      isWhitespace: isWhitespace,
    );
  }

  @override
  List<Object> get props => [
        letter,
        value,
        correctPosition,
        correctUnauthorizedPositions,
        currentPosition,
        isWhitespace,
      ];
}

enum TilePositionStatus {
  correct,
  inWord,
  notInWord,
}

class TilePositionState extends Equatable {
  const TilePositionState({
    required this.status,
    required this.isPositionUnauthorized,
  });

  final TilePositionStatus status;
  final bool isPositionUnauthorized;

  @override
  List<Object> get props => [
        status,
        isPositionUnauthorized,
      ];
}
