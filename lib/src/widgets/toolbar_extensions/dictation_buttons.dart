part of '../toolbar_widget.dart';

extension DictationButtons on ToolbarWidgetState {
  Widget _dictationButtons(VoiceToTextButtons t) {
    return ToggleButtons(
      constraints: BoxConstraints.tightFor(
        width: widget.toolbarOptions.toolbarItemHeight - 2,
        height: widget.toolbarOptions.toolbarItemHeight - 2,
      ),
      color: widget.toolbarOptions.buttonColor,
      selectedColor: widget.toolbarOptions.buttonSelectedColor,
      fillColor: widget.toolbarOptions.buttonFillColor,
      focusColor: widget.toolbarOptions.buttonFocusColor,
      highlightColor: widget.toolbarOptions.buttonHighlightColor,
      hoverColor: widget.toolbarOptions.buttonHoverColor,
      splashColor: widget.toolbarOptions.buttonSplashColor,
      selectedBorderColor: widget.toolbarOptions.buttonSelectedBorderColor,
      borderColor: widget.toolbarOptions.buttonBorderColor,
      borderRadius: widget.toolbarOptions.buttonBorderRadius,
      borderWidth: widget.toolbarOptions.buttonBorderWidth,
      renderBorder: widget.toolbarOptions.renderBorder,
      textStyle: widget.toolbarOptions.textStyle,
      onPressed: (int index) async {
        if (t.getIcons()[index].icon == Icons.mic_outlined) {
          if (!widget.controller.isRecording) {
            await widget.controller.convertSpeechToText((result) async {
              if (result.isNotEmpty) {
                widget.controller.sttBuffer = result;
                await widget.controller.insertHtml(widget.controller.sttBuffer);
              }
            });
          } else {
            await widget.controller.cancelRecording();
          }
        }
      },
      isSelected: [widget.controller.isRecording],
      children: t.getIcons(),
    );
  }
}
