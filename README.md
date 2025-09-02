# EaseMob Flutter Demo - MVI 架构

一个全面的 Flutter 聊天应用程序，使用 EaseMob SDK 和现代 MVI（Model-View-Intent）架构模式演示实时消息功能。

## 📱 功能特性

### 核心功能
- **用户身份验证**：使用 EaseMob SDK 进行安全登录/退出
- **实时消息**：即时发送和接收消息
- **会话管理**：查看带有未读计数的会话列表
- **联系人管理**：添加、删除和管理联系人
- **群聊**：支持群组会话
- **用户资料**：显示当前用户信息

### 界面/体验功能
- **微信风格界面**：现代化和直观的设计
- **下拉刷新**：更新会话和联系人
- **实时更新**：实时消息和会话更新
- **加载状态**：为用户操作提供清晰的反馈
- **错误处理**：全面的错误消息和重试选项

## 🏗️ 架构

该项目遵循 **MVI（Model-View-Intent）**架构模式，使用 BLoC 库：

```
┌─────────────────┐    Intent     ┌──────────────┐    State    ┌──────────────┐
│                 │ ────────────> │              │ ──────────> │              │
│      视图       │               │     BLoC     │             │    状态     │
│   （UI 层）    │ <──────────── │  （业务   │ <────────── │  （数据）      │
│                 │    Event      │   逻辑）     │   Action    │              │
└─────────────────┘               └──────────────┘             └──────────────┘
```

### 目录结构

```
lib/
├── core/                    # 基本 MVI 基础设施
│   ├── base_intent.dart     # 所有 Intent 的基类
│   ├── base_state.dart      # 所有 State 的基类  
│   └── base_event.dart      # 所有 Event 的基类
├── models/                  # 数据模型
│   ├── user_model.dart      # 用户数据模型
│   ├── message_model.dart   # 消息数据模型
│   ├── conversation_model.dart # 会话数据模型
│   └── contact_model.dart   # 联系人数据模型
├── repositories/            # 数据层抽象
│   ├── auth_repository.dart # 身份验证操作
│   ├── chat_repository.dart # 聊天操作
│   └── contact_repository.dart # 联系人操作  
├── features/               # 基于功能的 MVI 模块
│   ├── login/              # 登录功能
│   ├── chat/               # 聊天消息
│   ├── conversations/      # 会话列表
│   ├── contacts/           # 联系人管理
│   └── home/               # 导航
└── widget/                 # UI 组件
```

## 🚀 快速开始

### 前置条件

