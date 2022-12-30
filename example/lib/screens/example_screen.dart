import 'package:m7_livelyness_detection_example/index.dart';

class M7ExpampleScreen extends StatefulWidget {
  const M7ExpampleScreen({super.key});

  @override
  State<M7ExpampleScreen> createState() => _M7ExpampleScreenState();
}

class _M7ExpampleScreenState extends State<M7ExpampleScreen> {
  //* MARK: - Private Variables
  //? =========================================================
  String? _capturedImagePath;
  final bool _isLoading = false;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _onStartLivelyness() async {
    setState(() => _capturedImagePath = null);
    final String? response =
        await M7LivelynessDetection.instance.detectLivelyness(
      context,
      config: M7DetectionConfig(
        steps: [
          M7LivelynessStepItem(
            step: M7LivelynessStep.blink,
            title: "Blink",
            isCompleted: false,
          ),
          M7LivelynessStepItem(
            step: M7LivelynessStep.smile,
            title: "Smile",
            isCompleted: false,
          ),
        ],
        startWithInfoScreen: true,
      ),
    );
    if (response == null) {
      return;
    }
    setState(
      () => _capturedImagePath = response,
    );
  }

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "M7 Livelyness Detection",
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildContent(),
        Visibility(
          visible: _isLoading,
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(
          flex: 4,
        ),
        Visibility(
          visible: _capturedImagePath != null,
          child: Expanded(
            flex: 7,
            child: Image.file(
              File(_capturedImagePath ?? ""),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Visibility(
          visible: _capturedImagePath != null,
          child: const Spacer(),
        ),
        Center(
          child: ElevatedButton(
            onPressed: _onStartLivelyness,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
            ),
            child: const Text(
              "Detect Livelyness",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const Spacer(
          flex: 6,
        ),
      ],
    );
  }
}
