import 'package:flutter/material.dart';
import 'package:optimistic_state/src/view/subscribe/viewmodel/subscribe_viewmodel.dart';

class SubscribeButtonStyle {
  static const unsubscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.red),
  );

  static const subscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.green),
  );
}

class SubscribePage extends StatefulWidget {
  const SubscribePage({
    required this.viewModel,
    super.key,
  });

  final SubscribeViewModel viewModel;

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {

  /// Listen to ViewModel changes.
  void _onViewModelChange() {
    // If the subscription action has failed
    if (widget.viewModel.error) {
      // Reset the error state
      widget.viewModel.error = false;
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to subscribe'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Subscribe Page'),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return FilledButton(
                  onPressed: widget.viewModel.subscribe,
                  style: widget.viewModel.subscribed
                      ? SubscribeButtonStyle.subscribed
                      : SubscribeButtonStyle.unsubscribed,
                  child: widget.viewModel.subscribed
                      ? const Text('Subscribed')
                      : const Text('Subscribe'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
