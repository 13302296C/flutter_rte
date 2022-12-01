part of '../toolbar_widget.dart';

extension DictationButtons on ToolbarWidgetState {
  Widget _dictationButtons(VoiceToTextButtons t) {
    return ToggleButtons(
      constraints: BoxConstraints.tightFor(
        width: widget.htmlToolbarOptions.toolbarItemHeight - 2,
        height: widget.htmlToolbarOptions.toolbarItemHeight - 2,
      ),
      color: widget.htmlToolbarOptions.buttonColor,
      selectedColor: widget.htmlToolbarOptions.buttonSelectedColor,
      fillColor: widget.htmlToolbarOptions.buttonFillColor,
      focusColor: widget.htmlToolbarOptions.buttonFocusColor,
      highlightColor: widget.htmlToolbarOptions.buttonHighlightColor,
      hoverColor: widget.htmlToolbarOptions.buttonHoverColor,
      splashColor: widget.htmlToolbarOptions.buttonSplashColor,
      selectedBorderColor: widget.htmlToolbarOptions.buttonSelectedBorderColor,
      borderColor: widget.htmlToolbarOptions.buttonBorderColor,
      borderRadius: widget.htmlToolbarOptions.buttonBorderRadius,
      borderWidth: widget.htmlToolbarOptions.buttonBorderWidth,
      renderBorder: widget.htmlToolbarOptions.renderBorder,
      textStyle: widget.htmlToolbarOptions.textStyle,
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
