import 'package:equatable/equatable.dart';

class QueryParameters extends Equatable {
  const QueryParameters({required this.date});

  final DateTime date;

  @override
  List<Object?> get props => [date];
}
