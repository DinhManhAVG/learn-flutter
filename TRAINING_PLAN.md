# Kế hoạch Luyện tập Flutter - Lộ trình 9 Tuần

> **Cập nhật lần cuối:** 12/03/2026  
> **Dự án:** Office Companion App (todo_app_flutter)  
> **Đánh giá tiến độ:** Xem chi tiết bên dưới trước khi bắt đầu

---

## 📊 Đánh giá tiến độ hiện tại

| Giai đoạn | Nội dung | Trạng thái | Ghi chú |
|-----------|----------|------------|---------|
| **Tuần 1** | Widget cơ bản | ✅ **HOÀN THÀNH** | Tất cả widget cơ bản đã được dùng trong project |
| **Tuần 2** | Widget động & Responsive | ✅ **HOÀN THÀNH** | StatefulWidget, ListView, GridView, FutureBuilder đã implement |
| **Tuần 3** | Cubit cơ bản | 🔴 **CHƯA LÀM** | Project đang dùng `Provider` thay vì Cubit |
| **Tuần 4** | Cubit nâng cao | 🔴 **CHƯA LÀM** | — |
| **Tuần 5** | API cơ bản | 🟡 **LÀM MỘT PHẦN** | Đã dùng Dio cho weather API nhưng chưa tích hợp với Cubit |
| **Tuần 6** | API nâng cao | 🔴 **CHƯA LÀM** | StorageService viết xong nhưng chưa nối vào auth flow |
| **Tuần 7** | Clean Architecture + BLoC + Git | 🔴 **CHƯA LÀM** | Project đang là flat feature-first, chưa phân layer |
| **Tuần 8-9** | Final Project | 🔴 **CHƯA LÀM** | — |

### Nhận xét chi tiết

**Điểm mạnh:** UI/UX hoàn thiện, glassmorphism design system nhất quán, Firebase Auth + Firestore hoạt động, theme hệ thống dark/light đầy đủ.

**Cần cải thiện:**
- `app/routes.dart` và `app/app.dart` hoàn toàn rỗng — chưa có routing system
- `StorageService` đã viết nhưng không được gọi sau khi login thành công
- Auth session persistence chưa có — app khởi động lại sẽ về onboarding dù đã login
- `MoreScreen` hiển thị hardcode "John Doe" thay vì dữ liệu Firebase thực
- Logout trong `MoreScreen` chỉ là `// TODO`
- `HomeScreen` `RefreshIndicator` không thực sự gọi lại API
- Chưa có Cubit/BLoC nào

---

## 🚀 Giai đoạn 2 – Tuần 3: Làm quen với Cubit

> **Mục tiêu:** Hiểu được cơ chế quản lý state bằng Cubit, và áp dụng vào project hiện tại.

---

### 1. Tại sao cần State Management? Provider vs Cubit

Hiện tại project dùng `Provider` với `ChangeNotifier`. Đây là cách tiếp cận đơn giản nhưng có nhược điểm:

- **ChangeNotifier** kết hợp logic + state + notification vào một lớp → khó test, khó tách biệt
- **notifyListeners()** rebuild toàn bộ subtree nghe provider đó
- Khó phân biệt rõ: state đang là gì? đã xảy ra gì?

**Cubit** (thuộc thư viện `flutter_bloc`) giải quyết điều này bằng cách:

| Provider (ChangeNotifier) | Cubit |
|--------------------------|-------|
| State và logic trộn lẫn | State và logic tách biệt |
| `notifyListeners()` | `emit(NewState())` |
| Dùng `Consumer` / `Provider.of` | Dùng `BlocBuilder` |
| Khó test | Dễ test (pure logic, không cần Flutter) |
| Không kiểm soát transition | Có thể override `onChange()` để log mọi thay đổi |

---

### 2. Cubit là gì?

```
         [Event/Action]         [New State]
    UI  ───────────────► Cubit ────────────► UI
         (gọi method)    (emit) (BlocBuilder rebuild)
```

**Cubit** là một lớp mở rộng từ `BlocBase`. Nó:
1. Giữ **một state** tại bất kỳ thời điểm nào
2. Expose các **method** để UI gọi (không phải event như BLoC)
3. Gọi `emit(newState)` để publish state mới ra ngoài

**Cấu trúc tối thiểu của một Cubit:**

```dart
// 1. Định nghĩa State
abstract class CounterState {}

class CounterInitial extends CounterState {}
class CounterValue extends CounterState {
  final int count;
  CounterValue(this.count);
}

// 2. Viết Cubit
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<CounterState> {
  // super(initialState) — state khởi tạo
  CounterCubit() : super(CounterInitial());

  // Method để UI gọi
  void increment() {
    // Đọc state hiện tại qua getter `state`
    final current = state is CounterValue ? (state as CounterValue).count : 0;
    emit(CounterValue(current + 1));
  }

  void reset() {
    emit(CounterInitial());
  }
}
```

