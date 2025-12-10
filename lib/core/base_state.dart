import 'package:equatable/equatable.dart';

/// MVI 模式中所有 State 的基类
/// 
/// State 表示 UI 在任何给定时刻的当前状态。
/// 它们是不可变的，应该包含渲染 UI 所需的所有数据。
/// 
/// 示例：
/// ```dart
/// class LoginLoadedState extends BaseState {
///   final UserModel user;
///   
///   const LoginLoadedState({required this.user});
///   
///   @override
///   List<Object?> get props => [user];
/// }
/// ```
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

/// 加载场景的通用状态
/// 当操作正在进行中UI应该显示加载指示器时使用
class LoadingState extends BaseState {
  const LoadingState();
}

/// 错误场景的通用状态
/// 包含错误消息和用于调试的可选错误对象
class ErrorState extends BaseState {
  final String message;
  final dynamic error;

  const ErrorState({required this.message, this.error});

  @override
  List<Object?> get props => [message, error];
}
