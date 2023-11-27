import 'package:equatable/equatable.dart';

class DefaultProviderType extends Equatable{
  final int projectId;
   const DefaultProviderType({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}