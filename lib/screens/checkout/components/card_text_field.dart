import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  CardTextField({
    this.title,
    this.bold = false,
    this.hint,
    this.textInputType,
    this.inputFormatters,
    this.validator,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.onSubmitted,
    this.onSaved,
    this.inicialValue
  }) : textInpuAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next;

  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final TextInputAction textInpuAction;
  final FormFieldSetter<String> onSaved;
  final String inicialValue;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        initialValue: inicialValue,
        validator: validator,
        builder: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      if (state.hasError)
                        Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red, fontSize: 9),
                        ),
                    ],
                  ),
                TextFormField(
                  onSaved: onSaved,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: title == null && state.hasError
                        ? Colors.red
                        : Colors.white,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: title == null && state.hasError
                          ? Colors.red.withAlpha(200)
                          : Colors.white.withAlpha(100),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    counterText: '',
                  ),
                  keyboardType: textInputType,
                  inputFormatters: inputFormatters,
                  onChanged: (text) {
                    state.didChange(text);
                  },
                  maxLength: maxLength,
                  textAlign: textAlign,
                  focusNode: focusNode,
                  onFieldSubmitted: onSubmitted,
                  textInputAction: textInpuAction,
                  initialValue: inicialValue,
                )
              ],
            ),
          );
        });
  }
}
