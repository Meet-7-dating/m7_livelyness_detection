import 'package:m7_livelyness_detection_example/index.dart';

class TestScreen extends StatefulWidget {
  final M7DetectionConfig config;
  const TestScreen({
    required this.config,
    super.key,
  });

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final bool _isInfoStepCompleted;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _preInitCallBack();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _postFrameCallBack(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _preInitCallBack() {
    _isInfoStepCompleted = !widget.config.startWithInfoScreen;
  }

  void _postFrameCallBack() {}

  //* MARK: - Private Methods for UI Components
  //? =========================================================

  Widget _buildBody() {
    return _isInfoStepCompleted
        ? Container(
            color: Colors.blue,
            height: double.infinity,
            width: double.infinity,
          )
        : _buildInfoScreen();
  }

  Widget _buildInfoScreen() {
    return M7LivelynessInfoWidget(
      onStartTap: () {},
    );
  }
}