---

### 3. Các widget của `flutter_bloc`

#### a) `BlocProvider` – Cung cấp Cubit xuống widget tree

```dart
// Cú pháp cơ bản:
BlocProvider(
  create: (context) => CounterCubit(),
  child: MyScreen(),
)

// Nếu Cubit cần service/repo:
BlocProvider(
  create: (context) => HomeCubit(weatherService: WeatherService()),
  child: HomeScreen(),
)
```

> **Lưu ý:** `BlocProvider` tự động `close()` Cubit khi widget bị dispose. Không cần quản lý lifecycle thủ công.

#### b) `BlocBuilder` – Rebuild UI khi state thay đổi

```dart
BlocBuilder<CounterCubit, CounterState>(
  builder: (context, state) {
    if (state is CounterInitial) {
      return Text('Chưa có giá trị');
    } else if (state is CounterValue) {
      return Text('Giá trị: ${state.count}');
    }
    return SizedBox.shrink();
  },
)
```

> **Tối ưu:** Dùng `buildWhen` để chỉ rebuild khi cần:
> ```dart
> BlocBuilder<CounterCubit, CounterState>(
>   buildWhen: (previous, current) => current is CounterValue,
>   builder: (context, state) { ... },
> )
> ```

#### c) `BlocListener` – Lắng nghe state để thực hiện side-effect (KHÔNG rebuild UI)

```dart
// Dùng khi cần: navigate, show SnackBar, show Dialog, play sound...
BlocListener<AuthCubit, AuthState>(
  listenWhen: (previous, current) => current is AuthError,
  listener: (context, state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: LoginForm(),
)
```

> **Khác BlocBuilder:** `BlocListener` KHÔNG build lại UI, chỉ phản ứng phụ.

#### d) `BlocConsumer` – Kết hợp cả Builder + Listener

```dart
// Dùng khi vừa cần rebuild UI vừa cần side-effect
BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainDashboard()));
    }
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    return LoginForm();
  },
)
```

#### e) Truy cập Cubit từ context

```dart
// Lấy Cubit và GỌI METHOD (không lắng nghe)
context.read<CounterCubit>().increment();

// Lấy STATE hiện tại (không lắng nghe)
final state = context.read<CounterCubit>().state;

// Lắng nghe state (tự rebuild khi state đổi) — CHỈ dùng trong build()
final state = context.watch<CounterCubit>().state;
```

---

### 4. Thêm `flutter_bloc` vào project

Trong `pubspec.yaml`, thêm:

```yaml
dependencies:
  flutter_bloc: ^9.0.0
```

Chạy `flutter pub get`.

---

### 5. Bài tập thực hành – Tuần 3

**Nhiệm vụ: Chuyển `NavigationProvider` (Provider) → `NavigationCubit` (Cubit)**

Hiện tại `lib/core/providers/navigation_provider.dart`:

```dart
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
```

Và trong `main.dart` được đăng ký:

```dart
ChangeNotifierProvider(create: (_) => NavigationProvider()),
```

**Yêu cầu bạn tự làm:**

1. Tạo file `lib/core/cubits/navigation_cubit.dart`
2. Tạo `NavigationState` (hint: chỉ cần chứa `int currentIndex`)
3. Tạo `NavigationCubit extends Cubit<NavigationState>`
4. Thêm method `changeTab(int index)`
5. Trong `main.dart`: thay `ChangeNotifierProvider` bằng `BlocProvider<NavigationCubit>`
6. Trong `MainDashboard`: thay `Provider.of<NavigationProvider>` bằng `BlocBuilder<NavigationCubit, NavigationState>`
7. Các nút nav bar: thay `context.read<NavigationProvider>().changeIndex(i)` bằng `context.read<NavigationCubit>().changeTab(i)`

**Kiểm tra:** App vẫn navigate giữa các tab như cũ, nhưng không còn dùng Provider.

---

### 6. Bài tập thực hành – Mở rộng

**Nhiệm vụ: Tạo `AuthCubit` để quản lý login flow**

Hiện tại `LoginScreen` gọi thẳng `AuthService().login()` và tự xử lý loading state bằng `setState`. Refactor lại bằng Cubit:

**Các state cần có:**
- `AuthInitial` – trạng thái ban đầu
- `AuthLoading` – đang gọi API
- `AuthSuccess` – login thành công (chứa `UserModel`)
- `AuthError` – đó thất bại (chứa `String message`)

