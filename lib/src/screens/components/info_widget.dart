import 'package:m7_livelyness_detection/index.dart';

class M7LivelynessInfoWidget extends StatefulWidget {
  final VoidCallback onStartTap;
  const M7LivelynessInfoWidget({
    required this.onStartTap,
    super.key,
  });

  @override
  State<M7LivelynessInfoWidget> createState() => _M7LivelynessInfoWidgetState();
}

class _M7LivelynessInfoWidgetState extends State<M7LivelynessInfoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(
            flex: 2,
          ),
          Text(
            M7StringConstants.label.livelyNessDetection,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const Spacer(),
          Text(
            M7StringConstants.label.infoSubText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.normal,
              fontSize: 18,
              height: 1.5,
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                color: Colors.transparent,
                child: Lottie.asset(
                  M7AssetConstants.lottie.livelynessStart,
                  package: M7AssetConstants.packageName,
                  animate: true,
                  repeat: true,
                  reverse: false,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 2.5,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Container(
                            child: _buildPointWidget(
                              index: 1,
                              title: M7StringConstants.label.goodLighting,
                              subTitle:
                                  M7StringConstants.label.goodLightingSubText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: _buildPointWidget(
                            index: 2,
                            title: M7StringConstants.label.lookStraight,
                            subTitle:
                                M7StringConstants.label.lookStraightSubText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => widget.onStartTap(),
              style: TextButton.styleFrom(
                elevation: 3,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                M7StringConstants.button.start,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPointWidget({
    required int index,
    required String title,
    required String subTitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade900,
          child: Text(
            "$index",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // const Spacer(),
              Expanded(
                flex: 10,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    subTitle,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
