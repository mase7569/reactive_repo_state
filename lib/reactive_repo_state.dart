library reactive_repo_state;

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'reactive_repo_status.dart';

class ReactiveRepoState<D extends Equatable> extends Equatable {
  final ReactiveRepoStatus status;
  final D? data;
  final dynamic error;

  ReactiveRepoState({required this.status, this.data, this.error}) : assert(!status.expectData || data != null);

  ReactiveRepoState.initial()
      : status = ReactiveRepoStatus.initial,
        data = null,
        error = null;

  @override
  List<Object?> get props => [status, data];

  bool get hasData => data != null;

  bool get isInitial => status.isInitial;

  bool get isLoading => status.isLoading;

  bool get isFailure => status.isFailure;

  bool get isSuccess => status.isSuccess;

  ReactiveRepoState<D> withLoading() => ReactiveRepoState(
        status: data == null ? ReactiveRepoStatus.initialLoading : ReactiveRepoStatus.updateLoading,
        data: data,
        error: null,
      );

  ReactiveRepoState<D> withFailure({dynamic error}) => ReactiveRepoState(
        status: data == null ? ReactiveRepoStatus.initialFailure : ReactiveRepoStatus.updateFailure,
        data: data,
        error: error,
      );

  ReactiveRepoState<D> withSuccess(D data) => ReactiveRepoState(
        status: this.data == null ? ReactiveRepoStatus.initialSuccess : ReactiveRepoStatus.updateSuccess,
        data: data,
        error: null,
      );

  ReactiveRepoState<D> withStatus(ReactiveRepoStatus status) => ReactiveRepoState(
        status: status,
        data: data,
        error: error,
      );

  factory ReactiveRepoState.fromJson(Map<String, dynamic> json, D? Function(Map<String, dynamic>) dataFromJson) {
    Map<String, dynamic>? dataJson = jsonDecode(json['data']);
    return ReactiveRepoState(
      status: ReactiveRepoStatus.values[json['status']],
      data: dataJson == null ? null : dataFromJson(dataJson),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status.index,
        'data': jsonEncode(data),
      };
}