**Hint cấu trúc:**

```dart
// lib/features/auth/cubit/auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit({required AuthService authService})
      : _authService = authService,
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.login(email: email, password: password);
      // TODO: emit success state
    } on FirebaseAuthException catch (e) {
      // TODO: emit error state với message
    }
  }
}
```

**Trong `LoginScreen`:** Wrap bằng `BlocProvider`, dùng `BlocConsumer` để navigate khi success và show SnackBar khi error.

---

## 🔥 Giai đoạn 2 – Tuần 4: Cubit Nâng cao

> **Mục tiêu:** Quản lý state phức tạp — nhiều Cubit trên một màn hình, hoặc một Cubit điều phối nhiều trạng thái khác nhau.

---

### 1. Nhược điểm của State class dạng `abstract + subclass`

Khi state có nhiều class con, bạn phải viết nhiều boilerplate:

```dart
abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final WeatherData weather;
  HomeLoaded(this.weather);
  // Nếu muốn equality check cần override == và hashCode thủ công
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
```

Mỗi lần thêm field vào `HomeLoaded`, bạn phải cập nhật constructor, `copyWith()`, `==`, `hashCode`... **rất tẻ nhạt.**

---

### 2. `Equatable` – So sánh state tự động

Thêm package `equatable`:

```yaml
dependencies:
  equatable: ^2.0.7
```

Sau đó implement:

```dart
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => []; // Các field để so sánh
}

class HomeLoaded extends HomeState {
  final WeatherData weather;
  const HomeLoaded(this.weather);

  @override
  List<Object?> get props => [weather]; // Equatable tự so sánh
}
```

> **Tại sao quan trọng?** Cubit mặc định chỉ `emit` khi new state != old state. Nếu không có Equatable, hai instance `HomeLoaded(same_data)` sẽ bị coi là khác nhau → rebuild không cần thiết.

---

### 3. Một màn hình nhiều Cubit

Dùng khi các phần của màn hình có state độc lập nhau:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => WeatherCubit()),
    BlocProvider(create: (_) => ProfileCubit()),
    BlocProvider(create: (_) => NotificationCubit()),
  ],
  child: HomeScreen(),
)
```

Trong `HomeScreen`, mỗi section dùng `BlocBuilder` của Cubit tương ứng:

```dart
Column(
  children: [
    // Section weather
    BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) => WeatherSection(state: state),
    ),
    // Section profile
    BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) => ProfileSection(state: state),
    ),
  ],
)
```

> **Ưu điểm:** Khi weather update, chỉ `WeatherSection` rebuild, `ProfileSection` không bị ảnh hưởng.

---

### 4. Một Cubit quản lý nhiều loại state

Dùng khi một màn hình có nhiều phần liên quan đến nhau:

```dart
// State chứa tất cả dữ liệu của màn hình
class DashboardState extends Equatable {
  final WeatherData? weather;
  final List<FileItem> recentFiles;
  final bool isWeatherLoading;
  final bool isFilesLoading;
  final String? errorMessage;

  const DashboardState({
    this.weather,
    this.recentFiles = const [],
    this.isWeatherLoading = false,
    this.isFilesLoading = false,
    this.errorMessage,
  });