- **Flutter SDK**: >= 3.4.0
- **Dart SDK**: >= 3.4.0  
- **Android Studio** 或 **Xcode** 用于原生构建
- **环信账户**：在 [环信控制台](https://console.easemob.com/) 注册

### 安装

1. **克隆代码库**
   ```bash
   git clone <repository-url>
   cd easemob_flutter_demo
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **iOS 设置** (iOS)
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **配置 EaseMob SDK**
   - 在 `lib/repositories/auth_repository.dart` 中更新您的 App Key
   ```dart
   EMOptions options = EMOptions.withAppKey(
     "your-app-key#your-app-name", // 更换为您的 EaseMob App Key
     autoLogin: false,
     debugMode: true,
   );
   ```

5. **运行应用程序**
   ```bash
   flutter run
   ```

## 🔧 配置

### EaseMob 设置

1. **创建 EaseMob 账户**：访问 [环信控制台](https://console.easemob.com/)
2. **创建应用**：从控制台获取您的 App Key
3. **更新配置**：在 `auth_repository.dart` 中替换 App Key

### 构建配置

- **Android**: 最低 SDK 版本 21 (Android 5.0+)
- **iOS**: 最低部署目标 iOS 10.0+

## 📖 使用指南

### 1. 身份验证
``dart
// 使用用户名和密码登录
context.read<LoginBloc>().add(
  LoginSubmittedIntent(username: "user", password: "password")
);
```

### 2. 发送消息
``dart
// 发送文本消息
context.read<ChatBloc>().add(
  SendTextMessageIntent(content: "你好世界！")
);
```

### 3. 管理联系人
```dart
// 添加新联系人
context.read<ContactsBloc>().add(
  AddContactIntent(userId: "user123", reason: "好友请求")
);
```

## 🧪 测试

### 运行测试
```bash
# 运行所有测试
flutter test

# 运行覆盖率测试
flutter test --coverage

# 分析代码
flutter analyze
```

### 测试结构
```
test/
├── unit/               # 业务逻辑单元测试
├── widget/             # UI 组件测试
└── integration/        # 功能集成测试
```

## 🔨 构建与部署

### 开发构建
```bash
# 调试构建
flutter run

# 发布构建
flutter run --release
```

### 生产构建
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📦 依赖项

### 核心依赖
```yaml
dependencies:
  flutter: sdk: flutter
  flutter_bloc: ^8.1.6      # 状态管理
  equatable: ^2.0.5          # 值相等性
  im_flutter_sdk: 4.15.1     # EaseMob SDK
  intl: ^0.17.0              # 国际化
```

### 开发依赖
```yaml
dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^4.0.0
```

## 🏛️ MVI 架构详解

### Intent（用户操作）
表示用户交互和系统事件：
```dart
abstract class LoginIntent extends BaseIntent {
  const LoginIntent();
}

class LoginSubmittedIntent extends LoginIntent {
  final String username;
  final String password;
  // ...
}
```

### State（UI 状态）
表示 UI 的当前状态：
```dart
abstract class LoginState extends BaseState {
  const LoginState();
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}
```

### BLoC（业务逻辑）
处理 intent 并发出状态：
```dart
class LoginBloc extends Bloc<LoginIntent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmittedIntent>(_onLoginSubmitted);
  }
  
  Future<void> _onLoginSubmitted(
    LoginSubmittedIntent intent,
    Emitter<LoginState> emit,
  ) async {
    // 业务逻辑在此处
  }
}
```

## 🔍 故障排除

### 常见问题

1. **构建失败**
   ```bash
   flutter clean
   flutter pub get
   # iOS 平台
   cd ios && pod install && cd ..
   ```

2. **EaseMob SDK 问题**
   - 验证 App Key 配置
   - 检查网络连接
   - 确保正确的 SDK 初始化

3. **平台特定问题**
   - **Android**: 检查 `android/app/build.gradle` 中的 minSdkVersion
   - **iOS**: 验证 `ios/Runner.xcodeproj` 中的部署目标

## 📚 API 文档

### 身份验证
- `login(username, password)`: 用户身份验证
- `logout()`: 退出当前用户
- `isLoggedIn()`: 检查登录状态

### 消息传递
- `sendTextMessage(toUserId, content)`: 发送文本消息
- `loadMessages(conversationId)`: 加载消息历史
- `markAsRead(conversationId)`: 标记消息为已读

### 联系人
- `loadContacts()`: 获取联系人列表
- `addContact(userId, reason)`: 添加新联系人
- `removeContact(userId)`: 移除联系人

## 🤝 贡献

1. Fork 代码库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m '添加令人惊叹的功能'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### 代码风格
- 遵循 [Dart 风格指南](https://dart.dev/guides/language/effective-dart/style)
- 使用有意义的变量和函数名
- 添加全面的注释和文档
- 为新功能编写测试

## 📄 许可证

该项目在 MIT 许可证下授权 - 详情请参阅 [LICENSE](LICENSE) 文件。

## 🆘 支持

- **文档**：[EaseMob Flutter SDK 文档](https://docs-im.easemob.com/im/flutter/sdk/)
- **问题**：在 GitHub 上创建 issue
- **社区**：[环信开发者社区](https://developer.easemob.com/)

## 📋 更新日志

### 版本 1.0.0
- ✅ 初始 MVI 架构实现
- ✅ 使用 EaseMob SDK 进行用户身份验证
- ✅ 实时消息功能
- ✅ 会话和联系人管理
- ✅ 现代 UI 带加载状态和错误处理

## 🔮 路线图

- [ ] 群聊管理
- [ ] 文件和媒体消息支持
- [ ] 推送通知
- [ ] 消息加密
- [ ] 语音和视频通话
- [ ] 深色主题支持
- [ ] 国际化 (i18n)

---

**用 ❤️ 和 Flutter 及 EaseMob SDK 打造**