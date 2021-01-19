import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const EdgeInsets textFieldPadding = EdgeInsets.all(16);
const EdgeInsets iconPadding = EdgeInsets.fromLTRB(12, 0, 12, 0);

class MailClientOpenErrorDialog extends StatelessWidget {
  final String url;

  const MailClientOpenErrorDialog({Key key, @required this.url})
      : assert(url != null),
        assert(url != ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Launch Error'),
      content: Text('We could not launch the following url:\n$url'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class BodyTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const BodyTextField({
    Key key,
    @required this.onChanged,
  })  : assert(onChanged != null),
        super(key: key);

  @override
  _BodyTextFieldState createState() => _BodyTextFieldState();
}

class _BodyTextFieldState extends State<BodyTextField> {
  final TextEditingController _controller = TextEditingController();

  bool isEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SectionHeading(
          leadingIcon: CupertinoIcons.book,
          title: 'body',
          trailingIcon:
              isEnabled ? CupertinoIcons.delete : CupertinoIcons.add_circled,
          onPressed: () {
            setState(() => isEnabled = !isEnabled);
            _controller.text = '';
            if (isEnabled) {
              widget.onChanged(_controller.text);
            } else {
              widget.onChanged(null);
            }
          },
        ),
        if (isEnabled)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: CupertinoTextField(
              controller: _controller,
              padding: textFieldPadding,
              minLines: 4,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              placeholder: 'Body of the email',
              onChanged: widget.onChanged,
            ),
          ),
      ],
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leadingIcon;
  final IconData trailingIcon;

  const SectionHeading({
    Key key,
    @required this.title,
    @required this.onPressed,
    @required this.leadingIcon,
    @required this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: iconPadding,
                child: Icon(leadingIcon),
              ),
              LargeText(title),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: CupertinoButton(
              child: Icon(trailingIcon),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SubjectTextField({
    Key key,
    @required this.onChanged,
  })  : assert(onChanged != null),
        super(key: key);

  @override
  _SubjectTextFieldState createState() => _SubjectTextFieldState();
}

class _SubjectTextFieldState extends State<SubjectTextField> {
  final TextEditingController _controller = TextEditingController();

  bool isEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SectionHeading(
          leadingIcon: CupertinoIcons.mail,
          title: 'subject',
          trailingIcon:
              isEnabled ? CupertinoIcons.delete : CupertinoIcons.add_circled,
          onPressed: () {
            setState(() => isEnabled = !isEnabled);
            _controller.text = '';
            if (isEnabled) {
              widget.onChanged(_controller.text);
            } else {
              widget.onChanged(null);
            }
          },
        ),
        if (isEnabled)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: CupertinoTextField(
              controller: _controller,
              padding: textFieldPadding,
              textCapitalization: TextCapitalization.words,
              placeholder: 'Subject of the email',
              onChanged: widget.onChanged,
            ),
          ),
      ],
    );
  }
}

class LargeText extends StatelessWidget {
  final String data;

  const LargeText(this.data, {Key key})
      : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        data,
        style: CupertinoTheme.of(context)
            .textTheme
            .navLargeTitleTextStyle
            .copyWith(color: CupertinoColors.black),
      ),
    );
  }
}

class EmailsContainer extends StatefulWidget {
  const EmailsContainer({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.onChanged,
    @required this.placeholder,
  }) : super(key: key);

  final String title;
  final String placeholder;
  final IconData icon;
  final ValueChanged<List<String>> onChanged;

  @override
  _EmailsContainerState createState() => _EmailsContainerState();
}

class _EmailsContainerState extends State<EmailsContainer> {
  final List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SectionHeading(
          leadingIcon: widget.icon,
          trailingIcon: CupertinoIcons.plus_circled,
          title: widget.title,
          onPressed: () {
            setState(() {
              _controllers.add(TextEditingController(text: ''));
            });
            callOnChanged();
          },
        ),
        ...buildTextFields(),
      ],
    );
  }

  void callOnChanged() {
    widget.onChanged(_controllers.map((c) => c.text.trim()).toList());
  }

  void removeController(int index) {
    assert(index >= 0);
    assert(index < _controllers.length);
    setState(() => _controllers.removeAt(index));
    callOnChanged();
  }

  List<Widget> buildTextFields() {
    final widgets = <Widget>[];
    _controllers.asMap().forEach((index, controller) {
      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: CupertinoTextField(
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          padding: textFieldPadding,
          suffix: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => removeController(index),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Icon(CupertinoIcons.minus_circled),
            ),
          ),
          textCapitalization: TextCapitalization.none,
          placeholder: '${widget.placeholder} ${index + 1}',
          onChanged: (_) => callOnChanged(),
        ),
      ));
    });
    return widgets;
  }
}