  // copyWith để tạo state mới từ state cũ
  DashboardState copyWith({
    WeatherData? weather,
    List<FileItem>? recentFiles,
    bool? isWeatherLoading,
    bool? isFilesLoading,
    String? errorMessage,
  }) {
    return DashboardState(
      weather: weather ?? this.weather,
      recentFiles: recentFiles ?? this.recentFiles,
      isWeatherLoading: isWeatherLoading ?? this.isWeatherLoading,
      isFilesLoading: isFilesLoading ?? this.isFilesLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [weather, recentFiles, isWeatherLoading, isFilesLoading, errorMessage];
}

// Cubit
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  Future<void> loadWeather() async {
    emit(state.copyWith(isWeatherLoading: true));
    try {
      final weather = await WeatherService().getWeather();
      emit(state.copyWith(weather: weather, isWeatherLoading: false));
    } catch (e) {
      emit(state.copyWith(isWeatherLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadRecentFiles() async {
    emit(state.copyWith(isFilesLoading: true));
    // ...
  }
}
```

> **Thực tiễn:** Hầu hết màn hình thực tế dùng cách này (một Cubit + state class có nhiều field + `copyWith`).

---

### 5. Bài tập thực hành – Tuần 4

**Nhiệm vụ: Tạo `HomeCubit` với state phức tạp**

`HomeScreen` hiện tại dùng `FutureBuilder` trực tiếp và `RefreshIndicator` không hoạt động. Refactor lại:

**Yêu cầu:**

1. Tạo `HomeState` dùng class đơn với các field:
   - `WeatherData? weather`
   - `bool isLoading`
   - `String? error`
   - Method `copyWith()`

2. Tạo `HomeCubit` với method:
   - `loadWeather()` — gọi Open-Meteo API
   - `refresh()` — gọi lại `loadWeather()` (dùng cho `RefreshIndicator`)

3. Thêm `BlocProvider<HomeCubit>` trong `HomeScreen`

4. Thay `FutureBuilder` bằng `BlocBuilder<HomeCubit, HomeState>`

5. `RefreshIndicator.onRefresh` gọi `context.read<HomeCubit>().refresh()`

**Kiểm tra:** Pull-to-refresh thực sự fetch lại dữ liệu từ API.

---

## 🌐 Giai đoạn 3 – Tuần 5: Gọi API cơ bản

> **Mục tiêu:** Tổ chức API layer đúng cách, kết hợp Dio + Cubit.

---

### 1. Nhắc lại: RESTful API là gì?

**REST** (Representational State Transfer) là kiến trúc API phổ biến nhất hiện nay:

| HTTP Method | Hành động | Ví dụ |
|-------------|-----------|-------|
| `GET` | Đọc dữ liệu | `GET /users/123` |
| `POST` | Tạo mới | `POST /users` |
| `PUT` | Cập nhật toàn bộ | `PUT /users/123` |
| `PATCH` | Cập nhật một phần | `PATCH /users/123` |
| `DELETE` | Xóa | `DELETE /users/123` |

**Response thường là JSON:**

```json
{
  "id": 1,
  "name": "Nguyễn Văn A",
  "email": "a@example.com"
}
```

---

### 2. Tổ chức API layer đúng cách

Hiện tại project gọi Dio thẳng trong widget. Đây là anti-pattern. Cấu trúc chuẩn:

```
lib/
├── core/
│   └── services/
│       └── dio_client.dart        ← Cấu hình Dio một lần
└── features/
    └── home/
        ├── data/
        │   ├── weather_api.dart   ← Định nghĩa các API call
        │   └── weather_model.dart ← Data model + fromJson
        ├── cubit/
        │   ├── home_cubit.dart
        │   └── home_state.dart
        └── home_screen.dart
```

---

### 3. Cấu hình Dio Client tập trung

```dart
// lib/core/services/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Thêm Interceptor để log request/response khi debug
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }
}
```

---

### 4. Tạo API class độc lập (không phụ thuộc Cubit)

```dart
// lib/features/home/data/weather_api.dart
import 'package:dio/dio.dart';
import '../../../core/services/dio_client.dart';

class WeatherApi {
  final Dio _dio;

  WeatherApi() : _dio = DioClient.instance;

  // Phân tách rõ ràng: class này chỉ biết cách gọi API
  // KHÔNG biết gì về Cubit, state, hay UI
  Future<Map<String, dynamic>> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current_weather': true,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
```

---

### 5. Model với `fromJson`

```dart
// lib/features/home/data/weather_model.dart
class WeatherData {
  final double temperature;
  final double windspeed;
  final int weathercode;

  const WeatherData({
    required this.temperature,
    required this.windspeed,
    required this.weathercode,
  });

  // Factory constructor: nhận Map từ JSON, trả về object
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current_weather'] as Map<String, dynamic>;
    return WeatherData(
      temperature: (currentWeather['temperature'] as num).toDouble(),
      windspeed: (currentWeather['windspeed'] as num).toDouble(),
      weathercode: currentWeather['weathercode'] as int,
    );
  }
}
```

---

### 6. Cubit gọi API

```dart
// lib/features/home/cubit/home_cubit.dart
class HomeCubit extends Cubit<HomeState> {
  final WeatherApi _weatherApi;

  // Nhận dependency qua constructor (Dependency Injection cơ bản)
  HomeCubit({WeatherApi? weatherApi})
      : _weatherApi = weatherApi ?? WeatherApi(),
        super(const HomeState());

  Future<void> loadWeather() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final json = await _weatherApi.getWeather(latitude: 21.0285, longitude: 105.8542);
      final weather = WeatherData.fromJson(json);
      emit(state.copyWith(isLoading: false, weather: weather));
    } on DioException catch (e) {
      emit(state.copyWith(isLoading: false, error: _handleDioError(e)));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Kết nối quá hạn, thử lại sau.';
      case DioExceptionType.receiveTimeout:
        return 'Server không phản hồi, thử lại sau.';
      case DioExceptionType.badResponse:
        return 'Lỗi server: ${e.response?.statusCode}';
      default:
        return 'Lỗi kết nối. Kiểm tra internet.';
    }
  }
}
```

---

### 7. Bài tập thực hành – Tuần 5

**Nhiệm vụ: Tái cấu trúc HomeScreen theo đúng layer**

1. Tạo `lib/features/home/data/weather_api.dart` — tách logic Dio ra khỏi widget
2. Tạo `lib/features/home/data/weather_model.dart` — model với `fromJson`
3. Tạo `lib/features/home/cubit/home_cubit.dart` và `home_state.dart`
4. Xóa mọi Dio code khỏi `HomeScreen`
5. `HomeScreen` chỉ dùng `BlocBuilder` để hiển thị từ state

**Bonus task:**
- Thêm màn hình mới: Air Quality screen với một API bất kỳ (gợi ý: `api.open-meteo.com` có endpoint `air_quality`)
- Viết `AirQualityApi`, `AirQualityCubit`, `AirQualityScreen` theo pattern trên

---

## ⚡ Giai đoạn 3 – Tuần 6: Xử lý API Nâng cao

> **Mục tiêu:** Xử lý Authentication, token, error handling toàn diện, và dùng code generation.

---

### 1. Authentication – Bearer Token

Hầu hết API thực tế yêu cầu xác thực qua JWT token. Flow chuẩn:

```
1. User login  →  POST /auth/login  →  nhận { accessToken, refreshToken }
2. Lưu token vào SharedPreferences (đã có StorageService trong project)
3. Mọi request sau:  Authorization: Bearer <accessToken>
4. Nếu token hết hạn (401):  dùng refreshToken để lấy accessToken mới
```

Thêm Authorization header tự động qua Interceptor:

```dart
// Interceptor inject token vào mọi request
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await StorageService().getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options); // tiếp tục request
    },
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        // Token hết hạn — thử refresh
        // ...logic refresh token...
      }
      handler.next(error);
    },
  ),
);
```

---

### 2. Query Parameters và Headers

```dart
// Query parameters (?key=value&key2=value2)
final response = await dio.get(
  'https://api.example.com/products',
  queryParameters: {
    'page': 1,
    'limit': 20,
    'category': 'electronics',
    'sort': 'price_asc',
  },
);
// → GET /products?page=1&limit=20&category=electronics&sort=price_asc

