library reactive_repo_state;

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'reactive_repo_status.dart';

class ReactiveRepoState<T extends Equatable> extends Equatable {
  final ReactiveRepoStatus status;
  final T? data;

  ReactiveRepoState({required this.status, this.data}) : assert(!status.expectData || data != null);

  ReactiveRepoState.initial()
      : status = ReactiveRepoStatus.initial,
        data = null;

  @override
  List<Object?> get props => [status, data];

  bool get hasData => data != null;

  bool get isInitial => status.isInitial;

  bool get isLoading => status.isLoading;

  bool get isFailure => status.isFailure;

  bool get isSuccess => status.isSuccess;

  ReactiveRepoState<T> withLoading() => ReactiveRepoState(
    status: data == null ? ReactiveRepoStatus.initialLoading : ReactiveRepoStatus.updateLoading,
    data: data,
  );

  ReactiveRepoState<T> withFailure() => ReactiveRepoState(
    status: data == null ? ReactiveRepoStatus.initialFailure : ReactiveRepoStatus.updateFailure,
    data: data,
  );

  ReactiveRepoState<T> withSuccess(T data) => ReactiveRepoState(
    status: this.data == null ? ReactiveRepoStatus.initialSuccess : ReactiveRepoStatus.updateSuccess,
    data: data,
  );

  ReactiveRepoState<T> withStatus(ReactiveRepoStatus status) => ReactiveRepoState(
    status: status,
    data: data,
  );

  factory ReactiveRepoState.fromJson(Map<String, dynamic> json, T? Function(Map<String, dynamic>) dataFromJson) {
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

