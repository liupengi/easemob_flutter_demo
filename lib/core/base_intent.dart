import 'package:equatable/equatable.dart';

/// MVI 模式中所有 Intent 的基类
/// 
/// Intent 表示用户操作和触发状态变化的事件。
/// 所有特定功能的 Intent 都应该继承这个基类以确保
/// 应用程序的一致性。
/// 
/// 示例：
/// ```dart
/// class LoginSubmittedIntent extends BaseIntent {
///   final String username;
///   final String password;
///   
///   const LoginSubmittedIntent({required this.username, required this.password});
/// }
/// ```
abstract class BaseIntent extends Equatable {
  const BaseIntent();

  @override
  List<Object?> get props => [];
}