// Custom headers cho một request
final response = await dio.post(
  'https://api.example.com/upload',
  data: formData,
  options: Options(
    headers: {
      'X-Custom-Header': 'value',
      'Content-Type': 'multipart/form-data',
    },
    sendTimeout: const Duration(seconds: 30),
  ),
);
```

---

### 3. Xử lý lỗi toàn diện

```dart
// Phân biệt rõ các loại lỗi
try {
  final response = await dio.get('/endpoint');
} on DioException catch (e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw TimeoutException('Kết nối quá hạn');
    
    case DioExceptionType.badResponse:
      // Lỗi HTTP (4xx, 5xx)
      final statusCode = e.response?.statusCode;
      final message = e.response?.data['message'] ?? 'Lỗi không xác định';
      
      if (statusCode == 401) throw UnauthorizedException(message);
      if (statusCode == 404) throw NotFoundException(message);
      if (statusCode == 422) throw ValidationException(message);
      if (statusCode != null && statusCode >= 500) throw ServerException(message);
      
      throw ApiException(message, statusCode);
    
    case DioExceptionType.cancel:
      // Request bị hủy chủ động — thường không cần báo lỗi
      break;
    
    case DioExceptionType.unknown:
      if (e.error is SocketException) {
        throw NetworkException('Không có kết nối internet');
      }
      rethrow;
  }
}
```

---

### 4. Session Persistence – Vấn đề hiện tại của project

**Vấn đề:** Khi restart app, user bị đẩy về `OnboardingScreen` dù đã login. `StorageService` đã viết nhưng không được gọi.

**Fix cần làm trong `main.dart`:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Kiểm tra session khi khởi động
  final currentUser = FirebaseAuth.instance.currentUser;
  
  runApp(
    MultiBlocProvider(
      providers: [ /* ... */ ],
      child: MyApp(isLoggedIn: currentUser != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoggedIn ? const MainDashboard() : const OnboardingScreen(),
    );
  }
}
```

---

### 5. Code Generation – `freezed` và `json_serializable`

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.9.3
```

**Trước khi dùng freezed:**

```dart
// Viết tay 40 dòng boilerplate...
class WeatherData {
  final double temperature;
  final double windspeed;
  WeatherData({required this.temperature, required this.windspeed});
  
  WeatherData copyWith({double? temperature, double? windspeed}) {
    return WeatherData(
      temperature: temperature ?? this.temperature,
      windspeed: windspeed ?? this.windspeed,
    );
  }
  
  @override
  bool operator ==(Object other) { /* ... */ }
  @override
  int get hashCode => /* ... */;
}
```

**Sau khi dùng freezed:**

```dart
// weather_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    required double temperature,
    required double windspeed,
    required int weathercode,
  }) = _WeatherData;

  // fromJson tự động generate
  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
```

Chạy lệnh generate code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

> freezed tự tạo: `copyWith()`, `==`, `hashCode`, `toString()`, `fromJson()`, `toJson()`.

---

### 6. Bài tập thực hành – Tuần 6

**Nhiệm vụ 1:** Fix auth session persistence trong `main.dart`

**Nhiệm vụ 2:** Fix `MoreScreen` — load và hiển thị thực tế user data từ Firebase
- Lấy `FirebaseAuth.instance.currentUser`
- Hiển thị `user.email` và `user.displayName`

**Nhiệm vụ 3:** Implement logout thực sự trong `MoreScreen`
- Gọi `FirebaseAuth.instance.signOut()`
- Navigate về `OnboardingScreen`

**Nhiệm vụ 4 (Advanced):** Áp dụng `freezed` cho `WeatherData` và các state class trong Cubit

---

## 🏗️ Giai đoạn 4 – Tuần 7: Clean Architecture, BLoC & Git

> **Mục tiêu:** Tổ chức codebase chuẩn, dễ test, dễ bảo trì.

---

### 1. Clean Architecture – Tại sao cần?

Hiện tại project: **Screen → Service → Firebase/Dio**

Vấn đề:
- `LoginScreen` gọi thẳng `AuthService` → Screen bị phụ thuộc vào Firebase
- Nếu đổi Firebase sang backend khác → sửa cả Screen
- Không test được (Screen cần Firebase thật để chạy)

**Clean Architecture** tách thành 3 layer với **dependency rule: layer ngoài phụ thuộc vào layer trong, không bao giờ ngược lại.**

```
┌─────────────────────────────────────────┐
│  PRESENTATION LAYER (UI)                │  ← Widget, Cubit, State
│  - Biết về Domain, KHÔNG biết về Data   │
├─────────────────────────────────────────┤
│  DOMAIN LAYER (Business Logic)          │  ← Entity, UseCase, Repository Interface
│  - KHÔNG biết về Presentation hay Data  │  ← Layer thuần Dart, không import Flutter
├─────────────────────────────────────────┤
│  DATA LAYER (External World)            │  ← API, Firebase, SharedPrefs, Repository Impl
│  - Biết về Domain, KHÔNG biết về Pres.  │
└─────────────────────────────────────────┘
```

---

### 2. Ví dụ cụ thể: Auth Feature theo Clean Architecture

**Cấu trúc file:**

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_data_source.dart   ← Gọi Firebase thực tế
│   ├── models/
│   │   └── user_model.dart                ← JSON model (có fromJson/toJson)
│   └── repositories/
│       └── auth_repository_impl.dart      ← Implement interface từ Domain
├── domain/
│   ├── entities/
│   │   └── user_entity.dart               ← Pure Dart class, không biết JSON
│   ├── repositories/
│   │   └── auth_repository.dart           ← Abstract interface
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── logout_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── auth_cubit.dart
    │   └── auth_state.dart
    └── screens/
        ├── login_screen.dart
        └── signup_screen.dart
```

**Domain Layer – Abstract Repository:**

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
// Đây là CONTRACT (interface) — Domain định nghĩa, Data implement

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({required String email, required String password, required String name});
  Future<void> logout();
  UserEntity? getCurrentUser();
}
```

**Domain Layer – UseCase:**

```dart
// lib/features/auth/domain/usecases/login_usecase.dart
// UseCase đại diện cho MỘT business logic action

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  // Gọi như function (callable class)
  Future<UserEntity> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
```

**Data Layer – Repository Implementation:**

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
// Implement interface từ Domain, biết về Firebase

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    // DataSource trả về UserModel (có fromJson)
    // Repository chuyển đổi sang UserEntity (Domain không biết Model tồn tại)
    final userModel = await _remoteDataSource.login(email: email, password: password);
    return userModel.toEntity(); // Chuyển Model → Entity
  }
}
```

**Presentation Layer – Cubit:**

```dart
// lib/features/auth/presentation/cubit/auth_cubit.dart
// Cubit chỉ biết về Domain UseCase, KHÔNG biết về Repository hay Firebase

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  AuthCubit({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(email: email, password: password);
      emit(AuthSuccess(user: user));
    } on UnauthorizedException catch (e) {
      emit(AuthError(message: e.message));
    }
  }
}
```

---

### 3. Dependency Injection (DI) đơn giản

Không dùng `get_it` cho đơn giản, chỉ cần wire up khi tạo `BlocProvider`:

```dart
// Trong MaterialApp hoặc RouteGenerator:
BlocProvider(
  create: (_) => AuthCubit(
    loginUseCase: LoginUseCase(
      AuthRepositoryImpl(
        AuthRemoteDataSource(),
      ),
    ),
  ),
  child: LoginScreen(),
)
```

---

### 4. BLoC vs Cubit – Khi nào dùng cái nào?

| | Cubit | BLoC |
|---|---|---|
| **Cách trigger** | Gọi method trực tiếp | Gửi Event object |
| **Độ phức tạp** | Đơn giản | Phức tạp hơn |
| **Traceability** | Khó biết tại sao state thay đổi | Event rõ ràng (LoginRequested, LogoutRequested) |
| **Dùng khi** | State change ít, đơn giản | Nhiều input triggers, cần audit trail |

**BLoC cơ bản:**

```dart
// 1. Định nghĩa Events
abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email, password;
  LoginRequested({required this.email, required this.password});
}
class LogoutRequested extends AuthEvent {}

// 2. BLoC xử lý Events
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    // Đăng ký handler cho từng event
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // ...
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    // ...
    emit(AuthInitial());
  }
}

// 3. UI trigger event (không gọi method)
context.read<AuthBloc>().add(LoginRequested(email: email, password: password));
```

---

### 5. Git Workflow khi làm nhóm

#### Branching Strategy (Git Flow đơn giản)

```
main          ← production-ready code
  └── develop ← tích hợp features
        ├── feature/auth-cubit
        ├── feature/home-screen-refactor
        └── fix/logout-not-working
```

**Quy trình làm một feature:**

```bash
# 1. Từ develop, tạo branch mới
git checkout develop
git pull origin develop
git checkout -b feature/auth-cubit

# 2. Làm việc, commit thường xuyên
git add .
git commit -m "feat: add AuthCubit with login/register states"

# 3. Push lên remote
git push origin feature/auth-cubit

# 4. Tạo Merge Request (GitLab) / Pull Request (GitHub) vào develop
# 5. Code review
# 6. Merge sau khi approved
```

#### Commit Message Convention (Conventional Commits)

```
feat: thêm feature mới
fix: sửa bug
refactor: tái cấu trúc code, không đổi chức năng
chore: cập nhật dependency, config
docs: chỉ cập nhật documentation
test: thêm/sửa test
style: format code, không đổi logic
```

#### Resolve Conflict

```bash
# Khi merge bị conflict:
git merge develop         # thử merge
# → CONFLICT trong file X

# Mở file X, tìm markers:
# <<<<<<< HEAD (code của branch bạn)
# =======
# >>>>>>> develop (code từ develop)

# Sửa thủ công, giữ code đúng

git add file_da_fix.dart
git commit -m "fix: resolve merge conflict in auth_cubit"
```

---

### 6. Bài tập thực hành – Tuần 7

**Nhiệm vụ: Refactor Auth feature sang Clean Architecture**

1. Tạo folder structure `data/`, `domain/`, `presentation/` trong `lib/features/auth/`
2. Di chuyển `UserModel` vào `auth/data/models/`
3. Tạo `UserEntity` thuần Dart trong `auth/domain/entities/`
4. Tạo abstract `AuthRepository` interface trong `auth/domain/repositories/`
5. Tạo `LoginUseCase`, `RegisterUseCase`, `LogoutUseCase`
6. Tạo `AuthRepositoryImpl` trong `auth/data/repositories/`
7. Tạo `AuthBloc` (hoặc `AuthCubit`) trong `auth/presentation/cubit/`
8. Kết nối vào `LoginScreen` và `SignupScreen`

**Git task:**
- Làm từng nhiệm vụ trên trong các commit riêng biệt
- Đặt commit message theo convention

---

## 🎓 Giai đoạn 5 – Tuần 8 & 9: Final Project

> **Mục tiêu:** Xây dựng ứng dụng hoàn chỉnh tích hợp toàn bộ kiến thức.

---

### 1. Gợi ý ý tưởng

Dựa trên nền tảng hiện tại của project (Office Companion App), các hướng mở rộng phù hợp:

**Option A: Hoàn thiện Office Companion App**
- Implement Data Bank với Firestore (CRUD files metadata)
- Thêm Profile management (upload avatar, đổi tên)
- Thêm Notifications
- Air Quality widget cho Home Screen
- Settings (theme switching)

**Option B: Xây dựng app mới**
- Task Manager (CRUD tasks, categories, due dates, Firestore)
- Expense Tracker (CRUD expenses, categories, charts)
- Notes App (CRUD notes, rich text, search)

---

### 2. Checklist Final Project

```
Architecture:
[ ] Clean Architecture 3 layer (Presentation/Domain/Data)
[ ] BLoC hoặc Cubit cho state management
[ ] Repository pattern
[ ] Dependency Injection (manual hoặc get_it)

Features:
[ ] Authentication (login/register/logout)
[ ] Ít nhất 1 API call bên ngoài (hoặc Firestore)
[ ] CRUD operations (Create/Read/Update/Delete)
[ ] Error handling (network errors, auth errors)
[ ] Loading states

UI:
[ ] Ít nhất 4 màn hình
[ ] Navigation (named routes hoặc GoRouter)
[ ] Responsive layout (không bị overflow trên các màn hình khác nhau)
[ ] Dark/Light theme support

Code Quality:
[ ] Không có logic trong Widget (chỉ UI code)
[ ] Không có hardcode string API key (dùng .env hoặc config file)
[ ] Consistent naming convention
[ ] Git history rõ ràng với conventional commits

Bonus:
[ ] Unit test cho UseCase layer
[ ] freezed cho Model và State class
[ ] GoRouter cho navigation
[ ] Animations
```

---

### 3. Cấu trúc project gợi ý cho Final Project

```
lib/
├── main.dart
├── firebase_options.dart
├── app/
│   ├── app.dart            ← MaterialApp root
│   └── router.dart         ← GoRouter configuration
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   ├── errors/
│   │   └── exceptions.dart ← Custom exceptions
│   ├── network/
│   │   └── dio_client.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── widgets/            ← Shared reusable widgets
│       ├── glass_card.dart
│       └── gradient_button.dart
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       ├── cubit/ (hoặc bloc/)
    │       └── screens/
    └── [feature_name]/     ← Mỗi feature có cùng structure
        ├── data/
        ├── domain/
        └── presentation/
```

---

## 📚 Tài nguyên học thêm

| Chủ đề | Link |
|--------|------|
| flutter_bloc documentation | https://bloclibrary.dev |
| Cubit tutorial (chính thức) | https://bloclibrary.dev/tutorials/flutter-counter |
| Freezed package | https://pub.dev/packages/freezed |
| Clean Architecture Flutter | https://resocoder.com/flutter-clean-architecture-tdd |
| Conventional Commits | https://www.conventionalcommits.org |
| Dio package | https://pub.dev/packages/dio |
| GoRouter | https://pub.dev/packages/go_router |

---

## 🔄 Checklist theo tuần

### Tuần 3
- [ ] Đọc và hiểu khái niệm Cubit, BlocProvider, BlocBuilder, BlocListener, BlocConsumer
- [ ] Chuyển `NavigationProvider` → `NavigationCubit`
- [ ] Tạo `AuthCubit` với 4 states: `Initial`, `Loading`, `Success`, `Error`
- [ ] Áp dụng `BlocConsumer` vào `LoginScreen`

### Tuần 4
- [ ] Học `Equatable` và cách dùng `copyWith`
- [ ] Tạo `HomeCubit` với `HomeState` dạng single class nhiều field
- [ ] Fix `RefreshIndicator` thực sự gọi lại API
- [ ] Thử dùng `MultiBlocProvider` cho màn hình có nhiều Cubit

### Tuần 5
- [ ] Tạo `DioClient` tập trung
- [ ] Tách `WeatherApi` class độc lập
- [ ] Tạo `WeatherModel` với `fromJson`
- [ ] Xóa Dio code khỏi Widget
- [ ] Xây dựng thêm 1 screen mới với API + Cubit

### Tuần 6
- [ ] Fix auth session persistence (`main.dart`)
- [ ] Fix `MoreScreen` hiển thị user thực
- [ ] Implement logout hoạt động thật sự
- [ ] Áp dụng Interceptor inject Bearer token
- [ ] Cài `freezed` và thử dùng cho 1 model

### Tuần 7
- [ ] Refactor Auth feature sang Clean Architecture 3 layer
- [ ] Học và dùng BLoC (thay hoặc song song với Cubit)
- [ ] Tạo Git branch strategy (`main`/`develop`/`feature/*`)
- [ ] Làm quen với Merge Request + Code Review flow

### Tuần 8-9
- [ ] Lên requirement + wireframe cho Final Project
- [ ] Implement theo checklist ở trên
- [ ] Demo và nhận feedback
